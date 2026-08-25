use std::collections::HashMap;

use crate::analyzer::TypeId;
use crate::ast::{
    Architecture, AstArena, BinaryOp, ConcurrentStmt, ContextItem, Decl, Entity, Expr, Port,
    SequentialStmt, UnaryOp,
};
use crate::elaborator::{ElaboratedDesign, ElaboratedSequentialStmt, LibraryRegistry};
use crate::parser::Span;
use crate::{
    analyzer::{SemanticAnalyzer, SymbolId},
    elaborator::{
        ElaboratedArena, ElaboratedConcurrentAssignment, ElaboratedPort, ElaboratedProcess,
        ElaboratedSignal, Elaborator, ElaboratorError, Environment, EvaluatedExpr, EvaluatedValue,
        ExprId, InstanceId, InstanceNode, PortBinding, ProcessId, SignalId,
    },
};

impl<'a> Elaborator<'a> {
    pub fn new(ast: &'a AstArena<'a>, sa: &'a SemanticAnalyzer<'a>) -> Self {
        Self {
            ast,
            sa,
            arena: ElaboratedArena::default(),
            instance_counter: 0,
        }
    }

    pub fn elaborate_top(
        &mut self,
        top_entity_name: &str,
        registry: &LibraryRegistry,
    ) -> Result<ElaboratedDesign, ElaboratorError> {
        let entity = self
            .ast
            .entities
            .iter()
            .find(|e| e.name == top_entity_name)
            .ok_or_else(|| ElaboratorError::EntityNotFound(top_entity_name.to_string()))?;

        let arch = self
            .ast
            .architectures
            .iter()
            .find(|a| {
                let span_text = &self.sa.source[a.entity_name.start..a.entity_name.end];
                span_text == top_entity_name
            })
            .ok_or_else(|| ElaboratorError::ArchitectureNotFound(top_entity_name.to_string()))?;

        let mut top_env = Environment::new();
        self.elaborate_context_items(&mut top_env, registry)?;

        let top_sym = self.get_symbol_unw(top_entity_name);
        let top_inst_id =
            self.elaborate_instance(top_sym, entity, arch, &HashMap::new(), "top", &mut top_env)?;

        let top_node = self.arena.instances[top_inst_id.0 as usize].clone();
        Ok(ElaboratedDesign {
            top_instance: top_node,
        })
    }

    fn elaborate_instance(
        &mut self,
        instance_name: SymbolId,
        entity: &Entity<'a>,
        arch: &Architecture<'a>,
        generic_overrides: &HashMap<SymbolId, EvaluatedValue>,
        path: &str,
        parent_env: &mut Environment,
    ) -> Result<InstanceId, ElaboratorError> {
        let mut local_env = Environment::new();

        let evaluated_generics =
            self.elaborate_generics(entity, generic_overrides, &mut local_env)?;

        let ports = self.elaborate_ports(entity, parent_env, &mut local_env)?;
        let local_signals = self.elaborate_declarations(arch, &mut local_env)?;

        // Concurrent Statements
        let mut processes = Vec::new();
        let mut concurrent_assignments = Vec::new();
        let mut children = Vec::new();

        for stmt in self.ast.conc_statements(arch.stmts.clone()) {
            match stmt {
                ConcurrentStmt::ConcurrentAssignment {
                    target,
                    expression,
                    after,
                    ..
                } => {
                    let target_sig = self.resolve_expr_signal(*target, &local_env)?;
                    let expr_id = self.lower_expr(*expression, &local_env)?;
                    let delay_expr = after
                        .map(|delay_ast_id| self.lower_expr(delay_ast_id, &local_env))
                        .transpose()?;
                    concurrent_assignments.push(ElaboratedConcurrentAssignment {
                        target_signal: target_sig,
                        value_expr: expr_id,
                        delay_expr,
                    });
                }
                ConcurrentStmt::ConditionalAssignment { .. } => {
                    todo!()
                }
                ConcurrentStmt::Process {
                    stmts,
                    process_vars,
                    label,
                    ..
                } => {
                    let process_name_str = match label {
                        Some(lbl) => lbl.to_string(),
                        None => {
                            // Generate a unique, illegal-in-VHDL name so it never clashes with user code
                            format!("_unlabeled_process_{}", stmts.start)
                        }
                    };
                    // let proc_id = self.elaborate_process(
                    //     label.unwrap_or("anon_process"),
                    //     process_vars,
                    //     *stmts,
                    //     &local_env,
                    // )?;
                    // processes.push(proc_id);
                }
                ConcurrentStmt::ComponentInstantiation {
                    label,
                    component_name,
                    arch_qualifier,
                    generic_map,
                    port_map,
                } => {
                    //Something like this
                    // let child_id = self.elaborate_component_instantiation(
                    //     label,
                    //     component_name,
                    //     generic_map,
                    //     port_map_span,
                    //     path,
                    //     &mut local_env,
                    // )?;
                    // children.push(child_id);
                    todo!();
                }
            }
        }

        let node = InstanceNode {
            instance_name,
            entity_name: self.get_symbol_unw(entity.name),
            architecture_name: self.get_symbol_unw(arch.name),
            hierarchical_path: path.to_string(),
            generics: evaluated_generics,
            ports,
            port_bindings: Vec::new(),
            local_signals,
            local_constants: local_env.constants.clone(),
            concurrent_assignments,
            processes,
            children,
        };

        let inst_id = InstanceId(self.arena.instances.len() as u32);
        self.arena.instances.push(node);
        Ok(inst_id)
    }

    fn elaborate_generics(
        &mut self,
        entity: &Entity<'a>,
        overrides: &HashMap<SymbolId, EvaluatedValue>,
        env: &mut Environment,
    ) -> Result<HashMap<SymbolId, EvaluatedValue>, ElaboratorError> {
        let mut resolved = HashMap::new();
        let decl_slice =
            &self.ast.decls[entity.generics_start.0 as usize..entity.generics_end.0 as usize];

        for decl in decl_slice {
            if let Decl::Constant {
                //TODO check if it's correct
                name,
                default_val,
                ..
            } = decl
            {
                let sym = self.get_symbol_unw(name);
                let val = if let Some(val_override) = overrides.get(&sym) {
                    val_override.clone()
                } else if let Some(expr_id) = default_val {
                    self.eval_const_expr(*expr_id, env)?
                } else {
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Generic parameter '{}' missing default value", name),
                        span: Span { start: 0, end: 0 }, //TODO
                    });
                };
                env.insert_constant(sym, val.clone());
                resolved.insert(sym, val);
            }
        }
        Ok(resolved)
    }

    fn resolve_port_type(&self, port: &Port<'a>) -> Result<TypeId, ElaboratorError> {
        self.sa
            .expr_types
            .get(port.port_type.0 as usize)
            .copied()
            .ok_or_else(|| ElaboratorError::EvaluationFailed {
                reason: format!("Failed to resolve type for port '{}'", port.name),
                span: port.name_span,
            })
    }

    fn elaborate_ports(
        &mut self,
        entity: &Entity<'a>,
        parent_env: &Environment,
        local_env: &mut Environment,
    ) -> Result<Vec<ElaboratedPort>, ElaboratorError> {
        let mut ports = Vec::new();
        let port_slice =
            &self.ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];

        for port in port_slice {
            let type_id = self.resolve_port_type(port)?;
            let sym = self.get_symbol_unw(port.name);
            let sig_id = self.arena.alloc_signal(ElaboratedSignal {
                name: sym,
                type_id, // Populated via SA resolution
                high_bound: 0,
                low_bound: 0,
                driver_count: 0,
            });
            local_env.insert_signal(sym, sig_id);
            ports.push(ElaboratedPort {
                name: sym,
                mode: port.mode,
                type_id,
                high_bound: 0, //TODO
                low_bound: 0,
            });
        }
        Ok(ports)
    }

    fn elaborate_declarations(
        &mut self,
        arch: &Architecture<'a>,
        env: &mut Environment,
    ) -> Result<Vec<SignalId>, ElaboratorError> {
        let mut signals = Vec::new();
        let decl_slice = &self.ast.decls[arch.decls_start.0 as usize..arch.decls_end.0 as usize];

        for decl in decl_slice {
            match decl {
                Decl::Signal { name, .. } => {
                    let sym = self.get_symbol_unw(name);
                    let sig_id = self.arena.alloc_signal(ElaboratedSignal {
                        name: sym,
                        type_id: TypeId(0), //TODO
                        high_bound: 0,
                        low_bound: 0,
                        driver_count: 0,
                    });
                    env.insert_signal(sym, sig_id);
                    signals.push(sig_id);
                }
                Decl::Constant {
                    name, default_val, ..
                } => {
                    if let Some(expr_id) = default_val {
                        let sym = self.get_symbol_unw(name);
                        let val = self.eval_const_expr(*expr_id, env)?;
                        env.insert_constant(sym, val);
                    }
                }
                _ => {
                    todo!()
                }
            }
        }
        Ok(signals)
    }

    fn elaborate_process(
        &mut self,
        label: &str,
        sensitivities: &[crate::ast::ExprId],
        stmts_range: std::ops::Range<u32>,
        env: &Environment,
    ) -> Result<ProcessId, ElaboratorError> {
        let proc_sym = self.get_symbol_unw(label);
        let mut sens_ids = Vec::new();
        for sens in sensitivities {
            sens_ids.push(self.resolve_expr_signal(*sens, env)?);
        }

        let mut proc_env = env.extend();
        let mut lowered_stmts = Vec::new();

        for stmt in self.ast.seq_statements(stmts_range) {
            self.lower_sequential_stmt(stmt, &mut proc_env, &mut lowered_stmts)?;
        }

        let proc_id = ProcessId(self.arena.processes.len() as u32);
        self.arena.processes.push(ElaboratedProcess {
            label: proc_sym,
            sensitivity_list: sens_ids,
            body_stmts: lowered_stmts,
        });

        Ok(proc_id)
    }

    fn lower_sequential_stmt(
        &mut self,
        stmt: &SequentialStmt<'a>,
        env: &mut Environment,
        out_stmts: &mut Vec<ElaboratedSequentialStmt>,
    ) -> Result<(), ElaboratorError> {
        match stmt {
            SequentialStmt::SequentialAssignment {
                target,
                expression,
                after,
            } => {
                let sig_id = self.resolve_expr_signal(*target, env)?;
                let val_expr = self.lower_expr(*expression, env)?;
                out_stmts.push(ElaboratedSequentialStmt::SignalAssignment {
                    target: sig_id,
                    value_expr: val_expr,
                });
            }
            SequentialStmt::VariableAssignment { target, expression } => {
                let sym = self.resolve_expr_symbol(*target)?;
                let val_expr = self.lower_expr(*expression, env)?;
                out_stmts.push(ElaboratedSequentialStmt::VariableAssignment {
                    target_symbol: sym,
                    value_expr: val_expr,
                });
            }

            _ => {
                unimplemented!()
            }
        }
        Ok(())
    }

    fn lower_conditional_assignment(
        &mut self,
        target_sig: SignalId,
        when_branches: &[(crate::ast::ExprId, crate::ast::ExprId)],
        else_branch: Option<crate::ast::ExprId>,
        env: &Environment,
    ) -> Result<ElaboratedProcess, ElaboratorError> {
        let proc_sym = self.get_symbol_unw("cond_assign_proc");
        let mut stmts = Vec::new();

        let mut current_else: Option<Vec<ElaboratedSequentialStmt>> =
            if let Some(else_expr_id) = else_branch {
                let val_expr = self.lower_expr(else_expr_id, env)?;
                Some(vec![ElaboratedSequentialStmt::SignalAssignment {
                    target: target_sig,
                    value_expr: val_expr,
                }])
            } else {
                None
            };

        for (val_ast, cond_ast) in when_branches.iter().rev() {
            let cond_expr = self.lower_expr(*cond_ast, env)?;
            let val_expr = self.lower_expr(*val_ast, env)?;

            let then_branch = vec![ElaboratedSequentialStmt::SignalAssignment {
                target: target_sig,
                value_expr: val_expr,
            }];

            current_else = Some(vec![ElaboratedSequentialStmt::If {
                condition: cond_expr,
                then_branch,
                else_branch: current_else,
            }]);
        }

        if let Some(lowered_if) = current_else {
            stmts = lowered_if;
        }

        Ok(ElaboratedProcess {
            label: proc_sym,
            sensitivity_list: Vec::new(),
            body_stmts: stmts,
        })
    }

    fn elaborate_component_instantiation(
        &mut self,
        label: &str,
        component_name: &str,
        generic_map: &[(crate::ast::ExprId, crate::ast::ExprId)],
        port_map: &[(crate::ast::ExprId, crate::ast::ExprId)],
        parent_path: &str,
        parent_env: &mut Environment,
    ) -> Result<InstanceId, ElaboratorError> {
        let child_entity = self
            .ast
            .entities
            .iter()
            .find(|e| e.name == component_name)
            .ok_or_else(|| ElaboratorError::EntityNotFound(component_name.to_string()))?;

        let child_arch = self
            .ast
            .architectures
            .iter()
            .find(|a| {
                let span_text = &self.sa.source[a.entity_name.start..a.entity_name.end];
                span_text == component_name
            })
            .ok_or_else(|| ElaboratorError::ArchitectureNotFound(component_name.to_string()))?;

        let mut evaluated_overrides = HashMap::new();
        for (formal_expr, actual_expr) in generic_map {
            let formal_sym = self.resolve_expr_symbol(*formal_expr)?;
            let actual_val = self.eval_const_expr(*actual_expr, parent_env)?;
            evaluated_overrides.insert(formal_sym, actual_val);
        }

        let child_path = format!("{}/{}", parent_path, label);
        let inst_sym = self.get_symbol_unw(label);

        let child_id = self.elaborate_instance(
            inst_sym,
            child_entity,
            child_arch,
            &evaluated_overrides,
            &child_path,
            parent_env,
        )?;

        // Map parent physical wires to child ports
        for (formal_expr, actual_expr) in port_map {
            let formal_sym = self.resolve_expr_symbol(*formal_expr)?;
            let actual_sig = self.resolve_expr_signal(*actual_expr, parent_env)?;

            let child_node = &mut self.arena.instances[child_id.0 as usize];
            child_node.port_bindings.push(PortBinding {
                port_name: formal_sym,
                actual_signal: actual_sig,
            });
        }

        Ok(child_id)
    }

    pub fn eval_const_expr(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<EvaluatedValue, ElaboratorError> {
        let expr = &self.ast.exprs[expr_id.0 as usize];
        match expr {
            Expr::Literal { text, span } => {
                if *text == "true" || *text == "false" {
                    Ok(EvaluatedValue::Boolean(*text == "true"))
                } else if text.starts_with('\'') && text.ends_with('\'') {
                    let sym = self
                        .sa
                        .symbols
                        .interner
                        .get_symbol(text)
                        .ok_or_else(|| ElaboratorError::SymbolNotFound(text.to_string()))?;
                    Ok(EvaluatedValue::EnumLiteral(sym))
                } else if let Ok(val) = text.parse::<i64>() {
                    Ok(EvaluatedValue::Integer(val))
                } else {
                    Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Unsupported or invalid literal '{}'", text),
                        span: *span,
                    })
                }
            }
            Expr::Identifier { name, .. } => {
                let sym = self.get_symbol_unw(name);
                if let Some(val) = env.lookup_constant(sym) {
                    Ok(val.clone())
                } else {
                    Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Constant identifier '{}' not found in environment", name),
                        span: expr.span(),
                    })
                }
            }
            Expr::Binary { op, lhs, rhs, .. } => {
                let left_val = self.eval_const_expr(*lhs, env)?;
                let right_val = self.eval_const_expr(*rhs, env)?;
                match (left_val, right_val, op) {
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Add) => {
                        Ok(EvaluatedValue::Integer(l + r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Sub) => {
                        Ok(EvaluatedValue::Integer(l - r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Mul) => {
                        Ok(EvaluatedValue::Integer(l * r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Div) => {
                        if r == 0 {
                            return Err(ElaboratorError::EvaluationFailed {
                                reason: "Division by zero".to_string(),
                                span: expr.span(),
                            });
                        }
                        Ok(EvaluatedValue::Integer(l / r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Eq) => {
                        Ok(EvaluatedValue::Boolean(l == r))
                    }
                    _ => Err(ElaboratorError::EvaluationFailed {
                        reason: "Unsupported constant binary operation".to_string(),
                        span: expr.span(),
                    }),
                }
            }
            Expr::Unary {
                op,
                expr: inner_expr,
                ..
            } => {
                let val = self.eval_const_expr(*inner_expr, env)?;
                match (val, op) {
                    (EvaluatedValue::Integer(v), UnaryOp::Neg) => Ok(EvaluatedValue::Integer(-v)),
                    (EvaluatedValue::Boolean(v), UnaryOp::Not) => Ok(EvaluatedValue::Boolean(!v)),
                    _ => Err(ElaboratorError::EvaluationFailed {
                        reason: "Unsupported constant unary operation".to_string(),
                        span: expr.span(),
                    }),
                }
            }
            Expr::Grouping { expr: inner, .. } => self.eval_const_expr(*inner, env),
            Expr::CallOrIndex { callee, args, .. } => {
                let callee_sym = self.resolve_expr_symbol(*callee)?;
                let callee_name = self.sa.symbols.interner.get(callee_sym);

                let arg_slice = &self.ast.expr_lists[args.start as usize..args.end as usize];
                let eval_args: Result<Vec<EvaluatedValue>, ElaboratorError> = arg_slice
                    .iter()
                    .map(|&arg_id| self.eval_const_expr(arg_id, env))
                    .collect();
                let eval_args = eval_args?;

                match callee_name {
                    "to_unsigned" | "to_signed" => {
                        if eval_args.len() != 2 {
                            return Err(ElaboratorError::EvaluationFailed {
                                reason: format!(
                                    "'{}' requires 2 arguments (value, size)",
                                    callee_name
                                ),
                                span: expr.span(),
                            });
                        }
                        match (&eval_args[0], &eval_args[1]) {
                            (EvaluatedValue::Integer(val), EvaluatedValue::Integer(size)) => {
                                let size = *size as usize;
                                let bits = (0..size)
                                    .rev()
                                    .map(|i| EvaluatedValue::Integer((val >> i) & 1))
                                    .collect();
                                Ok(EvaluatedValue::Vector(bits))
                            }
                            _ => Err(ElaboratorError::EvaluationFailed {
                                reason: format!("'{}' requires integer arguments", callee_name),
                                span: expr.span(),
                            }),
                        }
                    }
                    "to_integer" => {
                        if eval_args.len() != 1 {
                            return Err(ElaboratorError::EvaluationFailed {
                                reason: "'to_integer' requires exactly 1 argument".into(),
                                span: expr.span(),
                            });
                        }
                        match &eval_args[0] {
                            EvaluatedValue::Vector(bits) => {
                                let mut num = 0i64;
                                for bit in bits {
                                    if let EvaluatedValue::Integer(b) = bit {
                                        num = (num << 1) | (*b & 1);
                                    }
                                }
                                Ok(EvaluatedValue::Integer(num))
                            }
                            EvaluatedValue::Integer(v) => Ok(EvaluatedValue::Integer(*v)),
                            _ => Err(ElaboratorError::EvaluationFailed {
                                reason: "'to_integer' expects vector or integer argument".into(),
                                span: expr.span(),
                            }),
                        }
                    }
                    other => Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Unsupported compile-time function call '{}'", other),
                        span: expr.span(),
                    }),
                }
            }
            Expr::PhysicalLiteral { value, unit, span } => {
                let quantity = match self.eval_const_expr(*value, env)? {
                    EvaluatedValue::Integer(val) => val,
                    _ => {
                        return Err(ElaboratorError::EvaluationFailed {
                            reason: "Physical literal multiplier must evaluate to an integer"
                                .to_string(),
                            span: *span,
                        });
                    }
                };

                let scale_factor: i64 = match unit.to_lowercase().as_str() {
                    "fs" => 1,
                    "ps" => 1_000,
                    "ns" => 1_000_000,
                    "us" => 1_000_000_000,
                    "ms" => 1_000_000_000_000,
                    "sec" | "s" => 1_000_000_000_000_000,
                    "min" => 60 * 1_000_000_000_000_000,
                    "hr" => 3600 * 1_000_000_000_000_000,
                    _ => {
                        return Err(ElaboratorError::EvaluationFailed {
                            reason: format!("Unknown physical unit '{}'", unit),
                            span: *span,
                        });
                    }
                };

                let total_fs = quantity.checked_mul(scale_factor).ok_or_else(|| {
                    ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Overflow while evaluating physical literal '{} {}'",
                            quantity, unit
                        ),
                        span: *span,
                    }
                })?;

                Ok(EvaluatedValue::Integer(total_fs))
            }
            a => Err(ElaboratorError::EvaluationFailed {
                reason: format!(
                    "Non-static expression encountered during evaluation: {}\n Debug: {:?}",
                    self.sa.get_text(&expr.span()),
                    a
                ),
                span: expr.span(),
            }),
        }
    }

    // lowers an expression into the elaborator expression variant
    fn lower_expr(
        &mut self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<ExprId, ElaboratorError> {
        let expr = &self.ast.exprs[expr_id.0 as usize];
        let lowered =
            match expr {
                Expr::Literal { text, .. } => {
                    let val =
                        if let Ok(i) = text.parse::<i64>() {
                            EvaluatedValue::Integer(i)
                        } else if *text == "true" || *text == "false" {
                            EvaluatedValue::Boolean(*text == "true")
                        } else if text.starts_with('\'') && text.ends_with('\'') {
                            let sym =
                                self.sa.symbols.interner.get_symbol(text).ok_or_else(|| {
                                    ElaboratorError::SymbolNotFound(text.to_string())
                                })?;
                            EvaluatedValue::EnumLiteral(sym)
                        } else {
                            // Fallback for enumerated identifier literals (e.g., state names like IDLE)
                            let sym =
                                self.sa.symbols.interner.get_symbol(text).ok_or_else(|| {
                                    ElaboratorError::SymbolNotFound(text.to_string())
                                })?;
                            EvaluatedValue::EnumLiteral(sym)
                        };
                    EvaluatedExpr::Literal(val)
                }
                Expr::Identifier { name, .. } => {
                    let sym = self.get_symbol_unw(name);
                    if let Some(sig_id) = env.lookup_signal(sym) {
                        EvaluatedExpr::SignalRead(sig_id)
                    } else if let Some(val) = env.lookup_constant(sym) {
                        EvaluatedExpr::Literal(val.clone())
                    } else {
                        return Err(ElaboratorError::SignalNotFound(name.to_string()));
                    }
                }
                Expr::Binary { op, lhs, rhs, .. } => {
                    let l_id = self.lower_expr(*lhs, env)?;
                    let r_id = self.lower_expr(*rhs, env)?;
                    EvaluatedExpr::BinaryOp {
                        lhs: l_id,
                        op: *op,
                        rhs: r_id,
                    }
                }
                Expr::Unary { op, expr, .. } => {
                    let inner_id = self.lower_expr(*expr, env)?;
                    EvaluatedExpr::UnaryOp {
                        op: *op,
                        expr: inner_id,
                    }
                }
                Expr::Grouping { expr, .. } => {
                    return self.lower_expr(*expr, env);
                }
                a => {
                    return Err(ElaboratorError::NotYetImplemented {
                        feature: format!("Complex expression lowering, {:?}", a),
                        span: expr.span(),
                    });
                }
            };

        Ok(self.arena.alloc_expr(lowered))
    }

    /// Given the expr_id and environment, it returns the signal
    fn resolve_expr_signal(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<SignalId, ElaboratorError> {
        let sym = self.resolve_expr_symbol(expr_id)?;
        env.lookup_signal(sym).ok_or_else(|| {
            ElaboratorError::SignalNotFound(self.sa.symbols.interner.get(sym).to_string())
        })
    }

    /// Returns the symbol of the identifier corresponding to expr_id
    fn resolve_expr_symbol(
        &self,
        expr_id: crate::ast::ExprId,
    ) -> Result<SymbolId, ElaboratorError> {
        let expr = &self.ast.exprs[expr_id.0 as usize];
        match expr {
            Expr::Identifier { name, .. } => Ok(self.get_symbol_unw(name)),
            _ => Err(ElaboratorError::EvaluationFailed {
                reason: "Expected identifier expression".into(),
                span: expr.span(),
            }),
        }
    }

    /// Processes top-level AST context items (`library ...; use ...;`)
    pub fn elaborate_context_items(
        &mut self,
        env: &mut Environment,
        registry: &LibraryRegistry,
    ) -> Result<(), ElaboratorError> {
        for item in &self.ast.contexts {
            match item {
                ContextItem::Library { name } => {
                    // Ensures the referenced library symbol is known in the interner
                    let lib_sym = self.get_symbol(name).ok_or_else(|| {
                        ElaboratorError::EvaluationFailed {
                            reason: format!("Unknown library '{}'", name),
                            span: Span { start: 0, end: 0 }, // TODO correct span
                        }
                    })?;
                    dbg!("AAAA");

                    // Special-case handling for standard libraries or work aliases
                    if name.eq_ignore_ascii_case("std") || name.eq_ignore_ascii_case("ieee") {
                        // Core types (std_logic, integer, etc.) are pre-loaded in SemanticAnalyzer
                        continue;
                    }

                    if !registry.libraries.contains_key(&name.to_lowercase())
                        && !name.eq_ignore_ascii_case("work")
                    {
                        return Err(ElaboratorError::EvaluationFailed {
                            reason: format!("Library '{}' was referenced but not loaded", name),
                            span: Span { start: 0, end: 0 }, // TODO correct span
                        });
                    }
                }
                ContextItem::Use { path } => {
                    self.elaborate_use_clause(path, env, registry)?;
                }
            }
        }
        Ok(())
    }

    fn elaborate_use_clause(
        &mut self,
        path: &str,
        env: &mut Environment,
        registry: &LibraryRegistry,
    ) -> Result<(), ElaboratorError> {
        let parts: Vec<&str> = path.split('.').collect();
        if parts.len() < 2 {
            return Err(ElaboratorError::EvaluationFailed {
                reason: format!("Malformed use clause path: '{}'", path),
                span: Span { start: 0, end: 0 },
            });
        }

        // Normalize case (VHDL is case-insensitive)
        let lib_name = parts[0].to_lowercase();
        let pkg_name = parts[1].to_lowercase();
        let selector = parts.get(2).copied().unwrap_or("all");

        if lib_name == "ieee" || lib_name == "std" {
            return Ok(());
        }

        // Direct string lookup on registry (assuming LibraryRegistry uses HashMap<String, Library>)
        let pkg_exports = registry.get_package(&lib_name, &pkg_name).ok_or_else(|| {
            ElaboratorError::EvaluationFailed {
                reason: format!("Package '{}.{}' not found in registry", lib_name, pkg_name),
                span: Span { start: 0, end: 0 },
            }
        })?;

        if selector.eq_ignore_ascii_case("all") {
            env.import_package(pkg_exports);
        } else {
            let item_sym = self
                .sa
                .symbols
                .interner
                .get_symbol(&selector.to_lowercase())
                .ok_or_else(|| ElaboratorError::EvaluationFailed {
                    reason: format!("Item '{}' not found in symbol interner", selector),
                    span: Span { start: 0, end: 0 },
                })?;

            if !env.import_package_item(pkg_exports, item_sym) {
                return Err(ElaboratorError::EvaluationFailed {
                    reason: format!(
                        "Symbol '{}' does not exist in '{}.{}'",
                        selector, lib_name, pkg_name
                    ),
                    span: Span { start: 0, end: 0 },
                });
            }
        }

        Ok(())
    }

    fn get_symbol_unw(&self, name: &str) -> SymbolId {
        self.sa.symbols.interner.get_symbol(name).expect(&format!(
            "If semantic analysis passed, this shouldn't panic. Panicked on {}",
            name
        ))
    }
    fn get_symbol(&self, name: &str) -> Option<SymbolId> {
        self.sa.symbols.interner.get_symbol(name)
    }
}
