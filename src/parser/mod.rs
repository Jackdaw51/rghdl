use std::iter::Peekable;
mod architecture;
mod entity;
mod library;

use crate::{
    ast::*,
    lexer::{Lexer, Span, Token, TokenKind},
};

pub struct Parser<'a> {
    lexer: Peekable<Lexer<'a>>,
    pub arena: AstArena<'a>,
    source: &'a str,
}
#[derive(Debug, Clone)]
pub enum ParseErrorKind {
    ExpectedToken {
        expected: TokenKind,
        found: TokenKind,
    },
    UnexpectedEof,
}

#[derive(Debug, Clone)]
pub struct ParseError {
    pub kind: ParseErrorKind,
    pub span: Span,
}

pub type ParseResult<T> = Result<T, ParseError>;

impl<'a> Parser<'a> {
    pub(crate) fn new(source: &'a str) -> Self {
        Self {
            lexer: Lexer::new(source).peekable(),
            arena: AstArena::new(),
            source,
        }
    }

    pub(crate) fn parse(&mut self) {
        while let Some(token) = self.lexer.peek() {
            match token.kind {
                TokenKind::KwEntity => {
                    self.parse_entity();
                }
                TokenKind::KwArchitecture => {
                    self.parse_architecture();
                }
                TokenKind::KwLibrary | TokenKind::KwUse => {
                    self.parse_lib();
                }
                TokenKind::Eof => break,
                _ => {
                    unreachable!("There's something wrong in the parsing")
                }
            }
        }
    }

    fn advance(&mut self) -> Token {
        self.lexer.next().unwrap_or_else(|| Token {
            kind: TokenKind::Eof,
            span: Span { start: 0, end: 0 },
        })
    }
    fn expect(&mut self, expected: TokenKind) -> Token {
        let token = self.advance();
        if token.kind != expected {
            panic!(
                "Syntax Error: Expected {:?}, but found {:?} around: {}",
                expected,
                token.kind,
                self.get_text(token.span)
            );
        }
        token
    }

    /// Parses `port ( ... );` and returns the slice of IDs allocated in the arena.
    ///
    /// If none is present it ```PortId == PortId```
    fn parse_port_clause(&mut self) -> (PortId, PortId) {
        let ports_start = self.arena.ports.len() as u32;

        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwPort) {
            self.advance();
            self.expect(TokenKind::LParen);

            loop {
                self.parse_port();

                let next_kind = self.lexer.peek().map(|t| t.kind);
                if next_kind == Some(TokenKind::Semicolon) {
                    self.advance();
                } else if next_kind == Some(TokenKind::RParen) {
                    break;
                } else {
                    panic!("Syntax Error: Expected ';' or ')' after port declaration");
                }
            }
            self.expect(TokenKind::RParen);
            self.expect(TokenKind::Semicolon);
        }

        let ports_end = self.arena.ports.len() as u32;

        (PortId(ports_start), PortId(ports_end))
    }

    //TODO: handle comma-separated names
    fn parse_port(&mut self) -> PortId {
        let name_tok = self.expect(TokenKind::Identifier);
        let name = self.get_text(name_tok.span);

        self.expect(TokenKind::Colon);

        let mode = if let Some(tok) = self.lexer.peek() {
            match tok.kind {
                TokenKind::KwIn => {
                    self.advance();
                    PortMode::In
                }
                TokenKind::KwOut => {
                    self.advance();
                    PortMode::Out
                }
                TokenKind::KwInOut => {
                    self.advance();
                    PortMode::InOut
                }
                TokenKind::KwBuffer => {
                    self.advance();
                    PortMode::Buffer
                }
                _ => PortMode::In,
            }
        } else {
            PortMode::In
        };

        let type_span = self.slice_until_depth_zero(&[TokenKind::Semicolon, TokenKind::RParen]);
        let port_type = self.get_text(type_span).trim();

        let port = Port {
            name,
            mode,
            port_type,
        };

        self.arena.alloc_port(port)
    }

    /// Fast forwards to ```;``` consuming it
    fn fast_forward_to_semicolon(&mut self) -> Span {
        let span = self.slice_until_depth_zero(&[TokenKind::Semicolon]);
        self.expect(TokenKind::Semicolon); // Safely consume the semicolon
        span
    }

    fn next_is_ident(&mut self) -> bool {
        self.lexer
            .peek()
            .map(|t| t.kind == TokenKind::Identifier)
            .unwrap_or(false)
    }

    fn slice_until_depth_zero(&mut self, terminators: &[TokenKind]) -> Span {
        let start = self.lexer.peek().map(|t| t.span.start).unwrap_or(0);
        let mut end = start;
        let mut paren_depth = 0;

        while let Some(tok) = self.lexer.peek() {
            if paren_depth == 0 && terminators.contains(&tok.kind) {
                break;
            }

            match tok.kind {
                TokenKind::LParen => paren_depth += 1,
                TokenKind::RParen if paren_depth > 0 => paren_depth -= 1,
                _ => {}
            }
            end = self.advance().span.end;
        }
        Span { start, end }
    }

    fn get_text(&self, span: Span) -> &'a str {
        &self.source[span.start..span.end]
    }

    fn next_is(&mut self, next_kind: TokenKind) -> bool {
        self.lexer.peek().map(|f| f.kind) == Some(next_kind)
    }
}
