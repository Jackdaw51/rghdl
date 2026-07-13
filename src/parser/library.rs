use super::Parser;

use crate::{ast::{ContextId, ContextItem}, lexer::TokenKind};

impl<'a> Parser<'a> {
    pub(crate) fn parse_lib(&mut self) -> ContextId {
        let start_tok = self.advance();

        match start_tok.kind {
            TokenKind::KwLibrary => {
                let name_tok = self.expect(TokenKind::Identifier);
                let name = self.get_text(name_tok.span);
                self.expect(TokenKind::Semicolon);

                self.arena.alloc_context(ContextItem::Library { name })
            }
            TokenKind::KwUse => {
                let s = self.fast_forward_to_semicolon();
                let path = &self.source[s.start..s.end];
                self.arena.alloc_context(ContextItem::Use { path })
            }
            _ => panic!("Expected library or use clause"),
        }
    }
}
