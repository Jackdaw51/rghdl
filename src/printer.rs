use std::fmt::Display;

use crate::{
    ast::{AstArena, ConcurrentStmt, ContextItem, Decl, ElsifBranch, Entity, Port, SequentialStmt}, lexer::Span,
};

pub struct FormatCtx<'a, T> {
    pub item: &'a T,
    pub source: &'a str,
    pub arena: &'a AstArena<'a>,
}
impl<'a, T> FormatCtx<'a, T> {
    fn get_text(&self, span: &Span) -> &'a str {
        &self.source[span.start..span.end]
    }
    fn child<U>(&self, item: &'a U) -> FormatCtx<'a, U> {
        FormatCtx {
            item: item,
            source: self.source,
            arena: self.arena,
        }
    }

    // let stmt_ctx = FormatCtx {
    //                 item: stmt,
    //                 source: self.source,
    //                 arena: self.arena,
    //             };
}

impl<'a> Display for FormatCtx<'a, AstArena<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let arena = self.item;

        for c in &arena.contexts {
            write!(f, "\n{}", self.child(c))?;
        }

        for e in &arena.entities {
            writeln!(f, "\n{}", self.child(e))?;
            for ports in &arena.ports[e.ports_start.0 as usize..e.ports_end.0 as usize] {
                write!(f, "\t{}", self.child(ports))?;
            }
        }

        for a in &arena.architectures {
            writeln!(
                f,
                "\nArchitecture - {}, referencing {}",
                a.name, a.entity_name
            )?;
            writeln!(f, "\tDeclarations:")?;
            for decls in &arena.decls[a.decls_start.0 as usize..a.decls_end.0 as usize] {
                write!(f, "\t\t{}", self.child(decls))?;
            }

            writeln!(f, "\tStatements:")?;
            let conc_ids = &arena.conc_stmt_lists[a.stmts.start as usize..a.stmts.end as usize];
            for id in conc_ids {
                let stmt = &arena.concurrent_stmts[id.0 as usize];
                writeln!(f, "\t\t{}", self.child(stmt))?;
            }
        }
        Ok(())
    }
}

impl<'a> Display for FormatCtx<'a, ConcurrentStmt<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            ConcurrentStmt::ConcurrentAssignment {
                target,
                expression_span,
            } => write!(
                f,
                "Concurrent assignment: {} <- {}",
                target,
                self.get_text(expression_span)
            ),
            ConcurrentStmt::ConditionalAssignment { target } => todo!(),
            ConcurrentStmt::ComponentInstantiation {
                label,
                component_name,
                port_map_span,
            } => todo!(),
            ConcurrentStmt::Process { label, stmts } => {
                writeln!(f, "Process -> label: {:?}", label)?;
                let seq_ids = &self.arena.seq_stmt_lists[stmts.start as usize..stmts.end as usize];
                for id in seq_ids {
                    let stmt = &self.arena.sequential_stmts[id.0 as usize];
                    writeln!(f, "\t\t\t{}", self.child(stmt))?;
                }
                Ok(())
            }
        }
    }
}

impl<'a> Display for FormatCtx<'a, SequentialStmt<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            SequentialStmt::SequentialAssignment {
                target,
                expression_span,
            } => writeln!(
                f,
                "\tSequential assignment: {} <= {}",
                target,
                self.get_text(expression_span)
            ),
            SequentialStmt::VariableAssignment {
                target,
                expression_span,
            } => writeln!(
                f,
                "Variable assignment: {} := {}",
                target,
                self.get_text(expression_span)
            ),
            SequentialStmt::If {
                condition_span,
                then_stmts,
                else_stmts,
                elsif_stmts,
            } => {
                writeln!(f, "If statement: {}", self.get_text(condition_span))?;

                let then_ids =
                    &self.arena.seq_stmt_lists[then_stmts.start as usize..then_stmts.end as usize];
                for id in then_ids {
                    let stmt = &self.arena.sequential_stmts[id.0 as usize];
                    writeln!(f, "\t\t\t\t{}", self.child(stmt))?;
                }

                for elsif in &self.arena.elsifs[elsif_stmts.start as usize..elsif_stmts.end as usize] {
                    write!(f, "\t\t\t\t{}", self.child(elsif))?;
                }

                // ELSE block (via indirection table)
                if !else_stmts.is_empty() {
                    writeln!(f, "\t\t\telse:")?;
                    let else_ids = &self.arena.seq_stmt_lists
                        [else_stmts.start as usize..else_stmts.end as usize];
                    for id in else_ids {
                        let stmt = &self.arena.sequential_stmts[id.0 as usize];
                        writeln!(f, "\t\t\t\t{}", self.child(stmt))?;
                    }
                }
                Ok(())
            }
            SequentialStmt::Case { expression_span, cases_span } => todo!(),
            SequentialStmt::Loop { label, loop_scheme_span, stmts } => todo!(),
        }
    }
}

impl<'a> Display for FormatCtx<'a, ElsifBranch> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let a = self.item;
        writeln!(f, "elsif: {}", self.get_text(&a.condition_span))?;
        let stmt_ids =
            &self.arena.seq_stmt_lists[a.stmts.start as usize..a.stmts.end as usize];
        for id in stmt_ids {
            let stmt = &self.arena.sequential_stmts[id.0 as usize];
            writeln!(f, "\t\t\t\t{}", self.child(stmt))?;
        }
        Ok(())
    }
}
impl<'a> Display for FormatCtx<'a, Decl<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            Decl::Signal {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Signal: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
            Decl::Constant {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Constant: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
            Decl::Variable {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Variable: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
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
            ContextItem::Library { name } => write!(f, "Library {}", name),
            ContextItem::Use { path } => write!(f, "Path: {}", path),
        }
    }
}
impl<'a> Display for FormatCtx<'a, Port<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let p = self.item;
        writeln!(f, "{}: {:?} {}", p.name, p.mode, p.port_type)
    }
}
impl<'a> Display for FormatCtx<'a, Entity<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "Entity - {}", self.item.name)
    }
}
