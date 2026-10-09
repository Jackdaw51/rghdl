use std::collections::HashMap;
use std::ops::Range;

use crate::analyzer::{DeclRef, ScopeId, TypeId, TypeKind};
use crate::ast::{
    Architecture, AstArena, BinaryOp, ConcurrentStmt, ContextItem, Decl, DeclId, Entity, Expr,
    GetSpan, GetThing, Port, PortId, PortMode, SequentialStmt, UnaryOp,
};
use crate::elaborator::{ElaboratedDesign, ElaboratedSequentialStmt, LibraryRegistry, PortBinding};
use crate::parser::Span;
use crate::printer::FormatCtx;
use crate::workspace::FileId;
use crate::{
    analyzer::{SemanticAnalyzer, SymbolId},
    elaborator::{
        ElaboratedArena, ElaboratedConcurrentAssignment, ElaboratedPort, ElaboratedSignal,
        Elaborator, ElaboratorError, Environment, EvaluatedExpr, EvaluatedValue, ExprId,
        InstanceId, InstanceNode, SignalId,
    },
};

impl<'a> Elaborator<'a> {
    pub fn new(sa: &'a SemanticAnalyzer<'a>) -> Self {
        Self {
            sa,
            arena: ElaboratedArena::default(),
            instance_counter: 0,
            file_id: FileId(0),
        }
    }

    /// Elaborates all components starting from top_entity
    pub fn elaborate_top(
        &mut self,
        registry: &LibraryRegistry,
        top_entity_name: &str,
    ) -> Result<ElaboratedDesign, ElaboratorError> {
        let mut root_instances = Vec::new();
        let mut root_instance = InstanceId(0);
        let top_entity_sym = self
            .sa
            .symbols
            .interner
            .get_symbol(top_entity_name)
            .ok_or_else(|| ElaboratorError::EntityNotFound(top_entity_name.to_string()))?;
        let top_entity_decl = self
            .sa
            .symbols
            .lookup_local(ScopeId(0), top_entity_sym)
            .ok_or_else(|| ElaboratorError::EntityNotFound(top_entity_name.to_string()))?;

        let (top_entity_id, top_e_file_id, scope_id) = match top_entity_decl {
            DeclRef::Entity {
                file_id,
                entity_id,
                scope_id,
            } => (*entity_id, *file_id, *scope_id),
            _ => return Err(ElaboratorError::NotAnEntity),
        };

        self.file_id = top_e_file_id;
        let entity = self.get_ast(top_e_file_id).get_thing(top_entity_id);
        let matching_archs = self
            .sa
            .entity_architectures
            .get(&(top_entity_id, top_e_file_id))
            .ok_or_else(|| ElaboratorError::NoMatchingArchitectures(entity.name))?;

        // Create environment for this top component
        let mut env = Environment::new();

        self.elaborate_context_items(&mut env, registry, entity)?;
        let entity_name = entity.name;

        for arch_decl in matching_archs {
            let DeclRef::Architecture {
                file_id,
                ast_id,
                entity_tuple: entity_id,
                scope_id,
            } = arch_decl
            else {
                panic!();
            };
            let arch = &self.get_ast(*file_id).architectures[ast_id.0 as usize];

            // Distinguish instance hierarchical paths when an entity has multiple architectures
            let root_path = format!("{}_{}", top_entity_name, self.get_str(arch.name));

            let inst_id = self.elaborate_instance(
                top_entity_sym,
                top_entity_decl,
                arch_decl,
                &root_path,
                &mut env,
            )?;
            root_instances.push(inst_id);
            if entity_name == top_entity_sym {
                root_instance = inst_id;
            }
        }

        Ok(ElaboratedDesign {
            instances: root_instances,
            root_instance,
        })
    }

    fn elaborate_instance(
        &mut self,
        instance_name: SymbolId,
        entity_decl: &DeclRef,
        arch_decl: &DeclRef,
        path: &str,
        parent_env: &mut Environment,
    ) -> Result<InstanceId, ElaboratorError> {
        let mut local_env = Environment::new();
        let evaluated_generics =
            self.elaborate_generics(entity_decl, &parent_env.generic_overrides, &mut local_env)?;
        local_env.add_generic_overrides(evaluated_generics);

        let ports = self.elaborate_ports(entity_decl, &mut local_env)?;
        let mut local_signals =
            self.elaborate_architecture_declarations(arch_decl, &mut local_env)?;

        let (arch, arch_file_id, arch_scope): (&Architecture, FileId, ScopeId) =
            self.fetch_from_decl(arch_decl);

        let (entity, entity_file_id, entity_scope): (&Entity, FileId, ScopeId) =
            self.fetch_from_decl(entity_decl);
        let stmts_range = arch.stmts.clone();
        let architecture_name = arch.name;
        let entity_name = entity.name;

        // Concurrent Statements
        let mut processes = Vec::new();
        let mut concurrent_assignments = Vec::new();
        let mut children = Vec::new();

        self.file_id = arch_file_id;
        local_env.current_scope = arch_scope;

        self.lower_conc_stmt(
            entity_decl,
            arch_decl,
            path,
            &mut local_env,
            stmts_range,
            &mut concurrent_assignments,
            &mut children,
            &mut local_signals,
        )?;

        let slice = local_env.signals.values().map(|f| *f);
        self.validate_signal_drivers(slice)?;

        let node = InstanceNode {
            instance_name,
            entity_name,
            architecture_name,
            hierarchical_path: path.to_string(),
            ports,
            port_bindings: Vec::new(),
            local_signals,
            local_env: local_env,
            concurrent_assignments,
            processes,
            children,
        };

        let inst_id = InstanceId(self.arena.instances.len() as u32);
        self.arena.instances.push(node);
        Ok(inst_id)
    }

    fn lower_conc_stmt(
        &mut self,
        entity_decl: &DeclRef,
        arch_decl: &DeclRef,
        path: &str,
        local_env: &mut Environment,
        stmts_range: Range<u32>,
        concurrent_assignments: &mut Vec<ElaboratedConcurrentAssignment>,
        children: &mut Vec<InstanceId>,
        local_signals: &mut Vec<SignalId>,
    ) -> Result<(), ElaboratorError> {
        let ast = self.sa.get_ast(self.file_id);
        Ok(for stmt in ast.conc_statements(stmts_range) {
            match stmt {
                ConcurrentStmt::ConcurrentAssignment {
                    target,
                    expression,
                    after,
                    ..
                } => {
                    let target_sig = self.lower_expr(*target, local_env)?;
                    self.register_signal_driver(target_sig, ast.span(*target))?;
                    // dbg!(&self.arena.exprs[target_sig.0 as usize]);
                    let expr_id = self.lower_expr(*expression, &*local_env)?;
                    let delay_expr = after
                        .map(|delay_ast_id| self.lower_expr(delay_ast_id, &*local_env))
                        .transpose()?;
                    concurrent_assignments.push(ElaboratedConcurrentAssignment {
                        target_signal: target_sig,
                        value_expr: expr_id,
                        delay_expr,
                    });
                }
                // ConcurrentStmt::ConditionalAssignment { .. } => {
                //     todo!()
                // }
                ConcurrentStmt::Process {
                    stmts,
                    label,
                    sens_list,
                } => {
                    let process_name_str = match label {
                        Some(lbl) => self.get_str(*lbl).to_string(),
                        None => {
                            format!("_unlabeled_process_{}_{}", self.file_id, stmts.start)
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
                    let child_id = self.elaborate_component_instantiation(
                        *label,
                        *component_name,
                        *arch_qualifier,
                        generic_map.clone(),
                        port_map.clone(),
                        path,
                        local_env,
                        entity_decl,
                        arch_decl,
                    )?;
                    children.push(child_id);
                }
                ConcurrentStmt::ForGenerate {
                    label,
                    iterator,
                    range_left,
                    range_right,
                    direction,
                    stmts,
                } => {
                    let left_val = self.eval_const_expr(*range_left, &*local_env)?;
                    let EvaluatedValue::Integer(left_val) = left_val else {
                        unreachable!()
                    };
                    let right_val = self.eval_const_expr(*range_right, &*local_env)?;
                    let EvaluatedValue::Integer(right_val) = right_val else {
                        unreachable!()
                    };
                    match direction {
                        crate::parser::TokenKind::KwDownto => {
                            for i in (right_val..=left_val).rev() {
                                let path = format!("{path}_{i}");
                                let mut iter_env = local_env.extend();
                                iter_env.insert_constant(*iterator, EvaluatedValue::Integer(i));
                                self.lower_conc_stmt(
                                    entity_decl,
                                    arch_decl,
                                    &path,
                                    &mut iter_env,
                                    stmts.clone(),
                                    concurrent_assignments,
                                    children,
                                    local_signals,
                                )?;
                            }
                        }
                        crate::parser::TokenKind::KwTo => {
                            for i in left_val..=right_val {
                                let path = format!("{path}_{i}");
                                let mut iter_env = local_env.extend();
                                iter_env.insert_constant(*iterator, EvaluatedValue::Integer(i));
                                dbg!(&stmts);
                                self.lower_conc_stmt(
                                    entity_decl,
                                    arch_decl,
                                    &path,
                                    &mut iter_env,
                                    stmts.clone(),
                                    concurrent_assignments,
                                    children,
                                    local_signals,
                                )?;
                            }
                        }
                        _ => unreachable!(),
                    }
                }
                ConcurrentStmt::IfGenerate {
                    label,
                    condition,
                    stmts,
                    decls_start,
                    decls_end,
                } => {
                    let condition_met = self.eval_const_expr(*condition, local_env)?;
                    let EvaluatedValue::Boolean(condition_met) = condition_met else {
                        unreachable!()
                    };

                    if condition_met {
                        dbg!("HERE");
                        self.elaborate_gen_declarations(
                            *label,
                            path,
                            local_env,
                            local_signals,
                            decls_start.0,
                            ast,
                            &ast.decls[decls_start.0 as usize..decls_end.0 as usize],
                        )?;
                        self.lower_conc_stmt(
                            entity_decl,
                            arch_decl,
                            path,
                            local_env,
                            stmts.clone(),
                            concurrent_assignments,
                            children,
                            local_signals,
                        )?;
                    }
                }
            }
        })
    }

    fn elaborate_gen_declarations(
        &mut self,
        label: SymbolId,
        path: &str,
        env: &mut Environment,
        signals: &mut Vec<SignalId>,
        start: u32,
        ast: &AstArena,
        decl_slice: &[Decl],
    ) -> Result<(), ElaboratorError> {
        Ok(for (i, decl) in decl_slice.iter().enumerate() {
            match decl {
                Decl::Signal {
                    name,
                    decl_type,
                    default_val,
                } => {
                    let unique_name = format!("{}_{}", path, self.get_str(*name));
                    let sym = *name;
                    let type_id = self.get_type_from_expr(*decl_type);
                    // match &self.sa.types.get(type_id).unwrap() {
                    //     TypeKind::Array { name, element_type } => {
                    //         // dbg!(self.sa.get_str(*name), self.sa.types.get(*element_type));
                    //     }
                    //     s => {
                    //         panic!("{:?}",s)
                    //     }
                    // }
                    let (high_bound, low_bound) = self.get_type_bounds(*decl_type, env)?;
                    let sig_id = self.arena.alloc_signal(
                        ElaboratedSignal {
                            name: sym,
                            type_id,
                            high_bound,
                            low_bound,
                            driver_count: 0,
                            optional_locality: Some(unique_name),
                        },
                        ast.span(DeclId(i as u32 + start)),
                    );
                    env.insert_signal(sym, sig_id);
                    signals.push(sig_id);
                    if let Some(expr_id) = default_val {
                        let _init_val = self.eval_const_expr(*expr_id, env)?;
                    }
                }
                Decl::Constant {
                    name, default_val, ..
                } => {
                    if let Some(expr_id) = default_val {
                        let val = self.eval_const_expr(*expr_id, env)?;
                        env.insert_constant(*name, val);
                    }
                }
                Decl::Component {
                    name,
                    ports_start,
                    ports_end,
                } => {
                    env.register_component_signature(*name, *ports_start, *ports_end)?;
                }
                Decl::Variable { name, .. } => {
                    return Err(ElaboratorError::NotYetImplemented {
                        feature: format!("Shared variable: {}", self.get_str(*name)),
                        span: ast.span(DeclId(i as u32 + start)),
                        file_id: self.file_id,
                    });
                }
            }
        })
    }

    fn validate_signal_drivers(
        &self,
        local_signals: impl Iterator<Item = SignalId>,
    ) -> Result<(), ElaboratorError> {
        for sig_id in local_signals {
            let sig = &self.arena.signals[sig_id.0 as usize];
            dbg!(self.get_str(sig.name));

            // Check if type is unresolved (integer, boolean, bit, real...), because std_logic and std_logic_vector can have multiple drivers
            let is_resolved = Some(sig.type_id) == self.sa.type_std_logic
                || Some(sig.type_id) == self.sa.type_std_logic_vector;

            if !is_resolved && sig.driver_count > 1 {
                let sig_name = self.sa.symbols.interner.get(sig.name);
                return Err(ElaboratorError::BindingError {
                    reason: format!(
                        "Signal '{}' of unresolved type has {} drivers (maximum 1 allowed)",
                        sig_name, sig.driver_count
                    ),
                    span: self.arena.span(sig_id),
                    file_id: self.file_id, // Attach relevant signal declaration span
                });
            }
        }
        Ok(())
    }
    /// Takes the generic port overrides from parents - if not present, uses generic default value - inserts them into the environment,
    /// and returns the elaborated map of evaluated values
    fn elaborate_generics(
        &mut self,
        decl_entity: &DeclRef,
        overrides: &HashMap<SymbolId, EvaluatedValue>,
        env: &mut Environment,
    ) -> Result<HashMap<SymbolId, EvaluatedValue>, ElaboratorError> {
        let mut resolved = HashMap::new();
        let DeclRef::Entity {
            file_id,
            entity_id,
            scope_id,
        } = decl_entity
        else {
            panic!()
        };

        self.file_id = *file_id;
        let ast = self.get_ast(*file_id);
        let entity = &ast.entities[entity_id.0 as usize];
        let decl_slice =
            &ast.decls[entity.generics_start.0 as usize..entity.generics_end.0 as usize];

        for (i, decl) in decl_slice.iter().enumerate() {
            if let Decl::Constant {
                name, default_val, ..
            } = decl
            {
                let sym = *name;
                let val = if let Some(val_override) = overrides.get(&sym) {
                    val_override.clone()
                } else if let Some(expr_id) = default_val {
                    self.eval_const_expr(*expr_id, env)?
                } else {
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Generic parameter '{}' missing default value",
                            self.get_str(sym)
                        ),
                        span: ast.span(DeclId(i as u32 + entity.generics_start.0)),
                        file_id: self.file_id,
                    });
                };
                env.insert_constant(sym, val.clone());
                resolved.insert(sym, val);
            }
        }
        Ok(resolved)
    }
    fn get_str(&self, sym: SymbolId) -> &str {
        self.sa.symbols.interner.get(sym)
    }

    fn resolve_port_type(&self, port: &Port) -> Result<TypeId, ElaboratorError> {
        let ast = self.get_ast(self.file_id);
        self.sa
            .expr_types
            .get(port.port_type.0 as usize)
            .copied()
            .ok_or_else(|| ElaboratorError::EvaluationFailed {
                reason: format!(
                    "Failed to resolve type for port '{}'",
                    self.get_str(port.name)
                ),
                span: ast.span(port.port_type),
                file_id: self.file_id,
            })
    }

    fn elaborate_ports(
        &mut self,
        entity_decl: &DeclRef,
        local_env: &mut Environment,
    ) -> Result<Vec<ElaboratedPort>, ElaboratorError> {
        let mut ports = Vec::new();
        let (entity, file_id, scope_id): (&Entity, FileId, ScopeId) =
            self.fetch_from_decl(entity_decl);

        let ast = self.sa.get_ast(file_id);
        let ports_start = entity.ports_start;
        let port_slice = &ast.ports[ports_start.0 as usize..entity.ports_end.0 as usize];

        for (i, port) in port_slice.iter().enumerate() {
            let type_id = self.get_type_from_expr(port.port_type);
            let sym = port.name;
            let (high_bound, low_bound) = self.get_type_bounds(port.port_type, local_env)?;
            match local_env.signals.get(&sym) {
                Some(&existing_sig_id) => {
                    dbg!(existing_sig_id);
                    panic!()
                }
                None => {
                    let new_sig_id = self.arena.alloc_signal(
                        ElaboratedSignal {
                            name: sym,
                            type_id,
                            high_bound,
                            low_bound,
                            driver_count: 0,
                            optional_locality: None,
                        },
                        ast.span(PortId(ports_start.0 + i as u32)),
                    );
                    local_env.insert_signal(sym, new_sig_id);
                }
            };

            ports.push(ElaboratedPort {
                name: sym,
                mode: port.mode,
                type_id,
                high_bound,
                low_bound,
            });
        }
        Ok(ports)
    }

    fn elaborate_architecture_declarations(
        &mut self,
        arch: &DeclRef,
        env: &mut Environment,
    ) -> Result<Vec<SignalId>, ElaboratorError> {
        let mut signals = Vec::new();
        let (arch, file_id, scope_id): (&Architecture, FileId, ScopeId) =
            self.fetch_from_decl(arch);
        let start = arch.decls_start.0;
        let ast = self.sa.get_ast(file_id);
        let decl_slice = ast.declarations(arch);

        self.elaborate_declarations(env, &mut signals, start, ast, decl_slice)?;
        Ok(signals)
    }

    fn elaborate_declarations(
        &mut self,
        env: &mut Environment,
        signals: &mut Vec<SignalId>,
        start: u32,
        ast: &AstArena,
        decl_slice: &[Decl],
    ) -> Result<(), ElaboratorError> {
        Ok(for (i, decl) in decl_slice.iter().enumerate() {
            match decl {
                Decl::Signal {
                    name,
                    decl_type,
                    default_val,
                } => {
                    let sym = *name;
                    let type_id = self.get_type_from_expr(*decl_type);
                    // match &self.sa.types.get(type_id).unwrap() {
                    //     TypeKind::Array { name, element_type } => {
                    //         // dbg!(self.sa.get_str(*name), self.sa.types.get(*element_type));
                    //     }
                    //     s => {
                    //         panic!("{:?}",s)
                    //     }
                    // }
                    let (high_bound, low_bound) = self.get_type_bounds(*decl_type, env)?;
                    let sig_id = self.arena.alloc_signal(
                        ElaboratedSignal {
                            name: sym,
                            type_id,
                            high_bound,
                            low_bound,
                            driver_count: 0,
                            optional_locality: None,
                        },
                        ast.span(DeclId(i as u32 + start)),
                    );
                    env.insert_signal(sym, sig_id);
                    signals.push(sig_id);
                    if let Some(expr_id) = default_val {
                        let _init_val = self.eval_const_expr(*expr_id, env)?;
                    }
                }
                Decl::Constant {
                    name, default_val, ..
                } => {
                    if let Some(expr_id) = default_val {
                        let val = self.eval_const_expr(*expr_id, env)?;
                        env.insert_constant(*name, val);
                    }
                }
                Decl::Component {
                    name,
                    ports_start,
                    ports_end,
                } => {
                    env.register_component_signature(*name, *ports_start, *ports_end)?;
                }
                Decl::Variable { name, .. } => {
                    return Err(ElaboratorError::NotYetImplemented {
                        feature: format!("Shared variable: {}", self.get_str(*name)),
                        span: ast.span(DeclId(i as u32 + start)),
                        file_id: self.file_id,
                    });
                }
            }
        })
    }

    // fn elaborate_process(
    //     &mut self,
    //     label: &str,
    //     sensitivities: &[crate::ast::ExprId],
    //     stmts_range: std::ops::Range<u32>,
    //     env: &Environment,
    // ) -> Result<ProcessId, ElaboratorError> {
    //     let proc_sym = self.get_symbol_unw(label);
    //     let mut sens_ids = Vec::new();
    //     for sens in sensitivities {
    //         sens_ids.push(self.resolve_expr_signal(*sens, env)?);
    //     }

    //     let mut proc_env = env.extend();
    //     let mut lowered_stmts = Vec::new();

    //     for stmt in self.get_ast(file_id).seq_statements(stmts_range) {
    //         self.lower_sequential_stmt(stmt, &mut proc_env, &mut lowered_stmts)?;
    //     }

    //     let proc_id = ProcessId(self.arena.processes.len() as u32);
    //     self.arena.processes.push(ElaboratedProcess {
    //         label: proc_sym,
    //         sensitivity_list: sens_ids,
    //         body_stmts: lowered_stmts,
    //     });

    //     Ok(proc_id)
    // }

    fn lower_sequential_stmt(
        &mut self,
        stmt: &SequentialStmt,
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

    // fn lower_conditional_assignment(
    //     &mut self,
    //     target_sig: SignalId,
    //     when_branches: &[(crate::ast::ExprId, crate::ast::ExprId)],
    //     else_branch: Option<crate::ast::ExprId>,
    //     env: &Environment,
    // ) -> Result<ElaboratedProcess, ElaboratorError> {
    //     let proc_sym = self.get_symbol_unw("cond_assign_proc");
    //     let mut stmts = Vec::new();

    //     let mut current_else: Option<Vec<ElaboratedSequentialStmt>> =
    //         if let Some(else_expr_id) = else_branch {
    //             let val_expr = self.lower_expr(else_expr_id, env)?;
    //             Some(vec![ElaboratedSequentialStmt::SignalAssignment {
    //                 target: target_sig,
    //                 value_expr: val_expr,
    //             }])
    //         } else {
    //             None
    //         };

    //     for (val_ast, cond_ast) in when_branches.iter().rev() {
    //         let cond_expr = self.lower_expr(*cond_ast, env)?;
    //         let val_expr = self.lower_expr(*val_ast, env)?;

    //         let then_branch = vec![ElaboratedSequentialStmt::SignalAssignment {
    //             target: target_sig,
    //             value_expr: val_expr,
    //         }];

    //         current_else = Some(vec![ElaboratedSequentialStmt::If {
    //             condition: cond_expr,
    //             then_branch,
    //             else_branch: current_else,
    //         }]);
    //     }

    //     if let Some(lowered_if) = current_else {
    //         stmts = lowered_if;
    //     }

    //     Ok(ElaboratedProcess {
    //         label: proc_sym,
    //         sensitivity_list: Vec::new(),
    //         body_stmts: stmts,
    //     })
    // }

    fn elaborate_component_instantiation(
        &mut self,
        label_sym: Option<SymbolId>,
        comp_name: crate::ast::ExprId,
        arch_sym: Option<SymbolId>,
        generic_map_range: Range<u32>,
        port_map_range: Range<u32>,
        path: &str,
        parent_env: &mut Environment,
        entity_decl: &DeclRef,
        arch_decl: &DeclRef,
    ) -> Result<InstanceId, ElaboratorError> {
        let label = match label_sym {
            Some(s) => &self.get_str(s),
            None => "inst",
        };

        let DeclRef::Architecture {
            file_id: a_file_id,
            ast_id: a_ast_id,
            entity_tuple,
            scope_id,
        } = arch_decl
        else {
            panic!()
        };

        let component_name = self
            .sa
            .get_base_stripped_from_file(comp_name, self.file_id)
            .expect("Should have already been stripped");

        let child_entity_decl = self
            .sa
            .symbols
            .lookup_local(ScopeId(0), component_name)
            .ok_or_else(|| {
                // panic!();
                dbg!(label);
                dbg!(self.file_id);
                dbg!(component_name);
                ElaboratorError::EntityNotFound(self.get_str(component_name).to_string())
            })?;

        let DeclRef::Entity {
            file_id: child_e_file_id,
            entity_id,
            scope_id,
        } = child_entity_decl
        else {
            panic!();
        };
        let s = self
            .sa
            .entity_architectures
            .get(&(*entity_id, *child_e_file_id));
        let Some(a) = s else {
            return Err(ElaboratorError::EntityNotFound(
                self.get_str(component_name).to_string(),
            ));
        };

        let child_arch_decl = match arch_sym {
            Some(arch_qual) => a
                .iter()
                .find(|p| {
                    let DeclRef::Architecture {
                        file_id,
                        ast_id,
                        entity_tuple,
                        scope_id,
                    } = p
                    else {
                        panic!()
                    };
                    let arch: &Architecture =
                        &self.get_ast(*file_id).architectures[ast_id.0 as usize];
                    arch.name == arch_qual
                })
                .ok_or_else(|| ElaboratorError::ArchitectureNotFound(component_name))?,
            None => {
                // We need to go to latest analyzed architecture as IEEE 7.3.3 says
                match a.last() {
                    Some(x) => x,
                    None => return Err(ElaboratorError::ArchitectureNotFound(component_name)),
                }
            }
        };

        let ast = self.sa.get_ast(*child_e_file_id);

        let mut evaluated_overrides = HashMap::new();
        if !generic_map_range.is_empty() {
            let generic_associations =
                &ast.associations[generic_map_range.start as usize..generic_map_range.end as usize];

            for assoc in generic_associations {
                let formal_sym = match assoc.formal {
                    Some(formal_id) => self.resolve_expr_symbol(formal_id)?,
                    None => {
                        return Err(ElaboratorError::NotYetImplemented {
                            feature: "Positional generic mapping".to_string(),
                            span: ast.span(comp_name),
                            file_id: self.file_id,
                        });
                    }
                };

                let actual_val = self.eval_const_expr(assoc.actual, parent_env)?;
                evaluated_overrides.insert(formal_sym, actual_val);
            }
        }

        let child_path = format!("{}_{}", path, label);
        let inst_sym = self.get_symbol(label).expect("TODO");
        let child_entity = &ast.entities[entity_id.0 as usize];
        let target_ports = ast.ports(child_entity);
        let assoc_ast = self.sa.get_ast(*a_file_id);
        let port_associations =
            &assoc_ast.associations[port_map_range.start as usize..port_map_range.end as usize];
        parent_env.add_generic_overrides(evaluated_overrides);

        let child_id = self.elaborate_instance(
            inst_sym,
            child_entity_decl,
            child_arch_decl,
            &child_path,
            parent_env,
        )?;

        self.file_id = *a_file_id;
        for (idx, assoc) in port_associations.iter().enumerate() {
            let formal_port = match assoc.formal {
                Some(formal_expr_id) => {
                    if let Expr::Identifier { name, .. } =
                        &assoc_ast.exprs[formal_expr_id.0 as usize]
                    {
                        target_ports.iter().find(|p| p.name == *name)
                    } else {
                        None
                    }
                }
                None => target_ports.get(idx),
            }
            .ok_or_else(|| ElaboratorError::BindingError {
                reason: format!(
                    "No matching target port found for association index {}",
                    idx
                ),
                span: ast.span(comp_name),
                file_id: self.file_id,
            })?;

            let formal_sym = formal_port.name;

            // Need to iter and find because named associations can be done in any order

            let formal_elab_port = self.arena.instances[child_id.0 as usize]
                .ports
                .iter()
                .find(|p| p.name == formal_sym)
                .ok_or_else(|| ElaboratorError::BindingError {
                    reason: format!(
                        "Elaborated port '{}' missing on instance node",
                        self.get_str(formal_port.name)
                    ),
                    span: assoc_ast.span(assoc.actual),
                    file_id: self.file_id,
                })?;
            let formal_width = formal_elab_port.width();

            // If encounter open, do not create a binding to any local signal if out
            if let Expr::Open = ast.expr(assoc.actual) {
                match formal_port.mode {
                    PortMode::Out | PortMode::InOut | PortMode::Buffer => {
                        continue;
                    }
                    PortMode::In => {
                        todo!()
                    }
                }
            }

            let actual_expr_id = self.lower_expr(assoc.actual, parent_env)?;
            let actual_width = self.get_expr_width(actual_expr_id);
            if formal_width != actual_width {
                return Err(ElaboratorError::BindingError {
                    reason: format!(
                        "Port width mismatch for '{}': formal expects width {}, but actual has width {}",
                        self.get_str(formal_sym),
                        formal_width,
                        actual_width
                    ),
                    span: ast.span(assoc.actual),
                    file_id: self.file_id,
                });
            }
            // adjusts driver count to parent signal if child has a driving port_mode
            if matches!(
                formal_port.mode,
                PortMode::Out | PortMode::InOut | PortMode::Buffer
            ) {
                self.register_signal_driver(actual_expr_id, ast.span(assoc.actual))?;
            }

            // Attach resolved physical signal to child instance node
            self.arena.instances[child_id.0 as usize]
                .port_bindings
                .push(PortBinding {
                    port_name: formal_sym,
                    actual_signal: actual_expr_id,
                });
        }

        Ok(child_id)
    }
    /// Marks a driver on the underlying signal for an output/inout/buffer port.
    pub fn register_signal_driver(
        &mut self,
        expr_id: ExprId,
        span: Span,
    ) -> Result<(), ElaboratorError> {
        let expr = &self.arena.exprs[expr_id.0 as usize];

        match expr {
            // `cout => carry`
            EvaluatedExpr::SignalRead(sig_id) => {
                self.arena.signals[sig_id.0 as usize].driver_count += 1;
                Ok(())
            }

            // `cout => carry(i + 1)`
            EvaluatedExpr::ArrayIndex { target, .. } => {
                self.register_signal_driver(*target, span)
            }

            _ => Err(ElaboratorError::BindingError {
                reason: "Output, inout, or buffer port must be connected to a valid signal target, not an expression or literal".to_string(),
                span,
                file_id: self.file_id,
            }),
        }
    }
    pub fn get_expr_width(&self, expr_id: ExprId) -> usize {
        match &self.arena.exprs[expr_id.0 as usize] {
            EvaluatedExpr::Literal(val) => match val {
                EvaluatedValue::EnumLiteral(_) | EvaluatedValue::Boolean(_) => 1,
                EvaluatedValue::Integer(_) => 32,
                EvaluatedValue::Vector(elems) => elems.len(),
            },

            EvaluatedExpr::SignalRead(sig_id) => {
                let sig = &self.arena.signals[sig_id.0 as usize];
                sig.width()
            }

            EvaluatedExpr::ArrayIndex {
                target: _,
                index: _,
            } => 1,

            EvaluatedExpr::UnaryOp { expr, .. } => self.get_expr_width(*expr),

            EvaluatedExpr::BinaryOp { lhs, op, rhs } => match op {
                BinaryOp::Eq
                | BinaryOp::Neq
                | BinaryOp::Lt
                | BinaryOp::Lte
                | BinaryOp::Gt
                | BinaryOp::Gte => 1, // Boolean ops return width 1
                BinaryOp::Concat => self.get_expr_width(*lhs) + self.get_expr_width(*rhs),
                _ => self.get_expr_width(*lhs),
            },
        }
    }

    fn print_expr(&self, expr_id: crate::ast::ExprId, ast: &AstArena) {
        let f = FormatCtx {
            item: ast.expr(expr_id),
            source: "",
            symbols: &self.sa.symbols.interner,
            arena: ast,
            indent: 0,
            path: "",
        };
        println!("{f}");
    }

    pub fn eval_const_expr(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<EvaluatedValue, ElaboratorError> {
        let ast = self.get_ast(self.file_id);
        let expr = &ast.exprs[expr_id.0 as usize];
        match expr {
            Expr::Literal { name } => {
                let text = self.get_str(*name);
                if text == "true" || text == "false" {
                    Ok(EvaluatedValue::Boolean(text == "true"))
                } else if text.starts_with('\'') && text.ends_with('\'') {
                    Ok(EvaluatedValue::EnumLiteral(*name))
                } else if let Ok(val) = text.parse::<i64>() {
                    Ok(EvaluatedValue::Integer(val))
                } else {
                    Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Unsupported or invalid literal '{}'", text),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    })
                }
            }
            Expr::Identifier { name } => {
                if let Some(val) = env.lookup_constant(*name) {
                    Ok(val.clone()) // TODO
                } else {
                    Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Constant identifier '{}' not found in environment",
                            self.get_str(*name)
                        ),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
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
                                span: ast.span(expr_id),
                                file_id: self.file_id,
                            });
                        }
                        Ok(EvaluatedValue::Integer(l / r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Eq) => {
                        Ok(EvaluatedValue::Boolean(l == r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Gt) => {
                        Ok(EvaluatedValue::Boolean(l > r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Lt) => {
                        Ok(EvaluatedValue::Boolean(l < r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Gte) => {
                        Ok(EvaluatedValue::Boolean(l >= r))
                    }
                    (EvaluatedValue::Integer(l), EvaluatedValue::Integer(r), BinaryOp::Lte) => {
                        Ok(EvaluatedValue::Boolean(l <= r))
                    }
                    _ => Err(ElaboratorError::EvaluationFailed {
                        reason: "Unsupported constant binary operation".to_string(),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
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
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    }),
                }
            }
            Expr::Grouping { expr: inner, .. } => self.eval_const_expr(*inner, env),
            Expr::CallOrIndex { callee, args, .. } => {
                let callee_sym = self.resolve_expr_symbol(*callee)?;
                let callee_name = self.get_str(callee_sym);

                let arg_slice = &ast.expr_lists[args.start as usize..args.end as usize]; // TODO
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
                                span: ast.span(expr_id),
                                file_id: self.file_id,
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
                                span: ast.span(expr_id),
                                file_id: self.file_id,
                            }),
                        }
                    }
                    "to_integer" => {
                        if eval_args.len() != 1 {
                            return Err(ElaboratorError::EvaluationFailed {
                                reason: "'to_integer' requires exactly 1 argument".into(),
                                span: ast.span(expr_id),
                                file_id: self.file_id,
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
                                span: ast.span(expr_id),
                                file_id: self.file_id,
                            }),
                        }
                    }
                    other => Err(ElaboratorError::EvaluationFailed {
                        reason: format!("Unsupported compile-time function call '{}'", other),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    }),
                }
            }
            Expr::PhysicalLiteral { value, unit } => {
                let quantity = match self.eval_const_expr(*value, env)? {
                    EvaluatedValue::Integer(val) => val,
                    _ => {
                        return Err(ElaboratorError::EvaluationFailed {
                            reason: "Physical literal multiplier must evaluate to an integer"
                                .to_string(),
                            span: ast.span(expr_id),
                            file_id: self.file_id,
                        });
                    }
                };
                let u_str = self.get_str(*unit);
                let scale_factor: i64 = match u_str {
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
                            reason: format!("Unknown physical unit '{}'", u_str),
                            span: ast.span(expr_id),
                            file_id: self.file_id,
                        });
                    }
                };

                let total_fs = quantity.checked_mul(scale_factor).ok_or_else(|| {
                    ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Overflow while evaluating physical literal '{} {}'",
                            quantity, u_str
                        ),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    }
                })?;

                Ok(EvaluatedValue::Integer(total_fs))
            }
            a => {
                // panic!();
                Err(ElaboratorError::EvaluationFailed {
                    reason: format!(
                        "Non-static expression encountered during evaluation: {}\n Debug: {:?}",
                        "ADD EXPR expression HERE TODO", a
                    ),
                    span: ast.span(expr_id),
                    file_id: self.file_id,
                })
            }
        }
    }

    /// Lowers an expression into the elaborator expression variant
    fn lower_expr(
        &mut self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<ExprId, ElaboratorError> {
        let ast = self.sa.get_ast(self.file_id);
        let expr = &ast.exprs[expr_id.0 as usize];
        let lowered = match expr {
            Expr::Literal { name } => {
                let text = self.get_str(*name);
                let val = if let Ok(i) = text.parse::<i64>() {
                    EvaluatedValue::Integer(i)
                } else if text == "true" || text == "false" {
                    EvaluatedValue::Boolean(text == "true")
                } else if text.starts_with('\'') && text.ends_with('\'') {
                    let sym = self
                        .sa
                        .symbols
                        .interner
                        .get_symbol(text)
                        .ok_or_else(|| ElaboratorError::SymbolNotFound(text.to_string()))?;
                    EvaluatedValue::EnumLiteral(sym)
                } else {
                    // Fallback for enumerated identifier literals (e.g., state names like IDLE)
                    let sym = self
                        .sa
                        .symbols
                        .interner
                        .get_symbol(text)
                        .ok_or_else(|| ElaboratorError::SymbolNotFound(text.to_string()))?;
                    EvaluatedValue::EnumLiteral(sym)
                };
                EvaluatedExpr::Literal(val)
            }
            Expr::Identifier { name } => {
                if let Some(sig_id) = env.lookup_signal(*name) {
                    EvaluatedExpr::SignalRead(sig_id)
                } else if let Some(val) = env.lookup_constant(*name) {
                    EvaluatedExpr::Literal(val.clone())
                } else {
                    dbg!("here1");
                    return Err(ElaboratorError::SignalNotFound(
                        self.get_str(*name).to_string(),
                    ));
                }
            }
            Expr::Binary { op, lhs, rhs, .. } => {
                // If it evaluates to constants already, return the value, otherwise return the binary op.
                let b = self.eval_const_expr(expr_id, env);
                if matches!(
                    b,
                    Ok::<EvaluatedValue, ElaboratorError>(EvaluatedValue::Integer(_)),
                ) {
                    EvaluatedExpr::Literal(b.unwrap())
                } else {
                    let l_id = self.lower_expr(*lhs, env)?;
                    let r_id = self.lower_expr(*rhs, env)?;
                    EvaluatedExpr::BinaryOp {
                        lhs: l_id,
                        op: *op,
                        rhs: r_id,
                    }
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
            Expr::CallOrIndex { callee, args } => {
                let arg_ids = &ast.expr_lists[args.start as usize..args.end as usize];

                let mut lowered_args = Vec::with_capacity(arg_ids.len());
                for &arg_id in arg_ids {
                    lowered_args.push(self.lower_expr(arg_id, env)?);
                }

                let callee_expr = &ast.exprs[callee.0 as usize];

                let a = match callee_expr {
                    Expr::Identifier { name } => {
                        let scope = self.sa.symbols.scopes.get(env.current_scope);
                        dbg!(env.current_scope);
                        for i in &scope.bindings {
                            dbg!(self.get_str(*i.0));
                        }
                        let decl_ref = self
                            .sa
                            .symbols
                            .lookup(env.current_scope, *name)
                            .ok_or_else(|| ElaboratorError::EvaluationFailed {
                                reason: format!(
                                    "Symbol '{}' not found in current scope",
                                    self.get_str(*name)
                                ),
                                span: ast.span(expr_id),
                                file_id: self.file_id,
                            })?;

                        match decl_ref {
                            DeclRef::Function {
                                return_type,
                                param_types,
                            } => self.lower_function_call(*name, &arg_ids, env),

                            DeclRef::Type(target_type_id) => {
                                if lowered_args.len() != 1 {
                                    return Err(ElaboratorError::EvaluationFailed {
                                        reason: "Type conversion expects exactly one argument"
                                            .to_string(),
                                        span: ast.span(expr_id),
                                        file_id: self.file_id,
                                    });
                                }
                                self.lower_type_conversion(target_type_id, lowered_args.remove(0))
                            }

                            DeclRef::Signal { .. }
                            | DeclRef::Variable { .. }
                            | DeclRef::Constant { .. }
                            | DeclRef::Port { .. } => {
                                self.lower_array_index(*callee, lowered_args, env)
                            }

                            _ => Err(ElaboratorError::EvaluationFailed {
                                reason: format!(
                                    "Cannot call or index non-function/non-array symbol '{}'",
                                    self.get_str(*name)
                                ),
                                span: ast.span(expr_id),
                                file_id: self.file_id,
                            }),
                        }
                    }

                    // Complex callees like record field access: `my_rec.array_field(i)`
                    _ => {
                        todo!()
                    }
                };
                return a;
            }
            Expr::Open => {
                panic!();
                return Err(ElaboratorError::EvaluationFailed {
                 reason: "Keyword 'open' cannot be evaluated as an expression value; it is only valid in port or generic maps".to_string(),
                    span:ast.span(expr_id),
                    file_id: self.file_id,
            });
            }
            a => {
                return Err(ElaboratorError::NotYetImplemented {
                    feature: format!("Complex expression lowering, {:?}", a),
                    span: self.sa.get_ast(self.file_id).span(expr_id),
                    file_id: self.file_id,
                });
            }
        };

        Ok(self.arena.alloc_expr(lowered))
    }

    fn lower_function_call(
        &mut self,
        fn_symbol: SymbolId,
        args: &[crate::ast::ExprId],
        env: &Environment,
    ) -> Result<ExprId, ElaboratorError> {
        let fn_name = self.get_str(fn_symbol);

        match fn_name {
            "rising_edge" => Ok(self.arena.alloc_expr(EvaluatedExpr::SignalRead(
                self.resolve_expr_signal(args[0], env)?,
            ))),
            "to_integer" => {
                // Evaluate vector -> integer compile-time or runtime node
                todo!("Implement to_integer evaluation/lowering")
            }
            _ => {
                // General user or package function
                todo!("User function invocation in elaborator")
            }
        }
    }
    fn lower_array_index(
        &mut self,
        target: crate::ast::ExprId,
        indices: Vec<ExprId>,
        env: &Environment,
    ) -> Result<ExprId, ElaboratorError> {
        let target_low = self.lower_expr(target, env)?;
        let ast = self.get_ast(self.file_id);
        if indices.is_empty() {
            return Err(ElaboratorError::EvaluationFailed {
                reason: "Array indexing requires at least one index".to_string(),
                span: ast.span(target),
                file_id: self.file_id,
            });
        }

        // For 1D arrays/vectors, take the primary index
        let index_expr_id = indices[0];

        let target_expr = self.arena.exprs[target_low.0 as usize].clone();
        let index_expr = self.arena.exprs[index_expr_id.0 as usize].clone();

        match (target_expr, index_expr) {
            // Compile-Time Constant
            (
                EvaluatedExpr::Literal(EvaluatedValue::Vector(vec)),
                EvaluatedExpr::Literal(EvaluatedValue::Integer(idx)),
            ) => {
                let u_idx = idx as usize;
                if u_idx < vec.len() {
                    let elem_val = vec[u_idx].clone();
                    Ok(self.arena.alloc_expr(EvaluatedExpr::Literal(elem_val)))
                } else {
                    Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Array index {} out of bounds for vector of length {}",
                            idx,
                            vec.len()
                        ),
                        span: ast.span(target),
                        file_id: self.file_id,
                    })
                }
            }
            (
                EvaluatedExpr::SignalRead(sig_id),
                EvaluatedExpr::Literal(EvaluatedValue::Integer(idx)),
            ) => {
                let signal = &self.arena.signals[sig_id.0 as usize];
                let min_bound = signal.low_bound.min(signal.high_bound);
                let max_bound = signal.low_bound.max(signal.high_bound);

                if idx < min_bound || idx > max_bound {
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Static index {} out of bounds for signal bounds [{} .. {}]",
                            idx, min_bound, max_bound
                        ),
                        span: ast.span(target),
                        file_id: self.file_id,
                    });
                }

                // Index is valid -> Emit netlist node
                Ok(self.arena.alloc_expr(EvaluatedExpr::ArrayIndex {
                    target: target_low,
                    index: index_expr_id,
                }))
            }

            // Has to be checked at runtime
            _ => Ok(self.arena.alloc_expr(EvaluatedExpr::ArrayIndex {
                target: target_low,
                index: index_expr_id,
            })),
        }
    }

    // /// Given the expr_id and environment, it returns the signal
    // fn resolve_expr_signal(
    //     &self,
    //     expr_id: crate::ast::ExprId,
    //     env: &Environment,
    // ) -> Result<SignalId, ElaboratorError> {
    //     let sym = self.resolve_expr_symbol(expr_id)?;
    //     let a = env.lookup_signal(sym).ok_or_else(|| {
    //         dbg!("here2");
    //         ElaboratorError::SignalNotFound(self.get_str(sym).to_string())
    //     });
    //     a
    // }
    pub fn resolve_expr_signal(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<SignalId, ElaboratorError> {
        // dbg!(self.file_id);
        let ast = self.sa.get_ast(self.file_id);
        let expr = &ast.exprs[expr_id.0 as usize];
        // dbg!(expr);

        match expr {
            Expr::Identifier { name } => env.lookup_signal(*name).ok_or_else(|| {
                dbg!("here2");
                ElaboratorError::SignalNotFound(self.get_str(*name).to_string())
            }),

            Expr::CallOrIndex { callee, args } => {
                let sig_id = self.resolve_expr_signal(*callee, env)?;
                let sig = &self.arena.signals[sig_id.0 as usize];

                // Statically evaluate the index expression
                if args.is_empty() {
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: "Index expression cannot be empty".to_string(),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    });
                }

                let index_expr_id = ast.expr_lists[args.start as usize];
                //TODO check
                let index_val = self.eval_const_expr(index_expr_id, env)?;
                let EvaluatedValue::Integer(a) = index_val else {
                    panic!();
                };

                // Perform static bound checking
                if !sig.contains_index(a) {
                    let sig_name = self.sa.get_str(sig.name);
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Index {} out of bounds for signal '{}' range [{}..{}]",
                            index_val, sig_name, sig.low_bound, sig.high_bound
                        ),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    });
                }

                Ok(sig_id)
            }

            Expr::Slice {
                target,
                left,
                right,
                direction,
            } => {
                let sig_id = self.resolve_expr_signal(*target, env)?;
                let sig = &self.arena.signals[sig_id.0 as usize];

                let left_val = self.eval_const_expr(*left, env)?;
                let EvaluatedValue::Integer(l_val) = left_val else {
                    panic!()
                };
                let right_val = self.eval_const_expr(*right, env)?;
                let EvaluatedValue::Integer(r_val) = right_val else {
                    panic!()
                };

                let slice_low = l_val.min(r_val);
                let slice_high = l_val.max(r_val);

                // Perform static sub-range bound checking
                if !sig.contains_range(slice_low, slice_high) {
                    let sig_name = self.sa.get_str(sig.name);
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Slice range [{}..{}] falls outside signal '{}' range [{}..{}]",
                            slice_low, slice_high, sig_name, sig.low_bound, sig.high_bound
                        ),
                        span: ast.span(expr_id),
                        file_id: self.file_id,
                    });
                }

                Ok(sig_id)
            }

            _ => Err(ElaboratorError::EvaluationFailed {
                reason: format!("Cannot resolve expression {:?} to a physical signal", expr),
                span: ast.span(expr_id),
                file_id: self.file_id,
            }),
        }
    }

    /// Returns the symbol of the identifier corresponding to expr_id
    fn resolve_expr_symbol(
        &self,
        expr_id: crate::ast::ExprId,
    ) -> Result<SymbolId, ElaboratorError> {
        let expr = &self.sa.get_ast(self.file_id).exprs[expr_id.0 as usize];
        match expr {
            Expr::Identifier { name } => Ok(*name),
            _ => Err(ElaboratorError::EvaluationFailed {
                reason: "Expected identifier expression".into(),
                span: self.sa.get_ast(self.file_id).span(expr_id),
                file_id: self.file_id,
            }),
        }
    }

    /// Processes top-level AST context items (`library ...; use ...;`)
    pub fn elaborate_context_items(
        &self,
        env: &mut Environment,
        registry: &LibraryRegistry,
        entity: &Entity,
    ) -> Result<(), ElaboratorError> {
        let ast = self.get_ast(self.file_id);
        let range = entity.contexts.clone();
        for item in &ast.contexts[range.start as usize..range.end as usize] {
            match item {
                ContextItem::Library { name, span } => {
                    let a = self.get_str(*name);
                    if !registry.libraries.contains_key(a) && a.ne("work") {
                        return Err(ElaboratorError::EvaluationFailed {
                            reason: format!("Library '{}' was referenced but not loaded", a),
                            span: *span,
                            file_id: self.file_id,
                        });
                    }
                }
                ContextItem::Use { path, span } => {
                    self.elaborate_use_clause(*path, env, registry, *span)?;
                }
            }
        }
        Ok(())
    }

    fn elaborate_use_clause(
        &self,
        path: crate::ast::ExprId,
        env: &mut Environment,
        registry: &LibraryRegistry,
        span: Span,
    ) -> Result<(), ElaboratorError> {
        let mut parts: Vec<&str> = vec![];
        let ast = self.get_ast(self.file_id);
        let mut expr = ast.expr(path);
        loop {
            expr = match expr {
                Expr::RecordAccess { target, field } => {
                    parts.push(self.get_str(*field));
                    ast.expr(*target)
                }
                Expr::Identifier { name } => {
                    parts.push(self.get_str(*name));
                    break;
                }
                _ => unreachable!("Checked during SA"),
            }
        }
        parts.reverse();

        let lib_name = parts[0];
        let pkg_name = parts[1];
        let selector = parts[2];

        let pkg_exports = registry.get_package(lib_name, pkg_name).ok_or_else(|| {
            ElaboratorError::EvaluationFailed {
                reason: format!("Package '{}.{}' not found in registry", lib_name, pkg_name),
                span,
                file_id: self.file_id,
            }
        })?;

        if selector.eq("all") {
            env.import_package(pkg_exports);
        } else {
            let item_sym = self
                .sa
                .symbols
                .interner
                .get_symbol(&selector)
                .ok_or_else(|| ElaboratorError::EvaluationFailed {
                    reason: format!("Item '{}' not found in symbol interner", selector),
                    span,
                    file_id: self.file_id,
                })?;

            // If 'use std.logic_1644.std_logic', it imports into env std_logic from pkg_exports i.e. std.logic_1644
            if !env.import_package_item(pkg_exports, item_sym) {
                return Err(ElaboratorError::EvaluationFailed {
                    reason: format!(
                        "Symbol '{}' does not exist in '{}.{}'",
                        selector, lib_name, pkg_name
                    ),
                    span,
                    file_id: self.file_id,
                });
            }
        }

        Ok(())
    }

    fn get_symbol(&self, name: &str) -> Option<SymbolId> {
        self.sa.symbols.interner.get_symbol(name)
    }

    pub fn get_type_bounds(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<(i64, i64), ElaboratorError> {
        let type_id = self.get_type_from_expr(expr_id);
        if Some(type_id) == self.sa.type_std_logic
            || type_id == self.sa.type_boolean
            || type_id == self.sa.type_real
        {
            return Ok((0, 0));
        }

        if type_id == self.sa.type_integer {
            return Ok((i32::MAX as i64, i32::MIN as i64));
        }
        dbg!(self.sa.type_std_logic);
        dbg!(&self.sa.types.get(type_id));
        match self.sa.types.get(type_id) {
            Some(TypeKind::Array { element_type, name }) => {
                // dbg!(self.get_str(*name));
                let ast = self.sa.get_ast(self.file_id);
                dbg!(ast.expr(expr_id));
                let Expr::Slice {
                    target,
                    direction,
                    left,
                    right,
                } = ast.expr(expr_id)
                else {
                    panic!();
                };
                let left_val = self.eval_const_expr(*left, env)?;
                let EvaluatedValue::Integer(l_val) = left_val else {
                    panic!()
                };
                let right_val = self.eval_const_expr(*right, env)?;
                let EvaluatedValue::Integer(r_val) = right_val else {
                    panic!()
                };

                let slice_low = l_val.min(r_val);
                let slice_high = l_val.max(r_val);

                Ok((slice_high, slice_low))
            } // TODO
            _ => {
                panic!();
                Err(ElaboratorError::NotYetImplemented {
                    feature: "Other kinds of types".to_string(),
                    span: self.sa.get_ast(self.file_id).span(expr_id),
                    file_id: self.file_id,
                })
            }
        }
    }

    fn resolve_type_by_sym(&self, name: SymbolId) -> Result<TypeId, ElaboratorError> {
        if let Some(decl_ref) = self.sa.symbols.lookup(self.sa.current_scope, name) {
            return Ok(self.sa.get_decl_type(decl_ref));
        }
        let clean = self.get_str(name);
        dbg!(clean);
        match clean {
            "std_logic" => Ok(self
                .sa
                .type_std_logic
                .expect("Was checked existing by the SA")),
            "std_logic_vector" => Ok(self
                .sa
                .type_std_logic_vector
                .expect("Was checked existing by the SA")),
            "integer" => Ok(self.sa.type_integer),
            "boolean" => Ok(self.sa.type_boolean),
            "real" => Ok(self.sa.type_real),
            _ => Err(ElaboratorError::EvaluationFailed {
                reason: format!("Unknown type identifier '{}'", clean),
                span: Span { start: 0, end: 0 },
                file_id: self.file_id,
            }),
        }
    }

    fn get_thing<Id, Thing>(&self, id: Id, file_id: FileId) -> &Thing
    where
        AstArena: GetThing<Id, Thing>,
    {
        let ast = &self.sa.asts[file_id.0 as usize];
        ast.get_thing(id)
    }

    fn get_ast(&self, file_id: crate::workspace::FileId) -> &AstArena {
        &self.sa.asts[file_id.0 as usize]
    }

    fn get_type_from_expr(&self, decl_type: crate::ast::ExprId) -> TypeId {
        self.sa.expr_types[decl_type.0 as usize]
    }

    fn lower_type_conversion(
        &self,
        target_type_id: TypeId,
        remove: ExprId,
    ) -> Result<ExprId, ElaboratorError> {
        todo!()
    }
}
pub trait FromDeclRef<'a, Target> {
    fn fetch_from_decl(&'a self, decl: &DeclRef) -> (&Target, FileId, ScopeId);
}

impl<'a> FromDeclRef<'a, Entity> for Elaborator<'a> {
    fn fetch_from_decl(&'a self, decl: &DeclRef) -> (&Entity, FileId, ScopeId) {
        if let DeclRef::Entity {
            file_id,
            entity_id,
            scope_id,
        } = decl
        {
            let ast = &self.sa.asts[file_id.0 as usize];
            (&ast.entities[entity_id.0 as usize], *file_id, *scope_id)
        } else {
            panic!()
        }
    }
}

impl<'a> FromDeclRef<'a, Architecture> for Elaborator<'a> {
    fn fetch_from_decl(&'a self, decl: &DeclRef) -> (&Architecture, FileId, ScopeId) {
        if let DeclRef::Architecture {
            file_id,
            ast_id,
            scope_id,
            ..
        } = decl
        {
            let ast = &self.sa.asts[file_id.0 as usize];
            (&ast.architectures[ast_id.0 as usize], *file_id, *scope_id)
        } else {
            panic!()
        }
    }
}
