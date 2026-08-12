use std::{collections::HashMap, fmt::format};

use crate::ast::{ArchitectureId, AstArena, EntityId, Expr};
use crate::{
    analyzer::{DeclRef, ScopeId, SemanticAnalyzer, SymbolId},
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
    /// Since the Semantic Analyzer already successfully validated the design, we can safely unwrap.
    fn get_symbol(&self, name: &str) -> SymbolId {
        self.sa
            .symbols
            .interner
            .get(name)
            .unwrap_or_else(|| panic!("Symbol '{}' missing from SA interner", name))
    }
    /// The main entry point. Finds the top-level entity and builds the hardware tree.
    pub fn elaborate(&mut self, top_entity_name: &str) -> Result<InstanceId, ElaboratorError> {
        let entity_id = self
            .find_entity(top_entity_name)
            .ok_or_else(|| ElaboratorError::EntityNotFound(top_entity_name.to_string()))?;

        let arch_id = self
            .find_architecture_for_entity(entity_id)
            .ok_or_else(|| ElaboratorError::ArchitectureNotFound(top_entity_name.to_string()))?;

        self.elaborate_architecture(entity_id, arch_id, None)
    }

    /// Recursively builds a physical hardware instance from an AST Entity/Architecture pair.
    fn elaborate_architecture(
        &mut self,
        entity_id: EntityId,
        arch_id: ArchitectureId,
        parent: Option<InstanceId>,
    ) -> Result<InstanceId, ElaboratorError> {
        let entity = &self.ast.entities[entity_id.0 as usize];
        let arch = &self.ast.architectures[arch_id.0 as usize];

        let entity_sym = self.get_symbol(&entity.name);
        let global_scope = ScopeId(0);
        let entity_scope = match self.sa.symbols.lookup(global_scope, entity_sym) {
            Some(DeclRef::Entity { scope_id, .. }) => scope_id,
            _ => return Err(ElaboratorError::EntityNotFound(entity.name.to_string())),
        };

        // Create a new unique ID for this hardware instance
        let current_instance_id = self.get_instance_id();

        // Hierarchical path for debugging and signal identification
        let hierarchical_path = match parent {
            Some(_parent_id) => format!("instance_{}", current_instance_id.0),
            None => ":".to_string(), // Root path
        };

        let mut env = Environment::new();

        let generics = self.elaborate_generics(entity, &mut env)?;

        // Elaborate Ports (Create physical pins for this chip)
        let (ports, port_bindings) = self.elaborate_ports(entity, &mut env)?;

        // Elaborate Declarations (internal wiring)
        let mut local_signals = Vec::new();
        let mut local_constants = HashMap::new();
        self.elaborate_declarations(
            entity_scope,
            arch,
            &mut env,
            &mut local_signals,
            &mut local_constants,
        )?;

        // Elaborate Concurrent Statements (Instantiate child chips, processes, and continuous assignments)

        let (concurrent_assignments, processes, children) = self.elaborate_concurrent_stmts(
            arch,
            &mut env,
            current_instance_id,
            &hierarchical_path,
        )?;

        let entity_sym = self.get_symbol(&entity.name);
        let arch_sym = self.get_symbol(&arch.name);

        let new_instance_node = InstanceNode {
            instance_name: entity_sym,
            entity_name: entity_sym,
            architecture_name: arch_sym,
            hierarchical_path,
            generics,
            ports,
            port_bindings,
            local_signals,
            local_constants,
            concurrent_assignments,
            processes,
            children,
        };

        // Register the finished chip in our elaborated arena
        self.arena
            .instances
            .insert(current_instance_id.0 as usize, new_instance_node);

        Ok(current_instance_id)
    }

    fn get_instance_id(&mut self) -> InstanceId {
        let current_instance_id = InstanceId(self.instance_counter);
        self.instance_counter += 1;
        current_instance_id
    }

    fn find_entity(&self, name: &str) -> Option<EntityId> {
        // If not, it can't possibly exist in the source code.
        let sym_id = self.sa.symbols.interner.get(name)?;

        let global_scope = ScopeId(0);
        let decl_ref = self.sa.symbols.lookup(global_scope, sym_id)?;

        match decl_ref {
            DeclRef::Entity { entity_id, .. } => Some(entity_id),
            _ => None, // The name exists, but it's not an Entity (it could be a package)
        }
    }

    /// The last defined architecture is used for the entity
    fn find_architecture_for_entity(&self, target_entity: EntityId) -> Option<ArchitectureId> {
        self.sa
            .entity_architectures
            .get(&target_entity)
            .and_then(|ids| ids.last())
            .copied()
    }

    fn elaborate_generics(
        &self,
        entity: &crate::ast::Entity<'_>,
        env: &mut Environment,
    ) -> Result<HashMap<SymbolId, EvaluatedValue>, ElaboratorError> {
        let generics = HashMap::new();
        // Iterate through entity.generics, evaluate expressions, populate env and map
        todo!();
        Ok(generics)
    }
    fn elaborate_ports(
        &mut self,
        entity: &crate::ast::Entity,
        env: &mut Environment,
    ) -> Result<(Vec<ElaboratedPort>, Vec<PortBinding>), ElaboratorError> {
        let mut ports = Vec::new();
        let mut bindings = Vec::new();

        let entity_sym = self.get_symbol(&entity.name);
        let global_scope = ScopeId(0);

        let entity_decl = self
            .sa
            .symbols
            .lookup(global_scope, entity_sym)
            .ok_or_else(|| ElaboratorError::EntityNotFound(entity.name.to_string()))?;

        let entity_scope = match entity_decl {
            DeclRef::Entity { scope_id, .. } => scope_id,
            _ => return Err(ElaboratorError::EntityNotFound(entity.name.to_string())),
        };

        for port_decl in self.ast.ports(entity) {
            let port_sym = self.get_symbol(&port_decl.name);

            let port_ref = self
                .sa
                .symbols
                .lookup(entity_scope, port_sym)
                .expect("Port symbol must exist in SA since it passed analysis");

            let (type_id, mode) = match port_ref {
                DeclRef::Port { type_id, mode, .. } => (type_id, mode),
                _ => unreachable!("Symbol mapped to non-port in entity scope"),
            };

            let sig_id = self.arena.alloc_signal(ElaboratedSignal {
                name: port_sym,
                type_id,
                high_bound: 0, // TODO: Extract from type_id's constraints next
                low_bound: 0,
                driver_count: 0,
            });

            env.insert_signal(port_sym, sig_id);

            ports.push(ElaboratedPort {
                name: port_sym,
                mode,
                type_id,
                high_bound: 0, // TODO
                low_bound: 0,
            });

            bindings.push(PortBinding {
                port_name: port_sym,
                actual_signal: sig_id,
            });
        }

        Ok((ports, bindings))
    }

    /// Resolves architecture-level signal declarations and constant evaluations.
    fn elaborate_declarations(
        &mut self,
        entity_scope: ScopeId, // Pass this down from `elaborate_architecture`
        arch: &crate::ast::Architecture,
        env: &mut Environment,
        local_signals: &mut Vec<SignalId>,
        local_constants: &mut HashMap<SymbolId, EvaluatedValue>,
    ) -> Result<(), ElaboratorError> {
        // 1. Look up the Architecture in the Entity's scope
        let arch_sym = self.get_symbol(&arch.name);
        let arch_decl = self
            .sa
            .symbols
            .lookup(entity_scope, arch_sym)
            .ok_or_else(|| ElaboratorError::ArchitectureNotFound(arch.name.to_string()))?;

        // 2. Extract the architecture's specific ScopeId
        let arch_scope = match arch_decl {
            DeclRef::Architecture { scope_id, .. } => scope_id,
            _ => return Err(ElaboratorError::ArchitectureNotFound(arch.name.to_string())),
        };

        // 3. Iterate over the AST declarations
        for decl in self.ast.declarations(arch) {
            match decl {
                crate::ast::Decl::Signal {
                    name,
                    decl_type: _,
                    default_val: _,
                } => {
                    let sym = self.get_symbol(name);

                    // Query the SA's scope tree
                    let sig_decl = self
                        .sa
                        .symbols
                        .lookup(arch_scope, sym)
                        .expect("Signal must exist in SA since it passed analysis");

                    let type_id = self.sa.get_decl_type(sig_decl);

                    let sig_id = self.arena.alloc_signal(ElaboratedSignal {
                        name: sym,
                        type_id,
                        high_bound: 0, // TODO: Extract from type_id
                        low_bound: 0,
                        driver_count: 0,
                    });

                    env.insert_signal(sym, sig_id);
                    local_signals.push(sig_id);
                }

                crate::ast::Decl::Constant {
                    name,
                    decl_type: _,
                    default_val,
                } => {
                    let sym = self.get_symbol(name);

                    let Some(val) = default_val else {
                        continue;
                    };

                    // Evaluate the right-hand side of the constant at compile time
                    let evaluated_val = self.eval_const_expr(*val, env)?;

                    env.insert_value(sym, evaluated_val.clone());
                    local_constants.insert(sym, evaluated_val);
                }
                _ => {}
            }
        }
        Ok(())
    }

    /// Flattens processes, evaluates assignments, and recurses down child component instances.
    fn elaborate_concurrent_stmts(
        &mut self,
        arch: &crate::ast::Architecture,
        env: &mut Environment,
        _current_instance_id: InstanceId,
        _path: &str,
    ) -> Result<
        (
            Vec<ElaboratedConcurrentAssignment>,
            Vec<ProcessId>,
            Vec<InstanceId>,
        ),
        ElaboratorError,
    > {
        let mut concurrent_assignments = Vec::new();
        let mut processes = Vec::new();
        let mut children = Vec::new();

        for stmt in self.ast.conc_statements(arch) {
            match stmt {
                crate::ast::ConcurrentStmt::ConcurrentAssignment {
                    label,
                    target,
                    expression,
                } => {
                    let target_expr = self.ast.expr(*target);
                    let target_sym = self
                        .get_base_symbol(*target)
                        .expect("It should be there already");

                    let target_sig = env.lookup_signal(target_sym).ok_or_else(|| {
                        ElaboratorError::SignalNotFound(format!("{:?}", target_sym))
                    })?;

                    let value_expr = self.lower_expr(*expression, env)?;

                    concurrent_assignments.push(ElaboratedConcurrentAssignment {
                        target_signal: target_sig,
                        value_expr,
                    });
                }
                crate::ast::ConcurrentStmt::Process {
                    label,
                    process_vars,
                    stmts,
                } => {
                    let proc_id = self.elaborate_process(stmt, env)?;
                    processes.push(proc_id);
                }
                crate::ast::ConcurrentStmt::ComponentInstantiation {
                    label,
                    component_name,
                    port_map_span,
                } => {
                    // Look up child entity/arch and recursively elaborate
                    let child_sym = self.get_symbol(component_name);
                    let child_entity = self.find_entity_by_sym(child_sym)?;
                    let child_arch =
                        self.find_architecture_for_entity(child_entity)
                            .ok_or_else(|| {
                                ElaboratorError::ArchitectureNotFound((*component_name).into())
                            })?;

                    let child_id = self.elaborate_architecture(
                        child_entity,
                        child_arch,
                        Some(_current_instance_id),
                    )?;

                    children.push(child_id);
                }
                crate::ast::ConcurrentStmt::ConditionalAssignment { target } => todo!(),
            }
        }

        Ok((concurrent_assignments, processes, children))
    }

    fn get_base_symbol(&self, expr_id: crate::ast::ExprId) -> Option<SymbolId> {
        match self.ast.exprs[expr_id.0 as usize] {
            Expr::Identifier { name, .. } => self.sa.symbols.interner.get(name),
            Expr::CallOrIndex { callee, .. } => {
                // If it's my_arr(0), the base declaration is 'my_arr'
                self.get_base_symbol(callee)
            }
            _ => None,
        }
    }

    /// Evaluates an AST expression into a static compile-time value.
    /// This is used for literals, generic mappings, and array bounds.
    pub fn eval_const_expr(
        &self,
        expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<EvaluatedValue, ElaboratorError> {
        todo!()
    }

    /// Lowers a syntactic AST expression into a physical ElaboratedExpr,
    /// allocates it in the ElaboratedArena, and returns its physical ExprId.
    pub(crate) fn lower_expr(
        &mut self,
        ast_expr_id: crate::ast::ExprId,
        env: &Environment,
    ) -> Result<ExprId, ElaboratorError> {
        let ast_expr = &self.ast.expr(ast_expr_id);

        let span = ast_expr.span();
        let evaluated_expr = match ast_expr {
            crate::ast::Expr::Identifier { name, .. } => {
                let sym = self.get_symbol(name);

                // Is it a compile-time constant or generic?
                if let Some(val) = env.lookup_value(sym) {
                    EvaluatedExpr::Literal(val.clone())
                }
                // Is it a physical signal/wire?
                else if let Some(sig_id) = env.lookup_signal(sym) {
                    EvaluatedExpr::SignalRead(sig_id)
                }
                // We don't know what this identifier is
                else {
                    return Err(ElaboratorError::EvaluationFailed {
                        reason: format!(
                            "Identifier '{}' is not a known signal, constant, or generic in this scope.",
                            name
                        ),
                        span,
                    });
                }
            }

            crate::ast::Expr::Binary { op, lhs, rhs, span } => {
                // Recursively lower the left and right sides.
                // Notice we pass `env` down so the children have the same scope context.
                let lhs_physical_id = self.lower_expr(*lhs, env)?;
                let rhs_physical_id = self.lower_expr(*rhs, env)?;

                // TODO check if we need to lower the operator as well or like this is alright
                EvaluatedExpr::BinaryOp {
                    lhs: lhs_physical_id,
                    op: op.clone(),
                    rhs: rhs_physical_id,
                }
            }

            crate::ast::Expr::Literal { text, span } => {
                let lit = self.get_symbol(*text);
                todo!();

                // let val = match lit {
                //     crate::parser::ast::Literal::Integer(i) => EvaluatedValue::Integer(*i),
                //     crate::parser::ast::Literal::Boolean(b) => EvaluatedValue::Boolean(*b),
                //     // ... other literal types
                //     _ => {
                //         return Err(ElaboratorError::NotYetImplemented {
                //             feature: "Complex literals".into(),
                //             span,
                //         });
                //     }
                // };
                // EvaluatedExpr::Literal(val)
            }

            // Catch-all for things like FunctionCalls, ArrayIndexing, etc., that you haven't built yet
            _ => {
                return Err(ElaboratorError::NotYetImplemented {
                    feature: format!("Lowering for AST Expr variant: {:?}", ast_expr),
                    span,
                });
            }
        };

        let physical_expr_id = self.arena.alloc_expr(evaluated_expr);

        Ok(physical_expr_id)
    }

    fn elaborate_process(
        &mut self,
        proc_ast: &crate::ast::ConcurrentStmt,
        env: &Environment,
    ) -> Result<ProcessId, ElaboratorError> {
        todo!();
        let proc_id = ProcessId(self.arena.processes.len() as u32);
        self.arena.processes.push(ElaboratedProcess {
            label: SymbolId(0),
            sensitivity_list: Vec::new(),
            body_stmts: Vec::new(),
        });
        Ok(proc_id)
    }

    pub(crate) fn find_entity_by_sym(
        &self,
        entity_sym: SymbolId,
    ) -> Result<EntityId, ElaboratorError> {
        let global_scope = ScopeId(0);

        let decl_ref = self
            .sa
            .symbols
            .lookup(global_scope, entity_sym)
            .ok_or_else(|| ElaboratorError::EntityNotFound("Component name not found".into()))?;

        match decl_ref {
            DeclRef::Entity { entity_id, .. } => Ok(entity_id),

            _ => Err(ElaboratorError::NotAnEntity),
        }
    }
}
