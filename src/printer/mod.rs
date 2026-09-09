mod printer_ast;
mod printer_elaborated;
pub mod printer_sa;

use std::collections::HashSet;

use crate::analyzer::{SemanticAnalyzer, SymbolId, SymbolInterner};
use crate::ast::{AstArena, Expr, ExprId};
use crate::elaborator::ElaboratedArena;
use crate::parser::Span;
pub struct FormatCtx<'a, T> {
    pub item: &'a T,
    pub source: &'a str,
    pub symbols: &'a SymbolInterner,
    pub arena: &'a AstArena,
    pub indent: usize,
}
impl<'a, T> FormatCtx<'a, T> {
    fn get_symbol(&self, symbol_id: SymbolId) -> &str {
        self.symbols.get(symbol_id)
    }
    fn child<U>(&self, item: &'a U) -> FormatCtx<'a, U> {
        FormatCtx {
            item: item,
            arena: self.arena,
            indent: self.indent,
            symbols: self.symbols,
            source: self.source,
        }
    }
    fn child_indented<U>(&self, item: &'a U) -> FormatCtx<'a, U> {
        FormatCtx {
            item,
            arena: self.arena,
            indent: self.indent + 1,
            symbols: self.symbols,
            source: self.source,
        }
    }
    fn pad(&self) -> String {
        "\t".repeat(self.indent)
    }
    fn get_expr(&self, expr_id: ExprId) -> &Expr {
        &self.arena.exprs[expr_id.0 as usize]
    }

    fn get_line_from_span(&self, span: Span) -> u32 {
        let mut line = 1;
        for (c, i) in self.source.as_bytes().iter().enumerate() {
            if *i as char == '\n' {
                line += 1;
            }
            if c == span.start {
                break;
            }
        }

        line
    }

    // let stmt_ctx = FormatCtx {
    //                 item: stmt,
    //                 source: self.source,
    //                 arena: self.arena,
    //             };
}

pub struct VhdlEmitter<'a> {
    sa: &'a SemanticAnalyzer<'a>,
    arena: &'a ElaboratedArena,
    emitted_entities: HashSet<SymbolId>,
    emitted_architectures: HashSet<(SymbolId, SymbolId)>,
}
pub struct ElaboratedFormatCtx<'a, T> {
    pub item: &'a T,
    pub arena: &'a ElaboratedArena,
    pub sa: &'a SemanticAnalyzer<'a>,
    pub indent: usize,
}

impl<'a, T> ElaboratedFormatCtx<'a, T> {
    /// Creates a context for a child node with the same indentation
    pub fn child<U>(&self, item: &'a U) -> ElaboratedFormatCtx<'a, U> {
        ElaboratedFormatCtx {
            item,
            arena: self.arena,
            sa: self.sa,
            indent: self.indent,
        }
    }

    /// Creates a context for a child node with increased indentation
    pub fn child_indented<U>(&self, item: &'a U) -> ElaboratedFormatCtx<'a, U> {
        ElaboratedFormatCtx {
            item,
            arena: self.arena,
            sa: self.sa,
            indent: self.indent + 1,
        }
    }

    pub fn pad(&self) -> String {
        "\t".repeat(self.indent)
    }

    /// Resolves a SymbolId to its String representation
    pub fn sym(&self, id: SymbolId) -> &str {
        &self.sa.symbols.interner.vec[id.0 as usize]
    }
}

pub struct SAFormatCtx<'a, T> {
    pub item: &'a T,
    pub arena: &'a AstArena,
    pub sa: &'a SemanticAnalyzer<'a>,
    pub indent: usize,
    pub path: &'a str,
}

impl<'a, T> SAFormatCtx<'a, T> {
    fn child<U>(&self, item: &'a U) -> SAFormatCtx<'a, U> {
        SAFormatCtx {
            item: item,
            arena: self.arena,
            indent: self.indent,
            sa: self.sa,
            path: self.path,
        }
    }
    fn child_indented<U>(&self, item: &'a U) -> SAFormatCtx<'a, U> {
        SAFormatCtx {
            item,
            arena: self.arena,
            indent: self.indent + 1,
            sa: self.sa,
            path: self.path,
        }
    }
    fn pad(&self) -> String {
        "\t".repeat(self.indent)
    }
    fn get_expr(&self, expr_id: ExprId) -> &Expr {
        &self.arena.exprs[expr_id.0 as usize]
    }
}
