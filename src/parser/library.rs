use super::Parser;

use crate::ast::{ContextId, ContextItem};
use crate::parser::{ParseResult, TokenKind};

impl<'a> Parser<'a> {
    pub(super) fn parse_lib(&mut self) -> ParseResult<ContextId> {
        let start_tok = self.advance();

        match start_tok.kind {
            TokenKind::KwLibrary => {
                let name_tok = self.expect(TokenKind::Identifier)?;
                let name = self.get_text(name_tok.span);
                self.expect(TokenKind::Semicolon)?;
                // TODO create a Hashset to make it more efficient
                if let Some(x) = self
                    .arena
                    .contexts
                    .iter()
                    .map(|f| match f {
                        ContextItem::Library { name } => name,
                        ContextItem::Use { path } => &"",
                    })
                    .position(|name_2| name_2 == &name)
                {
                    return Ok(ContextId(x as u32));
                }

                Ok(self.arena.alloc_context(ContextItem::Library { name }))
            }
            TokenKind::KwUse => {
                let s = self.fast_forward_to_semicolon()?;
                let path = &self.source[s.start..s.end];
                if let Some(x) = self
                    .arena
                    .contexts
                    .iter()
                    .map(|f| match f {
                        ContextItem::Library { name } => &"",
                        ContextItem::Use { path } => path,
                    })
                    .position(|name_2| name_2 == &path)
                {
                    return Ok(ContextId(x as u32));
                }
                Ok(self.arena.alloc_context(ContextItem::Use { path }))
            }
            _ => panic!("Expected library or use clause"),
        }
    }
}
