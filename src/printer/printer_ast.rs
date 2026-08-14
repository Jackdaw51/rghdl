use std::fmt::Display;

use crate::ast::{
    AstArena, ConcurrentStmt, ContextItem, Decl, ElsifBranch, Entity, Expr, Port, SequentialStmt,
    UnaryOp,
};
use crate::printer::FormatCtx;

impl<'a> Display for FormatCtx<'a, AstArena<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let arena = self.item;

        for c in &arena.contexts {
            write!(f, "{}", self.child(c))?;
        }

        writeln!(f)?;

        for e in &arena.entities {
            write!(f, "{}", self.child_indented(e))?;
        }

        writeln!(f)?;
        for a in &arena.architectures {
            writeln!(
                f,
                "architecture {} of {} is",
                a.name,
                self.get_text(&a.entity_name)
            )?;
            for decls in &arena.decls[a.decls_start.0 as usize..a.decls_end.0 as usize] {
                write!(f, "{}", self.child_indented(decls))?;
            }

            writeln!(f, "begin")?;
            let conc_ids = &arena.conc_stmt_lists[a.stmts.start as usize..a.stmts.end as usize];
            for id in conc_ids {
                let stmt = &arena.concurrent_stmts[id.0 as usize];
                write!(f, "{}", self.child_indented(stmt))?;
            }

            write!(f, "end {};", a.name)?;
        }
        Ok(())
    }
}

impl<'a> Display for FormatCtx<'a, Expr<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            Expr::Literal { text, span } => write!(f, "{}", text),
            Expr::Identifier { name, span } => write!(f, "{}", name),
            Expr::Binary { op, lhs, rhs, span } => {
                write!(
                    f,
                    "{} {} {}",
                    self.child(self.get_expr(*lhs)),
                    op,
                    self.child(self.get_expr(*rhs))
                )
            }
            Expr::Unary { op, expr, span } => {
                let _ = write!(f, "{}", op);
                if matches!(op, UnaryOp::Abs | UnaryOp::Not) {
                    let _ = write!(f, " ");
                };
                write!(f, "{}", self.child(self.get_expr(*expr)))
            }
            Expr::Grouping { expr, span } => write!(f, "({})", self.child(self.get_expr(*expr))),
            Expr::CallOrIndex { callee, args, span } => write!(f, "{}", self.get_text(span)),
            Expr::Others { span } => todo!(),
            Expr::Aggregate { elements, span } => write!(f, "{}", self.get_text(span)),
            Expr::Slice {
                target,
                direction,
                left,
                right,
                span,
            } => todo!(),
            Expr::RecordAccess {
                target,
                field,
                span,
            } => todo!(),
        }
    }
}

impl<'a> Display for FormatCtx<'a, ConcurrentStmt<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        match self.item {
            ConcurrentStmt::ConcurrentAssignment {
                target,
                label,
                expression,
            } => writeln!(
                f,
                "{} <= {};",
                self.child(self.get_expr(*target)),
                self.child(self.get_expr(*expression))
            ),
            ConcurrentStmt::ConditionalAssignment { target } => todo!(),
            ConcurrentStmt::ComponentInstantiation {
                label,
                component_name,
                port_map_span,
            } => todo!(),
            ConcurrentStmt::Process {
                label,
                stmts,
                process_vars,
            } => {
                if let Some(x) = label {
                    write!(f, "{} : ", x)?;
                }
                write!(f, "process ")?;

                if let Some(x) = process_vars {
                    write!(f, "{}", x)?;
                }
                writeln!(f)?;
                writeln!(f, "{}begin", self.pad())?;
                let seq_ids = &self.arena.seq_stmt_lists[stmts.start as usize..stmts.end as usize];
                for id in seq_ids {
                    let stmt = &self.arena.sequential_stmts[id.0 as usize];
                    write!(f, "{}", self.child_indented(stmt))?;
                }
                writeln!(f, "{}end process;", self.pad())?;
                Ok(())
            }
        }
    }
}

impl<'a> Display for FormatCtx<'a, SequentialStmt<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        match self.item {
            SequentialStmt::SequentialAssignment { target, expression } => write!(
                f,
                "{} <= {};",
                self.child(self.get_expr(*target)),
                self.child(self.get_expr(*expression))
            ),
            SequentialStmt::VariableAssignment { target, expression } => write!(
                f,
                "{} <= {};",
                self.child(self.get_expr(*target)),
                self.child(self.get_expr(*expression))
            ),
            SequentialStmt::If {
                condition,
                then_stmts,
                else_stmts,
                elsif_stmts,
            } => {
                writeln!(f, "if {} then", self.child(self.get_expr(*condition)))?;

                let then_ids =
                    &self.arena.seq_stmt_lists[then_stmts.start as usize..then_stmts.end as usize];
                for id in then_ids {
                    let stmt = &self.arena.sequential_stmts[id.0 as usize];
                    writeln!(f, "{}", self.child_indented(stmt))?;
                }

                for elsif in
                    &self.arena.elsifs[elsif_stmts.start as usize..elsif_stmts.end as usize]
                {
                    write!(f, "{}", self.child(elsif))?;
                }

                if !else_stmts.is_empty() {
                    write!(f, "{}", self.pad())?;
                    writeln!(f, "else")?;
                    let else_ids = &self.arena.seq_stmt_lists
                        [else_stmts.start as usize..else_stmts.end as usize];
                    for id in else_ids {
                        let stmt = &self.arena.sequential_stmts[id.0 as usize];
                        writeln!(f, "{}", self.child_indented(stmt))?;
                    }
                }
                writeln!(f)?;
                writeln!(f, "{}end if;", self.pad())?;
                Ok(())
            }
            SequentialStmt::Case {
                expression_span,
                cases_span,
            } => todo!(),
            SequentialStmt::Loop {
                label,
                loop_scheme_span,
                stmts,
            } => todo!(),
            SequentialStmt::ProcedureCall { call } => todo!(),
        }
    }
}

impl<'a> Display for FormatCtx<'a, ElsifBranch> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        let a = self.item;
        writeln!(f, "elsif {} then", self.child(self.get_expr(*&a.condition)))?;
        let stmt_ids = &self.arena.seq_stmt_lists[a.stmts.start as usize..a.stmts.end as usize];
        for id in stmt_ids {
            let stmt = &self.arena.sequential_stmts[id.0 as usize];
            write!(f, "{}", self.child_indented(stmt))?;
        }
        Ok(())
    }
}
impl<'a> Display for FormatCtx<'a, Decl<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        match self.item {
            Decl::Signal {
                name,
                decl_type,
                default_val,
            } => {
                write!(f, "signal {} : {}", name, decl_type)?;
                if let Some(x) = default_val {
                    write!(f, " := {}", self.child(self.get_expr(*x)))?;
                }
                writeln!(f, ";")
            }
            Decl::Constant {
                name,
                decl_type,
                default_val,
            } => {
                write!(f, "constant {} : {}", name, decl_type)?;
                if let Some(x) = default_val {
                    write!(f, " := {}", self.child(self.get_expr(*x)))?;
                }
                writeln!(f, ";")
            }
            Decl::Variable {
                name,
                decl_type,
                default_val,
            } => {
                write!(f, "variable {} : {}", name, decl_type)?;
                if let Some(x) = default_val {
                    write!(f, " := {}", self.child(self.get_expr(*x)))?;
                }
                writeln!(f, ";")
            }
            Decl::Component {
                name: _,
                ports_start: _,
                ports_end: _,
            } => Err(std::fmt::Error),
        }
    }
}
impl<'a> Display for FormatCtx<'a, ContextItem<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            ContextItem::Library { name } => writeln!(f, "library {};", name),
            ContextItem::Use { path } => writeln!(f, "use {};", path),
        }
    }
}
impl<'a> Display for FormatCtx<'a, Port<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let p = self.item;
        write!(f, "{}{}: {:?} {}", self.pad(), p.name, p.mode, p.port_type)
    }
}
impl<'a> Display for FormatCtx<'a, Entity<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let arena = self.arena;
        let entity = self.item;
        writeln!(f, "entity {} is", self.item.name)?;
        writeln!(f, "\tport (")?;
        let ids = &arena.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];
        for ports in ids {
            write!(f, "{}", self.child_indented(ports))?;
            if ids.last().unwrap() != ports {
                write!(f, ";")?;
            }
            writeln!(f)?;
        }
        writeln!(f, "\t);")?;
        writeln!(f, "end {};", entity.name)?;
        Ok(())
    }
}
