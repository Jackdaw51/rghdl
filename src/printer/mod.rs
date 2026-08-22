mod printer_ast;
mod printer_elaborated;

use crate::analyzer::{SemanticAnalyzer, SymbolId};
use crate::ast::{AstArena, Expr, ExprId};
use crate::elaborator::ElaboratedArena;
use crate::parser::Span;
pub struct FormatCtx<'a, T> {
    pub item: &'a T,
    pub source: &'a str,
    pub arena: &'a AstArena<'a>,
    pub indent: usize,
}
impl<'a, T> FormatCtx<'a, T> {
    fn get_text(&self, span: Span) -> &'a str {
        &self.source[span.start..span.end]
    }
    fn child<U>(&self, item: &'a U) -> FormatCtx<'a, U> {
        FormatCtx {
            item: item,
            source: self.source,
            arena: self.arena,
            indent: self.indent,
        }
    }
    fn child_indented<U>(&self, item: &'a U) -> FormatCtx<'a, U> {
        FormatCtx {
            item,
            source: self.source,
            arena: self.arena,
            indent: self.indent + 1,
        }
    }
    fn pad(&self) -> String {
        "\t".repeat(self.indent)
    }
    fn get_expr(&self, expr_id: ExprId) -> &Expr<'a> {
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
