use std::iter::Peekable;

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
                    todo!()
                }
            }
        }
    }

    fn parse_entity(&mut self) -> EntityId {
        self.advance();
        let name_token = self.expect(TokenKind::Identifier);
        let entity_name = self.get_text(name_token.span);

        self.expect(TokenKind::KwIs);

        let (ports_start, ports_end) = self.parse_port_clause();

        self.expect(TokenKind::KwEnd);

        // VHDL allows end [entity] [my_entity];
        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwEntity) {
            self.advance();
        }

        if self.next_is_ident() {
            let t = self.advance();
            if self.get_text(t.span) != entity_name {
                panic!(
                    "Syntax error: End label '{}' and entity name '{}' should match",
                    self.get_text(t.span),
                    entity_name
                );
            }
        }

        self.expect(TokenKind::Semicolon);

        let entity = Entity {
            name: entity_name,
            ports_start,
            ports_end,
        };

        self.arena.alloc_entity(entity)
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

    fn parse_architecture(&mut self) -> ArchitectureId {
        self.advance();

        let arch_name_tok = self.expect(TokenKind::Identifier);
        let arch_name = self.get_text(arch_name_tok.span);

        self.expect(TokenKind::KwOf);

        let entity_name_tok = self.expect(TokenKind::Identifier);
        let entity_name = self.get_text(entity_name_tok.span);

        self.expect(TokenKind::KwIs);

        let decls_start = self.arena.decls.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwBegin {
                break;
            }
            self.parse_architecture_declaration();
        }

        let decls_end = self.arena.decls.len() as u32;

        self.expect(TokenKind::KwBegin);

        let stmts_start = self.arena.stmts.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwEnd {
                break;
            }
            // TODO: Parse concurrent assignments, processes, component instantiations
            self.parse_concurrent_statement();
        }

        let stmts_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd);

        //same with entity, possible are "end [architecture] [my_architecture]";

        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwArchitecture) {
            self.advance();
        }

        if self.next_is_ident() {
            let t = self.advance();
            let end_name = self.get_text(t.span);

            if end_name != arch_name {
                panic!(
                    "Syntax Error: End label '{}' does not match architecture name '{}'",
                    end_name, arch_name
                );
            }
        }
        self.expect(TokenKind::Semicolon);

        let arch = Architecture {
            name: arch_name,
            entity_name,
            decls_start: DeclId(decls_start),
            decls_end: DeclId(decls_end),
            stmts_start: StmtId(stmts_start),
            stmts_end: StmtId(stmts_end),
        };

        self.arena.alloc_architecture(arch)
    }

    fn parse_lib(&mut self) -> ContextId {
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

    fn parse_architecture_declaration(&mut self) -> ParseResult<()> {
        let start_tok = self.advance();

        dbg!(self.get_text(start_tok.span));
        match start_tok.kind {
            TokenKind::KwComponent => self.parse_component_declaration(),
            TokenKind::KwSignal => self.parse_SCV_declaration(TokenKind::KwSignal),
            TokenKind::KwConstant => self.parse_SCV_declaration(TokenKind::KwConstant),
            TokenKind::KwVariable => self.parse_SCV_declaration(TokenKind::KwVariable),
            _ => {
                panic!(
                    "Syntax Error: Expected something TODO, found {:?} around {}",
                    start_tok.kind,
                    self.get_text(start_tok.span)
                )
            }
        }?;
        let decl_ends = self.arena.decls.len() as u32;
        Ok(())
    }

    fn parse_concurrent_statement(&mut self) -> StmtId {
        let first_token = self.advance();
        if first_token.kind == TokenKind::KwProcess {
            return self.parse_process(None);
        }

        if first_token.kind != TokenKind::Identifier {
            panic!(
                "Syntax Error: Expected concurrent statement, found {:?} near {}",
                first_token.kind,
                self.get_text(first_token.span)
            );
        }
        let identifier_name = self.get_text(first_token.span);

        match self.lexer.peek().map(|f| f.kind) {
            Some(TokenKind::OpSignalAssignOrLEq) => {
                self.advance();

                let expr_start = self.lexer.peek().map(|t| t.span.start).unwrap_or(0);
                let mut expr_end = expr_start;

                while let Some(tok) = self.lexer.peek() {
                    if tok.kind == TokenKind::Semicolon {
                        break;
                    }
                    expr_end = self.advance().span.end;
                }

                self.expect(TokenKind::Semicolon);

                let stmt = Stmt::ConcurrentAssignment {
                    target: identifier_name,
                    expression_span: Span {
                        start: expr_start,
                        end: expr_end,
                    },
                };

                self.arena.alloc_stmt(stmt)
            }

            // Either a label or a component instantiation
            Some(TokenKind::Colon) => {
                self.advance(); // Consume ':'

                let after_colon = &self.lexer.peek().expect("Unexpected EOF after label").kind;

                if after_colon == &TokenKind::KwProcess {
                    self.advance(); // Consume 'process'
                    self.parse_process(Some(identifier_name))
                } else {
                    // For now, assume if it's a label but not a process, it's an instantiation TODO
                    self.parse_component_instantiation(identifier_name)
                }
            }
            _ => panic!(
                "Unexpected token '{:?}' found after concurrent statement near '{}'",
                first_token,
                self.get_text(first_token.span)
            ),
        }
    }

    fn parse_process(&mut self, label: Option<&'a str>) -> StmtId {
        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::LParen) {
            self.advance();
            while let Some(tok) = self.lexer.peek() {
                if tok.kind == TokenKind::RParen {
                    break;
                }
                self.advance();
            }
            self.expect(TokenKind::RParen);
        }

        // TODO: optional process variables

        self.expect(TokenKind::KwBegin);

        let stmts_start = self.arena.stmts.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwEnd {
                break;
            }
            self.parse_sequential_statement();
        }

        let stmts_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd);

        // Handle optional "end process;" or "end process label;"
        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwProcess) {
            self.advance();
        }

        if let Some(lbl) = label {
            if self.next_is_ident() {
                let t = self.advance();
                if self.get_text(t.span) != lbl {
                    panic!("Process and end label do not match!");
                }
            }
        }

        self.expect(TokenKind::Semicolon);

        let process_stmt = Stmt::Process {
            label,
            stmts_start: StmtId(stmts_start),
            stmts_end: StmtId(stmts_end),
        };

        self.arena.alloc_stmt(process_stmt)
    }

    /// Fast forwards to ```;``` consuming it
    fn fast_forward_to_semicolon(&mut self) -> Span {
        let span = self.slice_until_depth_zero(&[TokenKind::Semicolon]);
        self.expect(TokenKind::Semicolon); // Safely consume the semicolon
        span
    }

    fn parse_component_instantiation(&self, identifier_name: &str) -> StmtId {
        todo!()
    }

    fn parse_sequential_statement(&mut self) -> StmtId {
        match self.lexer.peek().map(|t| t.kind) {
            Some(TokenKind::KwIf) => self.parse_if_statement(),

            // TODO
            // TokenKind::KwCase => self.parse_case_statement(),
            // TokenKind::KwFor | TokenKind::KwWhile => self.parse_loop_statement(),
            Some(TokenKind::Identifier) => {
                // It's an assignment (either signal <= or variable :=)
                let name_tok = self.advance();
                let target = self.get_text(name_tok.span);

                match self.lexer.peek().map(|t| t.kind) {
                    // Signal Assignment: target <= expr;
                    Some(TokenKind::OpSignalAssignOrLEq) => {
                        self.advance(); // Consume '<='
                        let expr_span = self.fast_forward_to_semicolon();

                        let stmt = Stmt::SequentialAssignment {
                            target,
                            expression_span: expr_span,
                        };
                        self.arena.alloc_stmt(stmt)
                    }

                    // Variable Assignment: target := expr;
                    Some(TokenKind::OpAssign) => {
                        self.advance(); // Consume ':='
                        let expr_span = self.fast_forward_to_semicolon();

                        let stmt = Stmt::VariableAssignment {
                            target,
                            expression_span: expr_span,
                        };
                        self.arena.alloc_stmt(stmt)
                    }
                    None => panic!("Unexpected EOF"),

                    _ => panic!(
                        "Syntax Error: Expected '<=' or ':=' after identifier '{}' in process",
                        target
                    ),
                }
            }
            None => panic!("Unexpected EOF"),
            Some(tk) => panic!(
                "Syntax Error: Unexpected token {:?} in sequential statement",
                tk
            ),
        }
    }

    fn parse_if_statement(&mut self) -> StmtId {
        self.advance(); // Consume if

        let cond_start = self.lexer.peek().map(|t| t.span.start).unwrap_or(0);
        let mut cond_end = cond_start;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwThen {
                break;
            }
            cond_end = self.advance().span.end;
        }
        let condition_span = Span {
            start: cond_start,
            end: cond_end,
        };
        self.expect(TokenKind::KwThen); // Consume 'then'

        let then_start = self.arena.stmts.len() as u32;
        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwElse || tok.kind == TokenKind::KwEnd {
                break;
            }
            self.parse_sequential_statement();
        }
        let then_end = self.arena.stmts.len() as u32;

        let else_start = self.arena.stmts.len() as u32;
        let mut has_else = false;

        if self.lexer.peek().map(|t| t.kind.clone()) == Some(TokenKind::KwElse) {
            self.advance(); // Consume 'else'
            has_else = true;

            while let Some(tok) = self.lexer.peek() {
                if tok.kind == TokenKind::KwEnd {
                    break;
                }
                self.parse_sequential_statement();
            }
        }
        let else_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd);
        if self.lexer.peek().map(|t| t.kind.clone()) == Some(TokenKind::KwIf) {
            self.advance();
        }
        self.expect(TokenKind::Semicolon);

        let if_stmt = Stmt::If {
            condition_span,
            then_start: StmtId(then_start),
            then_end: StmtId(then_end),
            else_start: if has_else {
                Some(StmtId(else_start))
            } else {
                None
            },
            else_end: if has_else {
                Some(StmtId(else_end))
            } else {
                None
            },
        };

        self.arena.alloc_stmt(if_stmt)
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

    fn parse_component_declaration(&mut self) -> ParseResult<()> {
        let name_tok = self.expect(TokenKind::Identifier);
        let name = self.get_text(name_tok.span);
        let (ports_start, ports_end) = self.parse_port_clause();

        let decl = Decl::Component {
            name,
            ports_start,
            ports_end,
        };
        self.expect(TokenKind::KwEnd);

        //TODO only handles end component; for now

        self.expect(TokenKind::KwComponent);
        self.expect(TokenKind::Semicolon);

        self.arena.alloc_decl(decl);
        Ok(())
    }

    /// Only handles `signal identifier_1,identifier_n : subtype;`
    fn parse_SCV_declaration(&mut self, t: TokenKind) -> ParseResult<()> {
        let mut names = vec![];
        let name_tok = self.expect(TokenKind::Identifier);
        names.push(self.get_text(name_tok.span));
        // handle comma-separated signals
        while self.next_is(TokenKind::Comma) {
            self.advance();
            let name_tok = self.expect(TokenKind::Identifier);
            names.push(self.get_text(name_tok.span));
        }
        self.expect(TokenKind::Colon);

        let type_span = self.slice_until_depth_zero(&[TokenKind::Semicolon, TokenKind::OpAssign]);
        let decl_type = self.get_text(type_span).trim();

        let mut default_val = None;
        if self.next_is(TokenKind::OpAssign) {
            self.advance();

            let expr_span = self.slice_until_depth_zero(&[TokenKind::Semicolon]);
            default_val = Some(self.get_text(expr_span).trim());
        }

        self.expect(TokenKind::Semicolon);


        for name in names {
            let decl = match t {
                TokenKind::KwSignal => Decl::Signal { name, decl_type, default_val },
                TokenKind::KwVariable => Decl::Variable { name, decl_type, default_val },
                TokenKind::KwConstant => Decl::Constant { name, decl_type, default_val },
                _ => unreachable!("Token was already validated"), 
            };
            self.arena.alloc_decl(decl);
    }
    
        Ok(())
    }

    fn next_is(&mut self, next_kind: TokenKind) -> bool {
        self.lexer.peek().map(|f| f.kind) == Some(next_kind)
    }
}
