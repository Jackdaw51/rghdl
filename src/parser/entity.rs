use crate::{
    ast::{Decl, DeclId, Entity, EntityId},
    parser::{ParseResult, Parser, TokenKind},
};

impl<'a> Parser<'a> {
    pub(super) fn parse_entity(&mut self) -> ParseResult<EntityId> {
        self.advance();
        let name_token = self.expect(TokenKind::Identifier)?;
        let entity_name = self.get_text(name_token.span);

        self.expect(TokenKind::KwIs)?;

        let (generics_start, generics_end) = self.parse_generic_clause()?;
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
            generics_start,
            generics_end,
        };

        Ok(self.arena.alloc_entity(entity))
    }
    /// Parses an optional `generic (...)` clause inside an entity header and pushes
    /// interface constants into `arena.decls`.
    fn parse_generic_clause(&mut self) -> ParseResult<(DeclId, DeclId)> {
        let start = DeclId(self.arena.decls.len() as u32);

        if self.lexer.peek().kind != TokenKind::KwGeneric {
            return Ok((start, start));
        }

        self.advance(); // Consume `generic`
        self.expect(TokenKind::LParen)?;

        while self.lexer.peek().kind != TokenKind::RParen
            && self.not_eof()
        {
            // Generics in entity declarations are interface constants.
            // The `constant` keyword is optional
            if self.lexer.peek().kind == TokenKind::KwConstant {
                self.advance();
            }

            // Support multiple comma-separated identifiers
            let mut names = Vec::new(); //TODO check if you can avoid this
            loop {
                let id_token = self.expect(TokenKind::Identifier)?;
                names.push(self.get_text(id_token.span));

                if self.lexer.peek().kind == TokenKind::Comma {
                    self.advance();
                } else {
                    break;
                }
            }

            self.expect(TokenKind::Colon)?;

            let type_token = self.expect(TokenKind::Identifier)?;
            let decl_type = self.get_text(type_token.span);

            // Optional default initialization expression (`:= 32`)
            let default_val = if self.lexer.peek().kind == TokenKind::OpAssign {
                self.advance();
                Some(self.parse_expression()?)
            } else {
                None
            };
            // Push each generic as a `Decl::Constant` into the AST arena
            for name in names {
                self.arena.decls.push(Decl::Constant {
                    name,
                    decl_type,
                    default_val,
                });
            }

            if self.lexer.peek().kind == TokenKind::Semicolon {
                self.advance();
            } else {
                break;
            }
        }

        self.expect(TokenKind::RParen)?;
        self.expect(TokenKind::Semicolon)?;

        let end = DeclId(self.arena.decls.len() as u32);
        Ok((start, end))
    }
}
