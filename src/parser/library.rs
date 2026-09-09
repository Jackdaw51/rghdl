use super::Parser;

use crate::ast::{ContextId, ContextItem};
use crate::parser::{ParseResult, Span, TokenKind};

impl<'a> Parser<'a> {
    pub(super) fn parse_lib(&mut self) -> ParseResult<ContextId> {
        let start_tok = self.advance();

        // TODO implement the logic for tiding the use clause to the first primary unit chapter 13 IEEE
        match start_tok.kind {
            TokenKind::KwLibrary => {
                let name_tok = self.expect(TokenKind::Identifier)?;
                let name = self.intern(name_tok.span);
                self.expect(TokenKind::Semicolon)?;
                Ok(self.arena.alloc_context(ContextItem::Library { name, span: name_tok.span }))
                // // TODO create a Hashset to make it more efficient
                // if let Some(x) = self
                //     .arena
                //     .contexts
                //     .iter()
                //     .map(|f| match f {
                //         ContextItem::Library { name } => self.get_text(*name),
                //         ContextItem::Use { path } => &"",
                //     })
                //     .position(|name_2| name_2 == name)
                // {
                //     return Ok(ContextId(x as u32));
                // }

            }
            TokenKind::KwUse => {
                let start = self.lexer.current_pos;
                let s = self.parse_expression()?;
                let span = Span::new(start,self.lexer.current_pos);
                self.expect(TokenKind::Semicolon)?;
                // if let Some(x) = self
                //     .arena
                //     .contexts
                //     .iter()
                //     .map(|f| match f {
                //         ContextItem::Library { name } => &"",
                //         ContextItem::Use { path } => self.get_text(*path),
                //     })
                //     .position(|name_2| name_2 == path)
                // {
                //     return Ok(ContextId(x as u32));
                // }
                Ok(self.arena.alloc_context(ContextItem::Use { path: s, span }))
            }
            _ => panic!("Expected library or use clause"),
        }
    }
}
