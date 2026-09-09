// use std::fmt::Write;
// use std::{
//     collections::HashSet,
//     fmt::{self, Display},
// };

// use crate::analyzer::SymbolId;
// use crate::{
//     analyzer::{SemanticAnalyzer, TypeKind},
//     ast::{ContextItem, PortMode, UnaryOp},
//     elaborator::{
//         ElaboratedArena, ElaboratedConcurrentAssignment, ElaboratedDesign, ElaboratedProcess,
//         ElaboratedSequentialStmt, EvaluatedExpr, EvaluatedValue, InstanceId, InstanceNode,
//     },
//     printer::{ElaboratedFormatCtx, VhdlEmitter},
// };

// impl<'a> Display for ElaboratedFormatCtx<'a, EvaluatedValue> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         match self.item {
//             EvaluatedValue::Integer(v) => write!(f, "{}", v),
//             EvaluatedValue::Boolean(b) => write!(f, "{}", if *b { "true" } else { "false" }),
//             EvaluatedValue::EnumLiteral(sym) => write!(f, "{}", self.sym(*sym)),
//             EvaluatedValue::Vector(vec) => {
//                 write!(f, "(")?;
//                 for (i, val) in vec.iter().enumerate() {
//                     if i > 0 {
//                         write!(f, ", ")?;
//                     }
//                     write!(f, "{}", self.child(val))?;
//                 }
//                 write!(f, ")")
//             }
//         }
//     }
// }

// impl<'a> Display for ElaboratedFormatCtx<'a, EvaluatedExpr> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         match self.item {
//             EvaluatedExpr::Literal(val) => write!(f, "{}", self.child(val)),
//             EvaluatedExpr::SignalRead(sig_id) => {
//                 let sig = &self.arena.signals[sig_id.0 as usize];
//                 write!(f, "{}", self.sym(sig.name))
//             }
//             EvaluatedExpr::BinaryOp { lhs, op, rhs } => {
//                 let lhs_expr = &self.arena.exprs[lhs.0 as usize];
//                 let rhs_expr = &self.arena.exprs[rhs.0 as usize];
//                 write!(
//                     f,
//                     "{} {:?} {}",
//                     self.child(lhs_expr),
//                     op,
//                     self.child(rhs_expr)
//                 )
//             }
//             EvaluatedExpr::UnaryOp { op, expr } => {
//                 let op_str = match op {
//                     UnaryOp::Not => "not ",
//                     UnaryOp::Neg => "-",
//                     UnaryOp::Plus => "+",
//                     UnaryOp::Abs => "abs ",
//                 };
//                 let inner_expr = &self.arena.exprs[expr.0 as usize];
//                 // Wrap binary operations in parentheses when target of a unary operator
//                 match inner_expr {
//                     EvaluatedExpr::BinaryOp { .. } => {
//                         write!(f, "{} ({})", op_str, self.child(inner_expr))
//                     }
//                     _ => write!(f, "{} {}", op_str, self.child(inner_expr)),
//                 }
//             }
//         }
//     }
// }
// impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedSequentialStmt> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         write!(f, "{}", self.pad())?;
//         match self.item {
//             ElaboratedSequentialStmt::SignalAssignment { target, value_expr } => {
//                 let target_sig = &self.arena.signals[target.0 as usize];
//                 let val_expr = &self.arena.exprs[value_expr.0 as usize];
//                 writeln!(
//                     f,
//                     "{} <= {};",
//                     self.sym(target_sig.name),
//                     self.child(val_expr)
//                 )
//             }
//             ElaboratedSequentialStmt::If {
//                 condition,
//                 then_branch,
//                 else_branch,
//             } => {
//                 let cond_expr = &self.arena.exprs[condition.0 as usize];
//                 writeln!(f, "if {} then", self.child(cond_expr))?;

//                 for stmt in then_branch {
//                     write!(f, "{}", self.child_indented(stmt))?;
//                 }

//                 if let Some(else_stmts) = else_branch {
//                     writeln!(f, "{}else", self.pad())?;
//                     for stmt in else_stmts {
//                         write!(f, "{}", self.child_indented(stmt))?;
//                     }
//                 }
//                 writeln!(f, "{}end if;", self.pad())
//             }
//             ElaboratedSequentialStmt::VariableAssignment {
//                 target_symbol,
//                 value_expr,
//             } => todo!(),
//         }
//     }
// }

// impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedConcurrentAssignment> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         let target_sig = &self.arena.signals[self.item.target_signal.0 as usize];
//         let val_expr = &self.arena.exprs[self.item.value_expr.0 as usize];
//         dbg!(val_expr, self.item.value_expr);
//         if let Some(delay_id) = self.item.delay_expr {
//             let delay_expr = &self.arena.exprs[delay_id.0 as usize];
//             writeln!(
//                 f,
//                 "{}{} <= {} after {} fs;",
//                 self.pad(),
//                 self.sym(target_sig.name),
//                 self.child(val_expr),
//                 self.child(delay_expr)
//             )
//         } else {
//             writeln!(
//                 f,
//                 "{}{} <= {};",
//                 self.pad(),
//                 self.sym(target_sig.name),
//                 self.child(val_expr)
//             )
//         }
//     }
// }

// impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedProcess> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         write!(f, "{}{} : process(", self.pad(), self.sym(self.item.label))?;

//         for (i, sig_id) in self.item.sensitivity_list.iter().enumerate() {
//             let sig = &self.arena.signals[sig_id.0 as usize];
//             if i > 0 {
//                 write!(f, ", ")?;
//             }
//             write!(f, "{}", self.sym(sig.name))?;
//         }
//         writeln!(f, ")")?;

//         writeln!(f, "{}begin", self.pad())?;
//         for stmt in &self.item.body_stmts {
//             write!(f, "{}", self.child_indented(stmt))?;
//         }
//         writeln!(f, "{}end process;", self.pad())
//     }
// }

// impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedDesign> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         for i in &self.item.instances {
//             write!(f, "{}", self.child(&self.arena.instances[i.0 as usize]))?;
//         }
//         Ok(())
//     }
// }

// pub struct ElaboratedEntityCtx<'a> {
//     pub inst: &'a InstanceNode,
//     pub arena: &'a ElaboratedArena,
//     pub sa: &'a SemanticAnalyzer<'a>,
// }

// pub struct ElaboratedArchCtx<'a> {
//     pub inst: &'a InstanceNode,
//     pub arena: &'a ElaboratedArena,
//     pub sa: &'a SemanticAnalyzer<'a>,
//     pub indent: usize,
// }

// impl<'a> Display for ElaboratedEntityCtx<'a> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         let inst = self.inst;
//         let unique_entity_name = format!("{}_flat", self.sa.symbols.interner.get(inst.entity_name));

//         if !self.sa.ast.contexts.is_empty() {
//             for ctx in &self.sa.ast.contexts {
//                 match ctx {
//                     ContextItem::Library { name } => writeln!(f, "library {};", name)?,
//                     ContextItem::Use { path } => writeln!(f, "use {};", path)?,
//                 }
//             }
//         } else {
//             writeln!(f, "library ieee;")?;
//             writeln!(f, "use ieee.std_logic_1164.all;")?;
//         }

//         writeln!(f, "entity {} is", unique_entity_name)?;
//         if !inst.generics.is_empty() {
//             writeln!(f, "\tgeneric (")?;
//             let len = inst.generics.len();
//             for (i, (name, val)) in inst.generics.iter().enumerate() {
//                 let term = if i == len - 1 { "" } else { ";" };
//                 writeln!(
//                     f,
//                     "\t\t{} : integer := {}{}",
//                     self.sa.symbols.interner.get(*name),
//                     val.to_vhdl_string(&self.sa.symbols.interner),
//                     term
//                 )?;
//             }
//             writeln!(f, "\t);")?;
//         }
//         if !inst.ports.is_empty() {
//             writeln!(f, "\tport (")?;
//             for (i, port) in inst.ports.iter().enumerate() {
//                 let term = if i == inst.ports.len() - 1 { "" } else { ";" };
//                 let type_kind = self.sa.types.get(port.type_id).unwrap();
//                 let fm = ElaboratedFormatCtx {
//                     item: type_kind,
//                     arena: self.arena,
//                     sa: self.sa,
//                     indent: 0,
//                 };
//                 writeln!(
//                     f,
//                     "\t\t{}: {} {}{}",
//                     self.sa.symbols.interner.get(port.name),
//                     port.mode,
//                     fm,
//                     term
//                 )?;
//             }
//             writeln!(f, "\t);")?;
//         }
//         writeln!(f, "end {};\n", unique_entity_name)
//     }
// }

// impl<'a> Display for ElaboratedArchCtx<'a> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         let inst = self.inst;
//         let unique_entity_name = format!("{}_flat", self.sa.symbols.interner.get(inst.entity_name));
//         let arch_name = self.sa.symbols.interner.get(inst.architecture_name);

//         writeln!(f, "architecture {} of {} is", arch_name, unique_entity_name)?;

//         for sig_id in &inst.local_signals {
//             let sig = &self.arena.signals[sig_id.0 as usize];
//             let type_kind = self.sa.types.get(sig.type_id).unwrap();
//             let fm = ElaboratedFormatCtx {
//                 item: type_kind,
//                 arena: self.arena,
//                 sa: self.sa,
//                 indent: 0,
//             };
//             writeln!(
//                 f,
//                 "\tsignal {}: {};",
//                 self.sa.symbols.interner.get(sig.name),
//                 fm
//             )?;
//         }

//         writeln!(f, "begin")?;

//         for ca in &inst.concurrent_assignments {
//             let fm = ElaboratedFormatCtx {
//                 item: ca,
//                 arena: self.arena,
//                 sa: self.sa,
//                 indent: 1,
//             };
//             write!(f, "{}", fm)?;
//         }

//         for proc_id in &inst.processes {
//             let proc = &self.arena.processes[proc_id.0 as usize];
//             let fm = ElaboratedFormatCtx {
//                 item: proc,
//                 arena: self.arena,
//                 sa: self.sa,
//                 indent: 1,
//             };
//             write!(f, "{}", fm)?;
//         }

//         for child_id in &inst.children {
//             let child_node = &self.arena.instances[child_id.0 as usize];
//             let child_unique_entity = format!(
//                 "{}_flat",
//                 self.sa.symbols.interner.get(child_node.entity_name)
//             );

//             writeln!(
//                 f,
//                 "\t{} : entity work.{}",
//                 self.sa.symbols.interner.get(child_node.instance_name),
//                 child_unique_entity
//             )?;

//             if !child_node.port_bindings.is_empty() {
//                 writeln!(f, "\t\tport map (")?;
//                 for (i, binding) in child_node.port_bindings.iter().enumerate() {
//                     let actual_sig = &self.arena.signals[binding.actual_signal.0 as usize];
//                     let term = if i == child_node.port_bindings.len() - 1 {
//                         ""
//                     } else {
//                         ","
//                     };
//                     writeln!(
//                         f,
//                         "\t\t\t{} => {}{}",
//                         self.sa.symbols.interner.get(binding.port_name),
//                         self.sa.symbols.interner.get(actual_sig.name),
//                         term
//                     )?;
//                 }
//                 writeln!(f, "\t\t);")?;
//             }
//         }

//         writeln!(f, "end {};\n", arch_name)
//     }
// }

// impl<'a> Display for ElaboratedFormatCtx<'a, InstanceNode> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         let inst = self.item;

//         // for child_id in &inst.children {
//         //     let child_node = &self.arena.instances[child_id.0 as usize];
//         //     writeln!(f, "{}", self.child(child_node))?;
//         // }

//         // let unique_entity_name = if inst.hierarchical_path == "top" {
//         //     // Preserve exact top-level entity name for GHDL validation
//         //     self.sa.symbols.interner.get(inst.entity_name).to_string()
//         // } else {
//         //     format!("{}_{}", self.sym(inst.entity_name), inst.instance_name.0)
//         // };
//         // let unique_entity_name = format!("{}_{}", self.sym(inst.entity_name), inst.instance_name.0);
//         let unique_entity_name = format!("{}_flat", self.sym(inst.entity_name));

//         if !self.sa.ast.contexts.is_empty() {
//             for ctx in &self.sa.ast.contexts {
//                 match ctx {
//                     ContextItem::Library { name } => writeln!(f, "library {};", name)?,
//                     ContextItem::Use { path } => writeln!(f, "use {};", path)?,
//                 }
//             }
//         } else {
//             // SHOULD be that they are always included
//             writeln!(f, "library ieee;")?;
//             writeln!(f, "use ieee.std_logic_1164.all;")?;
//         }

//         writeln!(f, "entity {} is", unique_entity_name)?;
//         if !inst.generics.is_empty() {
//             writeln!(f, "\tgeneric (")?;
//             let len = inst.generics.len();
//             for (i, (name, val)) in inst.generics.iter().enumerate() {
//                 let term = if i == len - 1 { "" } else { ";" };
//                 // Generics omit mode (in/out) and append the resolved assignment (:= value)
//                 writeln!(
//                     f,
//                     "\t\t{} : integer := {}{}",
//                     self.sym(*name),
//                     val.to_vhdl_string(&self.sa.symbols.interner),
//                     term
//                 )?;
//             }
//             writeln!(f, "\t);")?;
//         }
//         if !inst.ports.is_empty() {
//             writeln!(f, "\tport (")?;
//             for (i, port) in inst.ports.iter().enumerate() {
//                 let term = if i == inst.ports.len() - 1 { "" } else { ";" };
//                 // When got to this point should be safe to unwrap
//                 let a = self.sa.types.get(port.type_id).unwrap();
//                 writeln!(
//                     f,
//                     "\t\t{}: {:?} {}{}",
//                     self.sym(port.name),
//                     port.mode,
//                     self.child(a),
//                     term
//                 )?;
//             }
//             writeln!(f, "\t);")?;
//         }
//         writeln!(f, "end {};\n", unique_entity_name)?;

//         writeln!(
//             f,
//             "architecture {} of {} is",
//             self.sym(inst.architecture_name),
//             unique_entity_name
//         )?;

//         for sig_id in &inst.local_signals {
//             let sig = &self.arena.signals[sig_id.0 as usize];
//             writeln!(
//                 f,
//                 "\tsignal {}: {};",
//                 self.sym(sig.name),
//                 self.child(self.sa.types.get(sig.type_id).unwrap())
//             )?;
//         }

//         writeln!(f, "begin")?;

//         for ca in &inst.concurrent_assignments {
//             write!(f, "{}", self.child_indented(ca))?;
//         }

//         for proc_id in &inst.processes {
//             let proc = &self.arena.processes[proc_id.0 as usize];
//             write!(f, "{}", self.child_indented(proc))?;
//         }

//         for child_id in &inst.children {
//             let child_node = &self.arena.instances[child_id.0 as usize];
//             let child_unique_entity = format!(
//                 "{}_{}",
//                 self.sym(child_node.entity_name),
//                 // child_node.instance_name.0
//                 "flat"
//             );

//             writeln!(
//                 f,
//                 "\t{} : entity work.{}",
//                 self.sym(child_node.instance_name),
//                 child_unique_entity
//             )?;

//             if !child_node.port_bindings.is_empty() {
//                 writeln!(f, "\t\tport map (")?;
//                 for (i, binding) in child_node.port_bindings.iter().enumerate() {
//                     let actual_sig = &self.arena.signals[binding.actual_signal.0 as usize];
//                     let term = if i == child_node.port_bindings.len() - 1 {
//                         ""
//                     } else {
//                         ","
//                     };
//                     writeln!(
//                         f,
//                         "\t\t\t{} => {}{}",
//                         self.sym(binding.port_name),
//                         self.sym(actual_sig.name),
//                         term
//                     )?;
//                 }
//                 writeln!(f, "\t\t);")?;
//             }
//         }

//         writeln!(f, "end {};\n", self.sym(inst.architecture_name))
//     }
// }
// impl<'a> Display for ElaboratedFormatCtx<'a, TypeKind> {
//     fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
//         match &self.item {
//             TypeKind::Enum { name, .. }
//             | TypeKind::Integer { name }
//             | TypeKind::Real { name }
//             | TypeKind::Array { name, .. }
//             | TypeKind::Record { name, .. }
//             | TypeKind::Function { name, .. }
//             | TypeKind::Physical { name, .. } => {
//                 write!(f, "{}", self.sym(*name))
//             }
//             TypeKind::Error => write!(f, "<error_type>"),
//         }
//     }
// }

// impl fmt::Display for PortMode {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         match self {
//             PortMode::In => write!(f, "in"),
//             PortMode::Out => write!(f, "out"),
//             PortMode::InOut => write!(f, "inout"),
//             PortMode::Buffer => write!(f, "buffer"),
//         }
//     }
// }

// impl<'a> VhdlEmitter<'a> {
//     pub fn new(sa: &'a SemanticAnalyzer<'a>, arena: &'a ElaboratedArena) -> Self {
//         Self {
//             sa,
//             arena,
//             emitted_entities: HashSet::new(),
//             emitted_architectures: HashSet::new(),
//         }
//     }

//     pub fn emit_design(&mut self, top: &ElaboratedDesign) -> Result<String, std::fmt::Error> {
//         let mut out = String::new();

//         for i in &top.instances {
//             let inst = &self.arena.instances[i.0 as usize];

//             if self.emitted_entities.insert(inst.entity_name) {
//                 let fm = ElaboratedEntityCtx {
//                     inst,
//                     arena: self.arena,
//                     sa: self.sa,
//                 };
//                 write!(out, "{}", fm)?;
//             }

//             if self
//                 .emitted_architectures
//                 .insert((inst.entity_name, inst.architecture_name))
//             {
//                 let fm = ElaboratedArchCtx {
//                     inst,
//                     arena: self.arena,
//                     sa: self.sa,
//                     indent: 0,
//                 };
//                 write!(out, "{}", fm)?;
//             }
//         }

//         Ok(out)
//     }
// }
