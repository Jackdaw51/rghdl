use super::Parser;

use crate::parser::{ParseResult, TokenKind, ast::{ContextId, ContextItem}};

impl<'a> Parser<'a> {
    pub(super) fn parse_lib(&mut self) -> ParseResult<ContextId> {
        let start_tok = self.advance();

        match start_tok.kind {
            TokenKind::KwLibrary => {
                let name_tok = self.expect(TokenKind::Identifier)?;
                let name = self.get_text(name_tok.span);
                self.expect(TokenKind::Semicolon)?;

                Ok(self.arena.alloc_context(ContextItem::Library { name }))
            }
            TokenKind::KwUse => {
                let s = self.fast_forward_to_semicolon()?;
                let path = &self.source[s.start..s.end];
                Ok(self.arena.alloc_context(ContextItem::Use { path }))
            }
            _ => panic!("Expected library or use clause"),
        }
    }
}
