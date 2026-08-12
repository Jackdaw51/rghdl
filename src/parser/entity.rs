use crate::{
    ast::{Entity, EntityId},
    parser::TokenKind,
    parser::{ParseResult, Parser},
};

impl<'a> Parser<'a> {
    pub(super) fn parse_entity(&mut self) -> ParseResult<EntityId> {
        self.advance();
        let name_token = self.expect(TokenKind::Identifier)?;
        let entity_name = self.get_text(name_token.span);

        self.expect(TokenKind::KwIs)?;

        let (ports_start, ports_end) = self.parse_port_clause()?;

        self.expect(TokenKind::KwEnd)?;

        // VHDL allows end [entity] [my_entity];
        if self.lexer.peek().kind == TokenKind::KwEntity {
            self.advance();
        }

        if self.next_is(TokenKind::Identifier) {
            let t = self.advance();
            if self.get_text(t.span) != entity_name {
                panic!(
                    "Syntax error: End label '{}' and entity name '{}' should match",
                    self.get_text(t.span),
                    entity_name
                );
            }
        }

        self.expect(TokenKind::Semicolon)?;

        let entity = Entity {
            name: entity_name,
            name_span: name_token.span,
            ports_start,
            ports_end,
        };

        Ok(self.arena.alloc_entity(entity))
    }
}
