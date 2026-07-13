use std::fmt::Display;

use crate::{
    ast::{AstArena, ContextItem, Decl, Entity, Port, Stmt}, lexer::Span,
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
            writeln!(f, "\n{}", self.child(c))?;
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
            for stmt in &arena.stmts[a.stmts_start.0 as usize..a.stmts_end.0 as usize] {
                writeln!(f, "\t\t{}", self.child(stmt))?;
            }
        }
        Ok(())
    }
}

impl<'a> Display for FormatCtx<'a, Stmt<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            Stmt::ConcurrentAssignment {
                target,
                expression_span,
            } => write!(
                f,
                "Concurrent assignment: {} <- {}",
                target,
                self.get_text(expression_span)
            ),
            Stmt::ConditionalAssignment { target } => todo!(),
            Stmt::ComponentInstantiation {
                label,
                component_name,
                port_map_span,
            } => todo!(),
            Stmt::Process {
                label,
                stmts_start,
                stmts_end,
            } => write!(f, "Process -> label: {:?}", label),
            Stmt::SequentialAssignment {
                target,
                expression_span,
            } => write!(f, "Sequential assignment: {}", target),
            Stmt::VariableAssignment {
                target,
                expression_span,
            } => todo!(),
            Stmt::If {
                condition_span,
                then_start,
                then_end,
                else_start,
                else_end,
                elsifs_start,
                elsifs_end,
            } => write!(f, "If statement: {:?}", self.get_text(condition_span)),
            Stmt::Case {
                expression_span,
                cases_span,
            } => todo!(),
            Stmt::Loop {
                label,
                loop_scheme_span,
                stmts_start,
                stmts_end,
            } => todo!(),
        }
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
            ContextItem::Library { name } => write!(f, "Library: {}", name),
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
impl <'a> Display for FormatCtx<'a, Entity<'a>> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f,"Entity - {}", self.item.name)
    }
}