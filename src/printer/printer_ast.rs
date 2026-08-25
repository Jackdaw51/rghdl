use std::fmt::Display;
use std::ops::Range;

use crate::analyzer::{SemanticError, SemanticErrorKind};
use crate::ast::{
    AstArena, ConcurrentStmt, ContextItem, Decl, ElsifBranch, Entity, Expr, Port, PortId,
    SequentialStmt, UnaryOp,
};
use crate::parser::ParseError;
use crate::printer::FormatCtx;

impl<'a> Display for FormatCtx<'a, ParseError> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item.kind {
            crate::parser::ParseErrorKind::ExpectedToken { expected, found } => {
                write!(f, "Expected '{expected}', found '{found}'")
            }
            crate::parser::ParseErrorKind::ExpectedTokens { expected, found } => {
                let valid_tokens: Vec<_> = expected
                    .iter()
                    .filter_map(|t| *t)
                    .map(|t| format!("'{t}'"))
                    .collect();
                write!(
                    f,
                    "Expected one of {}, found {found}",
                    valid_tokens.join(", ")
                )
            }
            crate::parser::ParseErrorKind::NameMismatch {
                expected_span,
                found_span,
            } => write!(
                f,
                "Name mismatch: expected {}, found {} on line {}",
                self.get_text(expected_span),
                self.get_text(found_span),
                self.get_line_from_span(found_span)
            ),
            crate::parser::ParseErrorKind::UnexpectedEof => {
                write!(f, "Unexpected end of file")
            }
        }
    }
}

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
                self.get_text(a.entity_name)
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
            Expr::Literal { text, span: _ } => write!(f, "{}", text),
            Expr::Identifier { span, .. } => write!(f, "{}", self.get_text(*span)),
            Expr::Binary {
                op,
                lhs,
                rhs,
                span: _,
            } => {
                write!(
                    f,
                    "{} {} {}",
                    self.child(self.get_expr(*lhs)),
                    op,
                    self.child(self.get_expr(*rhs))
                )
            }
            Expr::Unary { op, expr, span: _ } => {
                let _ = write!(f, "{}", op);
                if matches!(op, UnaryOp::Abs | UnaryOp::Not) {
                    let _ = write!(f, " ");
                };
                write!(f, "{}", self.child(self.get_expr(*expr)))
            }
            Expr::Grouping { expr, span: _ } => {
                write!(f, "({})", self.child(self.get_expr(*expr)))
            }
            Expr::CallOrIndex {
                callee: _,
                args: _,
                span,
            } => {
                write!(f, "{}", self.get_text(*span))
            }
            Expr::Others { span: _ } => write!(f, "others"),
            Expr::Aggregate { elements: _, span } => write!(f, "{}", self.get_text(*span)),
            Expr::Slice {
                target,
                direction,
                left,
                right,
                span: _,
            } => write!(
                f,
                "{}({} {} {})",
                self.child(self.get_expr(*target)),
                self.child(self.get_expr(*left)),
                direction,
                self.child(self.get_expr(*right))
            ),
            Expr::RecordAccess {
                target,
                field,
                span: _,
            } => write!(f, "{}.{}", self.child(self.get_expr(*target)), field),
            Expr::PhysicalLiteral { value, unit, span } => todo!(),
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
                after,
            } => {
                if let Some(lbl_span) = label {
                    write!(f, "{}: ", self.get_text(*lbl_span))?;
                }
                writeln!(
                    f,
                    "{} <= {};",
                    self.child(self.get_expr(*target)),
                    self.child(self.get_expr(*expression))
                )
            }
            ConcurrentStmt::ConditionalAssignment { target } => {
                writeln!(f, "{} <= ...;", target)
            }
            ConcurrentStmt::ComponentInstantiation {
                label,
                component_name,
                arch_qualifier,
                generic_map,
                port_map,
            } => {
                if let Some(lbl) = label {
                    write!(f, "{}: ", self.get_text(*lbl))?;
                }

                write!(f, "{}", self.get_text(*component_name))?;

                if let Some(arch) = arch_qualifier {
                    write!(f, "({})", self.get_text(*arch))?;
                }

                if !generic_map.is_empty() {
                    write!(f, " generic map ")?;
                    self.fmt_association_list(f, generic_map.clone())?;
                }

                dbg!(port_map);
                self.fmt_association_list(f, port_map.clone())?;

                writeln!(f, ";")
            }
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
            SequentialStmt::SequentialAssignment { target, expression, after } => writeln!(
                f,
                "{} <= {};",
                self.child(self.get_expr(*target)),
                self.child(self.get_expr(*expression))
            ),
            SequentialStmt::VariableAssignment { target, expression } => writeln!(
                f,
                "{} := {};",
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
                    write!(f, "{}", self.child_indented(stmt))?;
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
                        write!(f, "{}", self.child_indented(stmt))?;
                    }
                }
                writeln!(f, "{}end if;", self.pad())
            }
            SequentialStmt::Case {
                expression_span,
                cases_span,
            } => writeln!(
                f,
                "case {} is {}; end case;",
                self.get_text(*expression_span),
                self.get_text(*cases_span)
            ),
            SequentialStmt::Loop {
                label,
                loop_scheme_span,
                stmts,
            } => {
                if let Some(lbl) = label {
                    write!(f, "{}: ", lbl)?;
                }
                writeln!(f, "{} loop", self.get_text(*loop_scheme_span))?;
                let seq_ids = &self.arena.seq_stmt_lists[stmts.start as usize..stmts.end as usize];
                for id in seq_ids {
                    let stmt = &self.arena.sequential_stmts[id.0 as usize];
                    write!(f, "{}", self.child_indented(stmt))?;
                }
                writeln!(f, "{}end loop;", self.pad())
            }
            SequentialStmt::ProcedureCall { call } => {
                writeln!(f, "{};", self.child(self.get_expr(*call)))
            }
        }
    }
}

impl<'a> Display for FormatCtx<'a, ElsifBranch> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.pad())?;
        let a = self.item;
        writeln!(f, "elsif {} then", self.child(self.get_expr(a.condition)))?;
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
                name,
                ports_start,
                ports_end,
            } => {
                writeln!(f, "component {name}")?;
                self.write_ports(f, *ports_start, *ports_end)?;
                writeln!(f, "{}end component;", self.pad())
            }
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
        write!(
            f,
            "{}{}: {:?} {}",
            self.pad(),
            p.name,
            p.mode,
            self.child(self.get_expr(p.port_type))
        )
    }
}
impl<'a> Display for FormatCtx<'a, Entity<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let entity = self.item;
        writeln!(f, "entity {} is", self.item.name)?;

        self.write_ports(f, entity.ports_start, entity.ports_end)?;

        writeln!(f, "end {};", entity.name)?;
        Ok(())
    }
}

impl<'a, T> FormatCtx<'a, T> {
    fn write_ports(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        ports_start: PortId,
        ports_end: PortId,
    ) -> std::fmt::Result {
        writeln!(f, "{}port (", self.pad())?;
        let arena = self.arena;
        let ids = &arena.ports[ports_start.0 as usize..ports_end.0 as usize];
        for ports in ids {
            write!(f, "{}", self.child_indented(ports))?;
            if ids.last().unwrap() != ports {
                write!(f, ";")?;
            }
            writeln!(f)?;
        }
        writeln!(f, "{});", self.pad())
    }
    fn fmt_association_list(
        &self,
        f: &mut std::fmt::Formatter<'_>,
        range: Range<u32>,
    ) -> std::fmt::Result {
        write!(f, "(")?;
        let start = range.start as usize;
        let end = range.end as usize;

        for (i, assoc) in self.arena.associations[start..end].iter().enumerate() {
            if i > 0 {
                write!(f, ",\n")?;
                dbg!(assoc);
            }
            // Named mapping: formal => actual
            write!(f, "{}", self.pad())?;
            if let Some(formal_id) = assoc.formal {
                write!(f, "{}", self.child(self.arena.expr(formal_id)))?;
                write!(f, " => ")?;
            }
            // Actual expression or positional argument
            write!(f, "{}", self.child(self.arena.expr(assoc.actual)))?;
        }

        write!(f, ")")
    }
}
