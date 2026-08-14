use std::collections::HashMap;

use crate::analyzer::SemanticErrorKind::DuplicateDeclaration;
use crate::analyzer::{DeclRef, ExprId, ScopeKind, SemanticError, SemanticErrorKind, SymbolTable, TypeArena, TypeId, TypeKind};
use crate::ast::*;
use crate::parser::Span;

impl<'a> super::SemanticAnalyzer<'a> {
        pub fn new(ast: &'a AstArena<'a>, mut symbols: SymbolTable, source: &'a str) -> Self {
        let root_scope = symbols.scopes.alloc(ScopeKind::Global, None);
        let mut types = TypeArena::default();

        // Intern primitive VHDL types into Global Scope
        let std_logic_sym = symbols.interner.get_or_internalize("std_logic");
        let type_std_logic = types.alloc(TypeKind::Enum {
            name: std_logic_sym,
            literals: vec![],
        });
        let _ = symbols.define(root_scope, std_logic_sym, DeclRef::Type(type_std_logic));

        let integer_sym = symbols.interner.get_or_internalize("integer");
        let type_integer = types.alloc(TypeKind::Integer { name: integer_sym });
        let _ = symbols.define(root_scope, integer_sym, DeclRef::Type(type_integer));

        let real_sym = symbols.interner.get_or_internalize("real");
        let type_real = types.alloc(TypeKind::Real { name: real_sym });
        let _ = symbols.define(root_scope, real_sym, DeclRef::Type(type_real));

        let boolean_sym = symbols.interner.get_or_internalize("boolean");
        let type_boolean = types.alloc(TypeKind::Enum {
            name: boolean_sym,
            literals: vec![],
        });
        let _ = symbols.define(root_scope, boolean_sym, DeclRef::Type(type_boolean));

        let std_logic_vector_sym = symbols.interner.get_or_internalize("std_logic_vector");
        let type_std_logic_vector = types.alloc(TypeKind::Array {
            name: std_logic_vector_sym,
            element_type: type_std_logic,
        });
        let _ = symbols.define(
            root_scope,
            std_logic_vector_sym,
            DeclRef::Type(type_std_logic_vector),
        );

        Self {
            ast,
            symbols,
            types,
            current_scope: root_scope,
            errors: Vec::new(),
            type_std_logic,
            type_std_logic_vector,
            type_integer,
            type_boolean,
            type_real,
            entity_architectures: HashMap::new(),
            source,
            expr_types: Vec::new(),
        }
    }
    
    pub fn analyze_all(&mut self) {
        for (i, entity) in self.ast.entities.iter().enumerate() {
            self.analyze_entity(entity, i as u32);
        }

        for (i, arch) in self.ast.architectures.iter().enumerate() {
            self.analyze_architecture(arch, i as u32);
        }
    }

    fn analyze_entity(&mut self, entity: &Entity<'a>, entity_id: u32) {
        let entity_sym = self.symbols.interner.get_or_internalize(entity.name);
        let entity_scope = self
            .symbols
            .scopes
            .alloc(ScopeKind::Entity, Some(self.current_scope));

        if let Err(_s) = self.symbols.define(
            self.current_scope,
            entity_sym,
            DeclRef::Entity {
                entity_id: EntityId(entity_id),
                scope_id: entity_scope,
            },
        ) {
            self.errors.push(SemanticError {
                kind: DuplicateDeclaration(entity.name.to_string()),
                span: entity.name_span,
            });
        }

        let prev_scope = self.current_scope;
        self.current_scope = entity_scope;

        // Populate Ports into Entity Scope
        let port_slice =
            &self.ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];

        for (idx, port) in port_slice.iter().enumerate() {
            let port_sym = self.symbols.interner.get_or_internalize(port.name);
            let absolute_port_id = PortId(entity.ports_start.0 + idx as u32);

            let type_id = self.resolve_type_by_name(port.port_type);

            if let Err(_s) = self.symbols.define(
                entity_scope,
                port_sym,
                DeclRef::Port {
                    id: absolute_port_id,
                    type_id,
                    mode: port.mode,
                },
            ) {
                self.errors.push(SemanticError {
                    kind: SemanticErrorKind::DuplicateDeclaration(port.name.to_string()),
                    span: port.name_span,
                });
            }
        }

        self.current_scope = prev_scope;
    }

    fn analyze_architecture(&mut self, arch: &Architecture<'a>, arch_id: u32) {
        // Link Architecture Scope -> Entity Scope -> Global Scope
        //Should be safe to unwrap
        let entity_sym = self
            .symbols
            .interner
            .get_symbol(self.get_text(&arch.entity_name)).unwrap();
        self.symbols.interner.get_or_internalize(arch.name);
        
        // Find corresponding Entity scope (or fallback to Global)
        let (entity_scope, entity_id) = match self.symbols.lookup(self.current_scope, entity_sym) {
            Some(DeclRef::Entity {
                scope_id,
                entity_id,
            }) => (scope_id, entity_id),
            _s => {
                self.errors.push(SemanticError {
                    kind: SemanticErrorKind::UndefinedSymbol(
                        self.get_text(&arch.entity_name).to_owned(),
                    ),
                    span: arch.entity_name,
                });
                return;
            }
        };

        self.entity_architectures
            .entry(entity_id)
            .or_default()
            .push(ArchitectureId(arch_id));

        let arch_scope = self
            .symbols
            .scopes
            .alloc(ScopeKind::Architecture, Some(entity_scope));

        let prev_scope = self.current_scope;
        self.current_scope = arch_scope;

        // Populate Declarations (Signals, Variables, Constants)
        // TODO enforce assignment rules over declarations
        let decl_slice = &self.ast.decls[arch.decls_start.0 as usize..arch.decls_end.0 as usize];
        for (idx, decl) in decl_slice.iter().enumerate() {
            let absolute_decl_id = DeclId(arch.decls_start.0 + idx as u32);

            let (name, decl_ref) = match decl {
                Decl::Signal {
                    name, decl_type, ..
                } => (
                    name,
                    DeclRef::Signal {
                        id: absolute_decl_id,
                        type_id: self.resolve_type_by_name(decl_type),
                    },
                ),
                Decl::Variable {
                    name, decl_type, ..
                } => (
                    name,
                    DeclRef::Variable {
                        id: absolute_decl_id,
                        type_id: self.resolve_type_by_name(decl_type),
                    },
                ),
                Decl::Constant {
                    name, decl_type, ..
                } => (
                    name,
                    DeclRef::Constant {
                        id: absolute_decl_id,
                        type_id: self.resolve_type_by_name(decl_type),
                    },
                ),
                _ => continue,
            };

            let sym = self.symbols.interner.get_or_internalize(name);
            let a = self.symbols.define(arch_scope, sym, decl_ref);
            if a.is_err() {
                self.errors.push(SemanticError {
                    kind: DuplicateDeclaration(name.to_string()),
                    span: Span { start: 0, end: 0 },
                });
                //TODO correct span
            }
        }

        let conc_ids =
            &self.ast.conc_stmt_lists[arch.stmts.start as usize..arch.stmts.end as usize];
        for id in conc_ids {
            let stmt = &self.ast.concurrent_stmts[id.0 as usize];
            self.check_concurrent_stmt(stmt);
        }

        self.current_scope = prev_scope;
    }

    /// Helper to dig through arrays/fields to find the root Identifier being assigned to
    pub(crate) fn get_base_declaration(&mut self, expr_id: ExprId) -> Option<DeclRef> {
        match self.ast.exprs[expr_id.0 as usize].clone() {
            Expr::Identifier { name, .. } => {
                let sym = self.symbols.interner.get_or_internalize(&name);
                self.symbols.lookup(self.current_scope, sym)
            }
            Expr::CallOrIndex { callee, .. } => {
                // If it's my_arr(0), the base declaration is 'my_arr'
                self.get_base_declaration(callee)
            }
            _ => None,
        }
    }

    /// Helper to fetch the TypeId assigned to a declaration
    pub fn get_decl_type(&self, decl_ref: DeclRef) -> TypeId {
        match decl_ref {
            DeclRef::Port { type_id, .. } => type_id,
            DeclRef::Signal { type_id, .. } => type_id,
            DeclRef::Variable { type_id, .. } => type_id,
            DeclRef::Constant { type_id, .. } => type_id,
            DeclRef::Type(type_id) => type_id,
            DeclRef::Entity { .. } | DeclRef::Architecture { .. } => TypeId::ERROR,
        }
    }

    fn resolve_type_by_name(&mut self, name: &str) -> TypeId {
        let sym = self.symbols.interner.get_or_internalize(name);
        match self.symbols.lookup(self.current_scope, sym) {
            Some(DeclRef::Type(type_id)) => type_id,
            _ => TypeId::ERROR,
        }
    }

    fn get_text(&self, span: &Span) -> &'a str {
        &self.source[span.start..span.end]
    }

    fn check_concurrent_stmt(&mut self, stmt: &ConcurrentStmt<'a>) {
        match stmt {
            ConcurrentStmt::Process { stmts, .. } => {
                let proc_scope = self
                    .symbols
                    .scopes
                    .alloc(ScopeKind::Process, Some(self.current_scope));

                let prev_scope = self.current_scope;
                self.current_scope = proc_scope;

                // Check process body statements
                let seq_ids = &self.ast.seq_stmt_lists[stmts.start as usize..stmts.end as usize];
                for id in seq_ids {
                    let seq_stmt = &self.ast.sequential_stmts[id.0 as usize];
                    self.check_sequential_stmt(seq_stmt);
                }

                self.current_scope = prev_scope;
            }
            ConcurrentStmt::ConcurrentAssignment {
                target,
                expression,
                label: _,
            } => {
                self.check_assignment_semantics(*target, *expression, true);
            }
            _ => todo!(),
        }
    }

    fn check_boolean_condition(&mut self, condition: ExprId) {
        let cond_type_res = self.infer_expr_type(condition, Some(self.type_boolean));

        match cond_type_res {
            Ok(cond_type) => {
                if cond_type != self.type_boolean {
                    let span = self.ast.exprs[condition.0 as usize].span();
                    self.errors.push(SemanticError {
                        kind: SemanticErrorKind::ConditionNotBoolean { found: cond_type },
                        span,
                    });
                }
            }
            Err(err) => {
                self.errors.push(SemanticError {
                    kind: err.kind,
                    span: err.span,
                });
            }
        }
    }

    fn check_sequential_stmt(&mut self, stmt: &SequentialStmt<'a>) {
        match stmt {
            SequentialStmt::SequentialAssignment { target, expression } => {
                // Signal assignment `<=`
                self.check_assignment_semantics(*target, *expression, true);
            }
            SequentialStmt::VariableAssignment { target, expression } => {
                // Variable assignment `:=`
                self.check_assignment_semantics(*target, *expression, false);
            }
            SequentialStmt::If {
                then_stmts,
                elsif_stmts,
                else_stmts,
                condition,
            } => {
                // Check IF condition
                self.check_boolean_condition(*condition);
                // Check THEN block
                self.check_sequential_stmt_list(then_stmts);
                // Check ELSIF blocks
                for elsif in &self.ast.elsifs[elsif_stmts.start as usize..elsif_stmts.end as usize]
                {
                    self.check_boolean_condition(elsif.condition);
                    self.check_sequential_stmt_list(&elsif.stmts);
                }
                // Check ELSE block
                if !else_stmts.is_empty() {
                    self.check_sequential_stmt_list(else_stmts);
                }
            }
            SequentialStmt::Case { .. } => todo!(),
            SequentialStmt::Loop { .. } => todo!(),
            SequentialStmt::ProcedureCall { .. } => todo!(),
        }
    }

    fn check_sequential_stmt_list(&mut self, range: &std::ops::Range<u32>) {
        let stmt_ids = &self.ast.seq_stmt_lists[range.start as usize..range.end as usize];
        for id in stmt_ids {
            self.check_sequential_stmt(&self.ast.sequential_stmts[id.0 as usize]);
        }
    }

    fn check_assignment_semantics(
        &mut self,
        target_expr: ExprId,
        rhs_expr: ExprId,
        is_signal_assign: bool,
    ) {
        let target_type_res = self.infer_expr_type(target_expr, None);

        let expected_rhs = target_type_res.as_ref().ok().copied();
        let rhs_type_res = self.infer_expr_type(rhs_expr, expected_rhs);

        if let (Ok(target_type), Ok(rhs_type)) = (target_type_res, rhs_type_res) {
            if target_type != rhs_type {
                self.errors.push(SemanticError {
                    kind: SemanticErrorKind::AssignmentTypeMismatch {
                        expected: target_type,
                        found: rhs_type,
                    },
                    span: self.ast.exprs[rhs_expr.0 as usize].span(),
                });
            }
        }

        // Signal vs Variable invariants
        if let Some(base_sym_decl) = self.get_base_declaration(target_expr) {
            let target_span = self.ast.exprs[target_expr.0 as usize].span();

            match (base_sym_decl, is_signal_assign) {
                (DeclRef::Variable { .. }, true) => {
                    self.errors.push(SemanticError {
                        kind: SemanticErrorKind::InvalidAssignmentKind {
                            expected_signal: false,
                        },
                        span: target_span,
                    });
                }
                (DeclRef::Signal { .. }, false) => {
                    self.errors.push(SemanticError {
                        kind: SemanticErrorKind::InvalidAssignmentKind {
                            expected_signal: true,
                        },
                        span: target_span,
                    });
                }
                (DeclRef::Port { mode, .. }, true) => {
                    if mode == PortMode::In {
                        self.errors.push(SemanticError {
                            kind: SemanticErrorKind::WriteToInputPort("<port>".to_string()), // TODO maybe something better
                            span: target_span,
                        });
                    }
                }
                (DeclRef::Constant { .. }, _) => {
                    self.errors.push(SemanticError {
                        kind: SemanticErrorKind::InvalidAssignmentKind {
                            expected_signal: is_signal_assign,
                        },
                        span: target_span,
                    });
                }
                _ => {} // Valid assignments
            }
        }
    }
}
