use crate::ast::{AstArena, Port, PortId, PortMode};
use crate::printer::FormatCtx;
use crate::{
    exp_tks,
    parser::{Lexer, ParseError, ParseErrorKind, ParseResult, Parser, Span, Token, TokenKind},
};

impl<'a> Parser<'a> {
    pub(crate) fn new(source: &'a str) -> Self {
        Self {
            lexer: Lexer::new(source),
            arena: AstArena::new(),
            source,
            errors: vec![],
        }
    }

    pub(crate) fn parse(&mut self) {
        loop {
            let next = self.lexer.peek();
            match next.kind {
                TokenKind::KwEntity => {
                    let res = self.parse_entity();
                    if res.is_err() {
                        println!("{:?}", res);
                    }
                }
                TokenKind::KwArchitecture => {
                    let res = self.parse_architecture();
                    match res {
                        Ok(x) => {}
                        Err(x) => {
                            println!(
                                "{}",
                                FormatCtx {
                                    item: &x,
                                    source: self.source,
                                    arena: &self.arena,
                                    indent: 0
                                }
                            );
                        }
                    }
                }
                TokenKind::KwLibrary | TokenKind::KwUse => {
                    let res = self.parse_lib();
                }
                TokenKind::Eof => break,
                x => {
                    panic!(
                        "There's something wrong in the parsing, check around {} at line {}.",
                        self.get_text(next.span),
                        self.lexer.get_current_line()
                    )
                    // Maybe doesn't account for all parsing error, so panics reporting what is wrong
                    // panics if semicolon on last port variable TODO
                }
            };
        }
    }

    pub(super) fn print_errors(&self) {
        for error in &self.errors {
            println!(
                "{:?}, line {}",
                error.kind,
                self.get_line_from_span(error.span)
            );
        }
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

    pub(super) fn err<T>(&self, kind: ParseErrorKind, span: Span) -> ParseResult<T> {
        Err(ParseError { kind, span })
    }
    pub(super) fn advance(&mut self) -> Token {
        let a = self.lexer.next();
        // dbg!(format!("{}", a.kind));
        a
    }
    pub(super) fn expect(&mut self, expected: TokenKind) -> ParseResult<Token> {
        let token = self.advance();
        if token.kind != expected {
            if token.kind == TokenKind::Eof {
                dbg!(token.clone());
                return self.err(ParseErrorKind::UnexpectedEof, token.span);
            }
            return self.err(
                ParseErrorKind::ExpectedToken {
                    expected,
                    found: token.kind,
                },
                token.span,
            );
        }
        Ok(token)
    }

    /// Parses `port ( ... );` and returns the slice of IDs allocated in the arena.
    ///
    /// If none is present it ```PortId == PortId```
    pub(super) fn parse_port_clause(&mut self) -> ParseResult<(PortId, PortId)> {
        let ports_start = self.arena.ports.len() as u32;

        if self.lexer.peek().kind == TokenKind::KwPort {
            self.advance();
            self.expect(TokenKind::LParen)?;

            loop {
                self.parse_port()?;

                let next = self.lexer.peek();

                if next.kind == TokenKind::Semicolon {
                    self.advance();
                } else if next.kind == TokenKind::RParen {
                    break;
                } else {
                    exp_tks!(
                        next.kind,
                        next.span,
                        TokenKind::Semicolon,
                        TokenKind::RParen
                    )
                }
            }
            self.expect(TokenKind::RParen)?;
            self.expect(TokenKind::Semicolon)?;
        }

        let ports_end = self.arena.ports.len() as u32;

        Ok((PortId(ports_start), PortId(ports_end)))
    }

    /// Parses a port declaration line, supporting comma-separated identifier lists
    /// like `a, b, c : in std_logic`.
    pub fn parse_port(&mut self) -> ParseResult<()> {
        let mut names = Vec::new();

        // Parse comma-separated identifiers
        let first_tok = self.expect(TokenKind::Identifier)?;
        names.push((self.get_text(first_tok.span), first_tok.span));

        while self.next_is(TokenKind::Comma) {
            self.advance(); // Consume ','
            let tok = self.expect(TokenKind::Identifier)?;
            names.push((self.get_text(tok.span), tok.span));
        }

        self.expect(TokenKind::Colon)?;

        // Parse port mode (defaults to 'in' per IEEE 1076 if omitted)
        let mode = match self.lexer.peek().kind {
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
        };

        let port_type = self.parse_expression()?;

        // Allocate each port consecutively so the arena slice range stays intact
        for (name, name_span) in names {
            let port = Port {
                name,
                name_span,
                mode,
                port_type,
            };
            self.arena.alloc_port(port);
        }

        Ok(())
    }

    /// Fast forwards to ```;``` consuming it
    pub(super) fn fast_forward_to_semicolon(&mut self) -> ParseResult<Span> {
        let span = self.slice_until_depth_zero(&[TokenKind::Semicolon])?;
        self.expect(TokenKind::Semicolon)?; // consume the semicolon
        Ok(span)
    }

    pub(super) fn slice_until_depth_zero(
        &mut self,
        terminators: &[TokenKind],
    ) -> ParseResult<Span> {
        let start = self.lexer.peek().span.start;
        let mut end = start;
        let mut paren_depth = 0;

        while self.not_eof() {
            let tok = self.lexer.peek();
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
        Ok(Span { start, end })
    }

    /// `next != EOF`
    pub(super) fn not_eof(&mut self) -> bool {
        self.lexer.peek().kind != TokenKind::Eof
    }

    pub(super) fn get_text(&self, span: Span) -> &'a str {
        &self.source[span.start..span.end]
    }

    /// Returns `true` if next token is `next_kind`, without consuming it
    pub(super) fn next_is(&mut self, next_kind: TokenKind) -> bool {
        let k = self.lexer.peek().kind;
        k == next_kind
    }
}
