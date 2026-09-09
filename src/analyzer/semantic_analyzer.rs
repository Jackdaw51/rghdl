// use std::collections::HashMap;

// use crate::analyzer::SemanticErrorKind::DuplicateDeclaration;
// use crate::analyzer::{
//     DeclRef, ExprId, ScopeId, ScopeKind, SemanticError, SemanticErrorKind, SymbolId, SymbolTable,
//     TypeId,
// };
// use crate::ast::*;
// use crate::elaborator::LibraryRegistry;
// use crate::parser::Span;

// impl<'a> super::SemanticAnalyzer<'a> {
//     pub fn new(
//         ast: &'a AstArena,
//         symbols: &'a mut SymbolTable,
//         registry: &LibraryRegistry,
//     ) -> Self {
//         let root_scope = symbols.scopes.alloc(ScopeKind::Global, None);

//         // We need direct references to these core types for the Semantic Analyzer to do fast type-checking (e.g., checking if an 'if' condition is a boolean)
//         // Ideally we would fetch these from the registry's std.standard and ieee.std_logic_1164 packages.

//         let type_boolean = registry.get_type("std", "standard", "boolean").unwrap();
//         let type_integer = registry.get_type("std", "standard", "integer").unwrap();
//         let type_real = registry.get_type("std", "standard", "real").unwrap();
//         let type_time = registry.get_type("std", "standard", "time").unwrap();
//         let type_std_logic = registry
//             .get_type("ieee", "std_logic_1164", "std_logic")
//             .unwrap();
//         let type_std_logic_vector = registry
//             .get_type("ieee", "std_logic_1164", "std_logic_vector")
//             .unwrap();

//         // ONLY implicitly import `std.standard` into the root scope.
//         // This mimics VHDL's implicit prependation `use std.standard.all;`
//         let std_pkg = registry.get_package("std", "standard").unwrap();
//         for (name_sym, type_id) in &std_pkg.types {
//             symbols
//                 .define(root_scope, *name_sym, DeclRef::Type(*type_id))
//                 .unwrap();
//         }

//         // Notice we DO NOT import ieee.std_logic_1164 here.
//         // The analyzer must wait until it parses a ContextItem::Use { path: "ieee.std_logic_1164.all" }
//         // before looping through ieee_pkg and injecting them into the current file's scope.

//         Self {
//             ast,
//             symbols,
//             types: registry.types.clone(),
//             current_scope: root_scope,
//             errors: Vec::new(),
//             type_std_logic,
//             type_std_logic_vector,
//             type_integer,
//             type_boolean,
//             type_real,
//             type_time,
//             entity_architectures: HashMap::new(),
//             expr_types: Vec::new(),
//         }
//     }

//     pub fn analyze_all(&mut self, registry: &LibraryRegistry) {
//         self.analyze_context_items(registry);

//         for (i, entity) in self.ast.entities.iter().enumerate() {
//             self.analyze_entity(entity, i as u32);
//         }

//         for (i, arch) in self.ast.architectures.iter().enumerate() {
//             self.analyze_architecture(arch, i as u32);
//         }
//     }

//     pub fn analyze_context_items(&mut self, registry: &LibraryRegistry) {
//         for item in &self.ast.contexts {
//             match item {
//                 ContextItem::Library { name, span } => {
//                     self.analyze_library_clause(*name, registry, *span);
//                 }
//                 ContextItem::Use { path, span } => {
//                     self.analyze_use_clause(*path, registry, *span);
//                 }
//             }
//         }
//     }

//     fn analyze_library_clause(&mut self, name: SymbolId, registry: &LibraryRegistry, span: Span) {
//         let lib_lower = self.get_text(name);
//         if lib_lower == "std" || lib_lower == "work" {
//             return;
//         }

//         if !registry.libraries.contains_key(&lib_lower.to_string()) {
//             self.errors.push(SemanticError {
//                 kind: SemanticErrorKind::UndefinedSymbol,
//                 span,
//             });
//         }
//     }

//     fn analyze_use_clause(&mut self, path: ExprId, registry: &LibraryRegistry, span: Span) {
//         let mut expr = self.ast.expr(path);
//         let mut parts: Vec<&str> = vec![];
//         loop {
//             expr = match expr {
//                 Expr::RecordAccess { target, field } => {
//                     parts.push(self.get_text(*field));
//                     self.ast.expr(*target)
//                 }
//                 _ => break,
//             }
//         }

//         if parts.len() < 2 {
//             self.errors.push(SemanticError {
//                 kind: SemanticErrorKind::MalformedUseClause(path),
//                 span,
//             });
//             return;
//         }

//         let lib_name = parts[0];
//         let pkg_name = parts[1];
//         let selector = parts.get(2).copied().unwrap_or("all");

//         let pkg = match registry.get_package(lib_name, pkg_name) {
//             Some(p) => p,
//             None => {
//                 self.errors.push(SemanticError {
//                     kind: SemanticErrorKind::UndefinedSymbol,
//                     span,
//                 });
//                 return;
//             }
//         };

//         if selector.eq_ignore_ascii_case("all") {
//             // Bulk inject all package types into current global scope
//             for (sym_id, type_id) in &pkg.types {
//                 let _ = self
//                     .symbols
//                     .define(self.current_scope, *sym_id, DeclRef::Type(*type_id));
//             }
//             for (&sym_id, argument) in &pkg.functions {
//                 let _ =
//                     self.symbols
//                         .define(self.current_scope, sym_id, DeclRef::Function(*argument));
//             }
//         } else {
//             // Selective import of a single item
//             let selector_lower = selector.to_lowercase();
//             if let Some(&sym_id) = pkg.name_map.get(&selector_lower) {
//                 if let Some(&type_id) = pkg.types.get(&sym_id) {
//                     let _ = self
//                         .symbols
//                         .define(self.current_scope, sym_id, DeclRef::Type(type_id));
//                 }
//                 if let Some(&type_id) = pkg.functions.get(&sym_id) {
//                     let _ =
//                         self.symbols
//                             .define(self.current_scope, sym_id, DeclRef::Function(type_id));
//                 }
//             } else {
//                 self.errors.push(SemanticError::new(
//                     SemanticErrorKind::NonExistingSymbolInPackage(
//                         self.symbols
//                             .interner
//                             .get_symbol(&selector_lower)
//                             .expect("Symbol should be present here"),
//                     ),
//                     span,
//                 ));
//             }
//         }
//     }

//     fn analyze_entity(&mut self, entity: &Entity, entity_id: u32) {
//         let entity_sym = entity.name;
//         let entity_scope = self
//             .symbols
//             .scopes
//             .alloc(ScopeKind::Entity, Some(self.current_scope));

//         if let Err(_s) = self.symbols.define(
//             self.current_scope,
//             entity_sym,
//             DeclRef::Entity {
//                 entity_id: EntityId(entity_id),
//                 scope_id: entity_scope,
//             },
//         ) {
//             self.errors.push(SemanticError {
//                 kind: DuplicateDeclaration,
//                 span: entity.span,
//             });
//         }

//         let prev_scope = self.current_scope;
//         self.current_scope = entity_scope;

//         self.analyze_declarations(entity.generics_start, entity.generics_end, entity_scope);

//         // Populate Ports into Entity Scope
//         let port_slice =
//             &self.ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];

//         for (idx, port) in port_slice.iter().enumerate() {
//             let absolute_port_id = PortId(entity.ports_start.0 + idx as u32);

//             // let type_id = self.resolve_type_by_name(port.port_type);
//             let type_id = match self.infer_expr_type(port.port_type, None) {
//                 Ok(x) => x,
//                 Err(a) => {
//                     self.errors.push(a);
//                     TypeId::ERROR
//                 }
//             };

//             if let Err(_s) = self.symbols.define(
//                 entity_scope,
//                 port.name,
//                 DeclRef::Port {
//                     id: absolute_port_id,
//                     type_id,
//                     mode: port.mode,
//                 },
//             ) {
//                 self.errors.push(SemanticError {
//                     kind: SemanticErrorKind::DuplicateDeclaration,
//                     span: self.span(absolute_port_id),
//                 });
//             }
//         }

//         self.current_scope = prev_scope;
//     }

//     fn analyze_architecture(&mut self, arch: &Architecture, arch_id: u32) {
//         // Link Architecture Scope -> Entity Scope -> Global Scope
//         //Should be safe to unwrap
//         let entity_sym = arch.entity_name;

//         // Find corresponding Entity scope (or fallback to Global)
//         let (entity_scope, entity_id) = match self.symbols.lookup(self.current_scope, entity_sym) {
//             Some(DeclRef::Entity {
//                 scope_id,
//                 entity_id,
//             }) => (scope_id, entity_id),
//             _s => {
//                 self.errors.push(SemanticError {
//                     kind: SemanticErrorKind::EntitySpecifiedNotFound,
//                     span: arch.span,
//                 });
//                 return;
//             }
//         };

//         self.entity_architectures
//             .entry(entity_id)
//             .or_default()
//             .push(ArchitectureId(arch_id));

//         let arch_scope = self
//             .symbols
//             .scopes
//             .alloc(ScopeKind::Architecture, Some(entity_scope));

//         let prev_scope = self.current_scope;
//         self.current_scope = arch_scope;

//         // Populate Declarations (Signals, Variables, Constants)
//         // TODO enforce assignment rules over declarations
//         self.analyze_declarations(arch.decls_start, arch.decls_end, arch_scope);
//         // let decl_slice = &self.ast.decls[arch.decls_start.0 as usize..arch.decls_end.0 as usize];
//         // for (idx, decl) in decl_slice.iter().enumerate() {
//         //     let absolute_decl_id = DeclId(arch.decls_start.0 + idx as u32);

//         //     let (name, decl_ref) = match decl {
//         //         Decl::Signal {
//         //             name, decl_type, ..
//         //         } => (
//         //             name,
//         //             DeclRef::Signal {
//         //                 id: absolute_decl_id,
//         //                 type_id: self.resolve_type_by_name(decl_type),
//         //             },
//         //         ),
//         //         Decl::Variable {
//         //             name, decl_type, ..
//         //         } => (
//         //             name,
//         //             DeclRef::Variable {
//         //                 id: absolute_decl_id,
//         //                 type_id: self.resolve_type_by_name(decl_type),
//         //             },
//         //         ),
//         //         Decl::Constant {
//         //             name, decl_type, ..
//         //         } => (
//         //             name,
//         //             DeclRef::Constant {
//         //                 id: absolute_decl_id,
//         //                 type_id: self.resolve_type_by_name(decl_type),
//         //             },
//         //         ),
//         //         _ => continue,
//         //     };

//         // let sym = self.symbols.interner.get_or_internalize(name);
//         // let a = self.symbols.define(arch_scope, sym, decl_ref);
//         // if a.is_err() {
//         //     self.errors.push(SemanticError {
//         //         kind: DuplicateDeclaration(name.to_string()),
//         //         span: Span { start: 0, end: 0 },
//         //     });
//         //     //TODO correct span
//         // }
//         // }

//         let conc_ids =
//             &self.ast.conc_stmt_lists[arch.stmts.start as usize..arch.stmts.end as usize];
//         for id in conc_ids {
//             self.check_concurrent_stmt(*id);
//         }

//         self.current_scope = prev_scope;
//     }

//     pub fn analyze_declarations(
//         &mut self,
//         decls_start: DeclId,
//         decls_end: DeclId,
//         arch_scope: ScopeId,
//     ) {
//         let decl_slice = &self.ast.decls[decls_start.0 as usize..decls_end.0 as usize];

//         for (idx, decl) in decl_slice.iter().enumerate() {
//             let absolute_decl_id = DeclId(decls_start.0 + idx as u32);

//             match decl {
//                 Decl::Signal {
//                     name,
//                     decl_type,
//                     default_val,
//                 } => {
//                     self.register_declaration(
//                         *name,
//                         *decl_type,
//                         *default_val,
//                         arch_scope,
//                         absolute_decl_id,
//                         |type_id| DeclRef::Signal {
//                             id: absolute_decl_id,
//                             type_id,
//                         },
//                     );
//                 }
//                 Decl::Constant {
//                     name,
//                     decl_type,
//                     default_val,
//                 } => {
//                     self.register_declaration(
//                         *name,
//                         *decl_type,
//                         *default_val,
//                         arch_scope,
//                         absolute_decl_id,
//                         |type_id| DeclRef::Constant {
//                             id: absolute_decl_id,
//                             type_id,
//                         },
//                     );
//                 }
//                 Decl::Variable {
//                     name,
//                     decl_type,
//                     default_val,
//                 } => {
//                     self.register_declaration(
//                         *name,
//                         *decl_type,
//                         *default_val,
//                         arch_scope,
//                         absolute_decl_id,
//                         |type_id| DeclRef::Variable {
//                             id: absolute_decl_id,
//                             type_id,
//                         },
//                     );
//                 }
//                 Decl::Component {
//                     name,
//                     ports_start,
//                     ports_end,
//                 } => {
//                     let component_scope = self
//                         .symbols
//                         .scopes
//                         .alloc(ScopeKind::Block, Some(arch_scope));

//                     let port_slice = &self.ast.ports[ports_start.0 as usize..ports_end.0 as usize];

//                     for (idx, port) in port_slice.iter().enumerate() {
//                         let absolute_port_id = PortId(ports_start.0 + idx as u32);

//                         let type_id = match self.infer_expr_type(port.port_type, None) {
//                             Ok(x) => x,
//                             Err(a) => {
//                                 self.errors.push(a);
//                                 TypeId::ERROR
//                             }
//                         };

//                         if let Err(_s) = self.symbols.define(
//                             component_scope,
//                             port.name,
//                             DeclRef::Port {
//                                 id: absolute_port_id,
//                                 type_id,
//                                 mode: port.mode,
//                             },
//                         ) {
//                             self.errors.push(SemanticError {
//                                 kind: SemanticErrorKind::DuplicateDeclaration,
//                                 span: self.span(absolute_port_id),
//                             });
//                         }
//                     }

//                     self.register_declaration(
//                         *name,
//                         *name,
//                         None,
//                         arch_scope,
//                         absolute_decl_id,
//                         |_| DeclRef::Component {
//                             id: absolute_decl_id,
//                         },
//                     );
//                 }
//             }
//         }
//     }

//     fn register_declaration<F>(
//         &mut self,
//         name: SymbolId,
//         decl_type_name: SymbolId,
//         default_val: Option<ExprId>,
//         arch_scope: ScopeId,
//         decl_id: DeclId,
//         make_decl_ref: F,
//     ) where
//         F: FnOnce(TypeId) -> DeclRef,
//     {
//         let target_type_id = self.resolve_type_by_sym(decl_type_name);

//         // Defualt assignmetn
//         if let Some(expr_id) = default_val {
//             // Supply target_type_id as the contextual hint to resolve aggregates like (others => ...)
//             match self.infer_expr_type(expr_id, Some(target_type_id)) {
//                 Ok(expr_type) => {
//                     if expr_type != target_type_id && expr_type != TypeId::ERROR {
//                         self.errors.push(SemanticError {
//                             kind: SemanticErrorKind::AssignmentTypeMismatch {
//                                 expected: target_type_id,
//                                 found: expr_type,
//                             },
//                             span: self.span(expr_id),
//                         });
//                     }
//                 }
//                 Err(err) => {
//                     self.errors.push(err);
//                 }
//             }
//         }

//         let decl_ref = make_decl_ref(target_type_id);
//         if let Err(_dup) = self.symbols.define(arch_scope, name, decl_ref) {
//             self.errors.push(SemanticError {
//                 kind: SemanticErrorKind::DuplicateDeclaration,
//                 span: self.span(decl_id),
//             });
//         }
//     }

//     /// Helper to dig through arrays/fields to find the root Identifier being assigned to
//     pub(crate) fn get_base_declaration(&mut self, expr_id: ExprId) -> Option<DeclRef> {
//         match self.ast.exprs[expr_id.0 as usize].clone() {
//             Expr::Identifier { name } => self.symbols.lookup(self.current_scope, name),
//             Expr::CallOrIndex { callee, .. } => {
//                 // If it's my_arr(0), the base declaration is 'my_arr'
//                 self.get_base_declaration(callee)
//             }
//             _ => None,
//         }
//     }

//     /// Helper to fetch the TypeId assigned to a declaration
//     pub fn get_decl_type(&self, decl_ref: DeclRef) -> TypeId {
//         match decl_ref {
//             DeclRef::Port { type_id, .. } => type_id,
//             DeclRef::Signal { type_id, .. } => type_id,
//             DeclRef::Variable { type_id, .. } => type_id,
//             DeclRef::Constant { type_id, .. } => type_id,
//             DeclRef::Type(type_id) => type_id,
//             DeclRef::Entity { .. }
//             | DeclRef::Architecture { .. }
//             | DeclRef::Component { .. }
//             | DeclRef::Instance { .. } => TypeId::ERROR,
//             DeclRef::Function(type_id) => type_id,
//         }
//     }

//     pub fn resolve_type_by_sym(&mut self, name: SymbolId) -> TypeId {
//         match self.symbols.lookup(self.current_scope, name) {
//             Some(DeclRef::Type(type_id)) => type_id,
//             _ => TypeId::ERROR,
//         }
//     }

//     fn check_concurrent_stmt(&mut self, stmt_id: ConcStmtId) {
//         let stmt = &self.ast.concurrent_stmts[stmt_id.0 as usize];
//         match stmt {
//             ConcurrentStmt::Process { stmts, .. } => {
//                 let proc_scope = self
//                     .symbols
//                     .scopes
//                     .alloc(ScopeKind::Process, Some(self.current_scope));

//                 let prev_scope = self.current_scope;
//                 self.current_scope = proc_scope;

//                 // Check process body statements
//                 let seq_ids = &self.ast.seq_stmt_lists[stmts.start as usize..stmts.end as usize];
//                 for id in seq_ids {
//                     let seq_stmt = &self.ast.sequential_stmts[id.0 as usize];
//                     self.check_sequential_stmt(seq_stmt);
//                 }

//                 self.current_scope = prev_scope;
//             }
//             ConcurrentStmt::ConcurrentAssignment {
//                 target,
//                 expression,
//                 label: _,
//                 after,
//             } => {
//                 self.check_assignment_semantics(*target, *expression, true);
//                 if let Some(delay_expr) = after {
//                     let delay_type = self.infer_expr_type(*delay_expr, Some(self.type_time));

//                     match delay_type {
//                         Ok(actual_type) if actual_type == self.type_time => {}
//                         Ok(found_type) => {
//                             self.errors.push(SemanticError {
//                                 kind: SemanticErrorKind::AssignmentTypeMismatch {
//                                     expected: self.type_time,
//                                     found: found_type,
//                                 },
//                                 span: self.span(*delay_expr),
//                             });
//                         }
//                         Err(err) => self.errors.push(err),
//                     }
//                 }
//             }
//             ConcurrentStmt::ComponentInstantiation {
//                 label,
//                 component_name,
//                 arch_qualifier: _,
//                 generic_map: _,
//                 port_map,
//             } => {
//                 if let Some(label_sym) = label {
//                     let label_text = self.get_text(*label_sym);
//                     let sym = self.symbols.interner.get_or_internalize(&label_text);

//                     if self.symbols.lookup(self.current_scope, sym).is_some() {
//                         self.errors.push(SemanticError {
//                             kind: SemanticErrorKind::DuplicateDeclaration,
//                             span: self.span(stmt_id),
//                         });
//                     } else {
//                         self.symbols.define(
//                             self.current_scope,
//                             sym,
//                             DeclRef::Instance { name: sym },
//                         );
//                     }
//                 }

//                 let decl_ref = self.resolve_instantiated_target(*component_name);

//                 let target_ports = match decl_ref {
//                     Some(DeclRef::Component { id }) => {
//                         if let Decl::Component {
//                             ports_start,
//                             ports_end,
//                             ..
//                         } = &self.ast.decls[id.0 as usize]
//                         {
//                             &self.ast.ports[ports_start.0 as usize..ports_end.0 as usize]
//                         } else {
//                             unreachable!("DeclRef::Component must point to Decl::Component");
//                         }
//                     }
//                     Some(DeclRef::Entity { entity_id, .. }) => {
//                         let entity = &self.ast.entities[entity_id.0 as usize];
//                         &self.ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize]
//                     }
//                     _ => {
//                         self.errors.push(SemanticError {
//                             kind: SemanticErrorKind::UndefinedSymbol,
//                             span: *component_name,
//                         });
//                         return;
//                     }
//                 };

//                 let port_associations: &[Association] =
//                     &self.ast.associations[port_map.start as usize..port_map.end as usize];

//                 for (idx, assoc_expr) in port_associations.iter().enumerate() {
//                     // Named (formal => actual) vs Positional (actual)
//                     let formal_port = match assoc_expr.formal {
//                         Some(formal_id) => {
//                             // Named association: look up formal name in target_ports
//                             if let Expr::Identifier { span } = &self.ast.exprs[formal_id.0 as usize]
//                             {
//                                 target_ports.iter().find(|p| p.name == *span)
//                             } else {
//                                 None
//                             }
//                         }
//                         None => {
//                             // Positional association: map directly by declaration index
//                             target_ports.get(idx)
//                         }
//                     };

//                     let formal_port = match formal_port {
//                         Some(p) => p,
//                         None => {
//                             let err = match assoc_expr.formal {
//                                 Some(formal_expr_id) => {
//                                     let formal_expr = &self.ast.expr(formal_expr_id);

//                                     match formal_expr {
//                                         // Formal was an identifier, but no matching port exists on the target entity
//                                         Expr::Identifier { span } => SemanticError {
//                                             kind: SemanticErrorKind::UndefinedSymbol,
//                                             span: *span,
//                                         },
//                                         // Formal was an invalid expression construct
//                                         _ => SemanticError {
//                                             kind: SemanticErrorKind::PortAssocMustBeIdent,
//                                             span: formal_expr.span(),
//                                         },
//                                     }
//                                 }
//                                 // Positional port mapping provided more arguments than ports declared in the entity
//                                 None => SemanticError {
//                                     kind: SemanticErrorKind::PositionalPortAssociationOutOfBounds,
//                                     span: Span::from(port_map),
//                                 },
//                             };

//                             self.errors.push(err);
//                             continue;
//                         }
//                     };

//                     let formal_type = match self.infer_expr_type(formal_port.port_type, None) {
//                         Ok(t) => t,
//                         Err(err) => {
//                             self.errors.push(err);
//                             TypeId::ERROR
//                         }
//                     };
//                     let actual_expr_id = assoc_expr.actual;

//                     match self.infer_expr_type(actual_expr_id, Some(formal_type)) {
//                         Ok(actual_type) => {
//                             if actual_type != formal_type && actual_type != TypeId::ERROR {
//                                 self.errors.push(SemanticError {
//                                     kind: SemanticErrorKind::AssignmentTypeMismatch {
//                                         expected: formal_type,
//                                         found: actual_type,
//                                     },
//                                     span: self.ast.exprs[actual_expr_id.0 as usize].span(),
//                                 });
//                             }
//                         }
//                         Err(err) => self.errors.push(err),
//                     }

//                     // Direction Guard: Output/InOut formal ports cannot drive read-only local input ports
//                     if matches!(
//                         formal_port.mode,
//                         PortMode::Out | PortMode::InOut | PortMode::Buffer
//                     ) {
//                         if let Expr::Identifier { span } =
//                             &self.ast.exprs[actual_expr_id.0 as usize]
//                         {
//                             if let Some(sym) =
//                                 self.symbols.interner.get_symbol(self.get_text(*span))
//                             {
//                                 if let Some(DeclRef::Port {
//                                     mode: PortMode::In, ..
//                                 }) = self.symbols.lookup(self.current_scope, sym)
//                                 {
//                                     self.errors.push(SemanticError {
//                                         kind: SemanticErrorKind::WriteToInputPort,
//                                         span: *span,
//                                     });
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }
//             a => todo!("{:?}", a),
//         }
//     }
//     /// Resolves direct entity instantiations (`work.gate`), bare entity names (`gate`),
//     /// or explicit component declarations in scope.
//     fn resolve_instantiated_target(&self, name: ExprId) -> Option<DeclRef> {
//         let expr = self.ast.expr(name);
//         match expr {
            
//         }

//         let clean_name = if let Some(stripped) = raw_name.strip_prefix("work.") {
//             stripped
//         } else if let Some(stripped) = raw_name.strip_prefix("WORK.") {
//             stripped
//         } else {
//             raw_name
//         };

//         if let Some(sym_id) = self.symbols.interner.get_symbol(clean_name) {
//             if let Some(decl) = self.symbols.lookup(self.current_scope, sym_id) {
//                 return Some(decl);
//             }
//         }

//         // Fallback: Search globally
//         self.ast
//             .entities
//             .iter()
//             .enumerate()
//             .find(|(_, entity)| self.get_text(entity.name).eq_ignore_ascii_case(clean_name))
//             .map(|(idx, _)| DeclRef::Entity {
//                 entity_id: EntityId(idx as u32),
//                 scope_id: ScopeId(0),
//             })
//     }

//     fn check_boolean_condition(&mut self, condition: ExprId) {
//         let cond_type_res = self.infer_expr_type(condition, Some(self.type_boolean));

//         match cond_type_res {
//             Ok(cond_type) => {
//                 if cond_type != self.type_boolean {
//                     let span = self.ast.exprs[condition.0 as usize].span();
//                     self.errors.push(SemanticError {
//                         kind: SemanticErrorKind::ConditionNotBoolean { found: cond_type },
//                         span,
//                     });
//                 }
//             }
//             Err(err) => {
//                 self.errors.push(SemanticError {
//                     kind: err.kind,
//                     span: err.span,
//                 });
//             }
//         }
//     }

//     fn check_sequential_stmt(&mut self, stmt: &SequentialStmt) {
//         match stmt {
//             SequentialStmt::SequentialAssignment {
//                 target,
//                 expression,
//                 after,
//             } => {
//                 // Signal assignment `<=`
//                 self.check_assignment_semantics(*target, *expression, true);
//             }
//             SequentialStmt::VariableAssignment { target, expression } => {
//                 // Variable assignment `:=`
//                 self.check_assignment_semantics(*target, *expression, false);
//             }
//             SequentialStmt::If {
//                 then_stmts,
//                 elsif_stmts,
//                 else_stmts,
//                 condition,
//             } => {
//                 // Check IF condition
//                 self.check_boolean_condition(*condition);
//                 // Check THEN block
//                 self.check_sequential_stmt_list(then_stmts);
//                 // Check ELSIF blocks
//                 for elsif in &self.ast.elsifs[elsif_stmts.start as usize..elsif_stmts.end as usize]
//                 {
//                     self.check_boolean_condition(elsif.condition);
//                     self.check_sequential_stmt_list(&elsif.stmts);
//                 }
//                 // Check ELSE block
//                 if !else_stmts.is_empty() {
//                     self.check_sequential_stmt_list(else_stmts);
//                 }
//             }
//             SequentialStmt::Case { .. } => todo!(),
//             SequentialStmt::Loop { .. } => todo!(),
//             SequentialStmt::ProcedureCall { .. } => todo!(),
//         }
//     }

//     fn check_sequential_stmt_list(&mut self, range: &std::ops::Range<u32>) {
//         let stmt_ids = &self.ast.seq_stmt_lists[range.start as usize..range.end as usize];
//         for id in stmt_ids {
//             self.check_sequential_stmt(&self.ast.sequential_stmts[id.0 as usize]);
//         }
//     }

//     fn check_assignment_semantics(
//         &mut self,
//         target_expr: ExprId,
//         rhs_expr: ExprId,
//         is_signal_assign: bool,
//     ) {
//         let target_type_res = self.infer_expr_type(target_expr, None);

//         let expected_rhs = target_type_res.as_ref().ok().copied();
//         let rhs_type_res = self.infer_expr_type(rhs_expr, expected_rhs);

//         if let (Ok(target_type), Ok(rhs_type)) = (target_type_res, rhs_type_res) {
//             if target_type != rhs_type {
//                 self.errors.push(SemanticError {
//                     kind: SemanticErrorKind::AssignmentTypeMismatch {
//                         expected: target_type,
//                         found: rhs_type,
//                     },
//                     span: self.ast.exprs[rhs_expr.0 as usize].span(),
//                 });
//             }
//         }

//         // Signal vs Variable invariants
//         if let Some(base_sym_decl) = self.get_base_declaration(target_expr) {
//             let target_span = self.ast.exprs[target_expr.0 as usize].span();

//             match (base_sym_decl, is_signal_assign) {
//                 (DeclRef::Variable { .. }, true) => {
//                     self.errors.push(SemanticError {
//                         kind: SemanticErrorKind::InvalidAssignmentKind {
//                             expected_signal: false,
//                         },
//                         span: target_span,
//                     });
//                 }
//                 (DeclRef::Signal { .. }, false) => {
//                     self.errors.push(SemanticError {
//                         kind: SemanticErrorKind::InvalidAssignmentKind {
//                             expected_signal: true,
//                         },
//                         span: target_span,
//                     });
//                 }
//                 (DeclRef::Port { mode, .. }, true) => {
//                     if mode == PortMode::In {
//                         self.errors.push(SemanticError {
//                             kind: SemanticErrorKind::WriteToInputPort,
//                             span: target_span,
//                         });
//                     }
//                 }
//                 (DeclRef::Constant { .. }, _) => {
//                     self.errors.push(SemanticError {
//                         kind: SemanticErrorKind::InvalidAssignmentKind {
//                             expected_signal: is_signal_assign,
//                         },
//                         span: target_span,
//                     });
//                 }
//                 _ => {} // Valid assignments
//             }
//         }
//     }

//     fn get_text(&self, name: SymbolId) -> &str {
//         self.symbols.interner.get(name)
//     }
// }
