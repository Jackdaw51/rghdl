use std::fmt::Display;

use crate::{
    analyzer::TypeKind,
    ast::ContextItem,
    elaborator::{
        ElaboratedConcurrentAssignment, ElaboratedDesign, ElaboratedProcess,
        ElaboratedSequentialStmt, EvaluatedExpr, EvaluatedValue, InstanceNode,
    },
    printer::ElaboratedFormatCtx,
};

impl<'a> Display for ElaboratedFormatCtx<'a, EvaluatedValue> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            EvaluatedValue::Integer(v) => write!(f, "{}", v),
            EvaluatedValue::Boolean(b) => write!(f, "{}", if *b { "true" } else { "false" }),
            EvaluatedValue::EnumLiteral(sym) => write!(f, "{}", self.sym(*sym)),
            EvaluatedValue::Vector(vec) => {
                write!(f, "(")?;
                for (i, val) in vec.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", self.child(val))?;
                }
                write!(f, ")")
            }
        }
    }
}

impl<'a> Display for ElaboratedFormatCtx<'a, EvaluatedExpr> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            EvaluatedExpr::Literal(val) => write!(f, "{}", self.child(val)),
            EvaluatedExpr::SignalRead(sig_id) => {
                let sig = &self.arena.signals[sig_id.0 as usize];
                write!(f, "{}", self.sym(sig.name))
            }
            EvaluatedExpr::BinaryOp { lhs, op, rhs } => {
                let lhs_expr = &self.arena.exprs[lhs.0 as usize];
                let rhs_expr = &self.arena.exprs[rhs.0 as usize];
                write!(
                    f,
                    "{} {:?} {}",
                    self.child(lhs_expr),
                    op,
                    self.child(rhs_expr)
                )
            }
        }
    }
}
impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedSequentialStmt> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        match self.item {
            ElaboratedSequentialStmt::SignalAssignment { target, value_expr } => {
                let target_sig = &self.arena.signals[target.0 as usize];
                let val_expr = &self.arena.exprs[value_expr.0 as usize];
                writeln!(
                    f,
                    "{} <= {};",
                    self.sym(target_sig.name),
                    self.child(val_expr)
                )
            }
            ElaboratedSequentialStmt::If {
                condition,
                then_branch,
                else_branch,
            } => {
                let cond_expr = &self.arena.exprs[condition.0 as usize];
                writeln!(f, "if {} then", self.child(cond_expr))?;

                for stmt in then_branch {
                    write!(f, "{}", self.child_indented(stmt))?;
                }

                if let Some(else_stmts) = else_branch {
                    writeln!(f, "{}else", self.pad())?;
                    for stmt in else_stmts {
                        write!(f, "{}", self.child_indented(stmt))?;
                    }
                }
                writeln!(f, "{}end if;", self.pad())
            }
            ElaboratedSequentialStmt::VariableAssignment {
                target_symbol,
                value_expr,
            } => todo!(),
        }
    }
}

impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedConcurrentAssignment> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let target_sig = &self.arena.signals[self.item.target_signal.0 as usize];
        let val_expr = &self.arena.exprs[self.item.value_expr.0 as usize];
        writeln!(
            f,
            "{}{} <= {};",
            self.pad(),
            self.sym(target_sig.name),
            self.child(val_expr)
        )
    }
}

impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedProcess> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}{} : process(", self.pad(), self.sym(self.item.label))?;

        for (i, sig_id) in self.item.sensitivity_list.iter().enumerate() {
            let sig = &self.arena.signals[sig_id.0 as usize];
            if i > 0 {
                write!(f, ", ")?;
            }
            write!(f, "{}", self.sym(sig.name))?;
        }
        writeln!(f, ")")?;

        writeln!(f, "{}begin", self.pad())?;
        for stmt in &self.item.body_stmts {
            write!(f, "{}", self.child_indented(stmt))?;
        }
        writeln!(f, "{}end process;", self.pad())
    }
}

impl<'a> Display for ElaboratedFormatCtx<'a, ElaboratedDesign> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.child(&self.item.top_instance))
    }
}

impl<'a> Display for ElaboratedFormatCtx<'a, InstanceNode> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let inst = self.item;

        for child_id in &inst.children {
            let child_node = &self.arena.instances[child_id.0 as usize];
            writeln!(f, "{}", self.child(child_node))?;
        }

        // let unique_entity_name = if inst.hierarchical_path == "top" {
        //     // Preserve exact top-level entity name for GHDL validation
        //     self.sa.symbols.interner.get(inst.entity_name).to_string()
        // } else {
        //     format!("{}_{}", self.sym(inst.entity_name), inst.instance_name.0)
        // };
        // let unique_entity_name = format!("{}_{}", self.sym(inst.entity_name), inst.instance_name.0);
        let unique_entity_name = format!("{}_flat", self.sym(inst.entity_name));

        if !self.sa.ast.contexts.is_empty() {
            for ctx in &self.sa.ast.contexts {
                match ctx {
                    ContextItem::Library { name } => writeln!(f, "library {};", name)?,
                    ContextItem::Use { path } => writeln!(f, "use {};", path)?,
                }
            }
        } else {
            // SHOULD be that they are always included
            writeln!(f, "library ieee;")?;
            writeln!(f, "use ieee.std_logic_1164.all;")?;
        }

        writeln!(f, "entity {} is", unique_entity_name)?;
        if !inst.ports.is_empty() {
            writeln!(f, "\tport (")?;
            for (i, port) in inst.ports.iter().enumerate() {
                let term = if i == inst.ports.len() - 1 { "" } else { ";" };
                // When got to this point should be safe to unwrap
                let a = self.sa.types.get(port.type_id).unwrap();
                writeln!(
                    f,
                    "\t\t{}: {:?} {}{}",
                    self.sym(port.name),
                    port.mode,
                    self.child(a),
                    term
                )?;
            }
            writeln!(f, "\t);")?;
        }
        writeln!(f, "end {};\n", unique_entity_name)?;

        writeln!(
            f,
            "architecture {} of {} is",
            self.sym(inst.architecture_name),
            unique_entity_name
        )?;

        for sig_id in &inst.local_signals {
            let sig = &self.arena.signals[sig_id.0 as usize];
            // TODO resolve the correct std_logic / vector string
            writeln!(
                f,
                "\tsignal {}: TYPE_{};",
                self.sym(sig.name),
                sig.type_id.0
            )?;
        }

        writeln!(f, "begin")?;

        for ca in &inst.concurrent_assignments {
            write!(f, "{}", self.child_indented(ca))?;
        }

        for proc_id in &inst.processes {
            let proc = &self.arena.processes[proc_id.0 as usize];
            write!(f, "{}", self.child_indented(proc))?;
        }

        for child_id in &inst.children {
            let child_node = &self.arena.instances[child_id.0 as usize];
            let child_unique_entity = format!(
                "{}_{}",
                self.sym(child_node.entity_name),
                child_node.instance_name.0
            );

            writeln!(
                f,
                "\t{} : entity work.{}",
                self.sym(child_node.instance_name),
                child_unique_entity
            )?;

            if !child_node.port_bindings.is_empty() {
                writeln!(f, "\t\tport map (")?;
                for (i, binding) in child_node.port_bindings.iter().enumerate() {
                    let actual_sig = &self.arena.signals[binding.actual_signal.0 as usize];
                    let term = if i == child_node.port_bindings.len() - 1 {
                        ""
                    } else {
                        ","
                    };
                    writeln!(
                        f,
                        "\t\t\t{} => {}{}",
                        self.sym(binding.port_name),
                        self.sym(actual_sig.name),
                        term
                    )?;
                }
                writeln!(f, "\t\t);")?;
            }
        }

        writeln!(f, "end {};\n", self.sym(inst.architecture_name))
    }
}
impl<'a> Display for ElaboratedFormatCtx<'a, TypeKind> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match &self.item {
            TypeKind::Enum { name, .. }
            | TypeKind::Integer { name }
            | TypeKind::Real { name }
            | TypeKind::Array { name, .. }
            | TypeKind::Record { name, .. }
            | TypeKind::Function { name, .. } => {
                write!(f, "{}", self.sym(*name))
            }
            TypeKind::Error => write!(f, "<error_type>"),
        }
    }
}
