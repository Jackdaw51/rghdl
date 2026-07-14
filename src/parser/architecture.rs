use super::Parser;
use crate::ast::ElsifId;
use crate::exp_tks;

use crate::parser::ParseErrorKind::UnexpectedEof;
use crate::{
    ast::{Architecture, ArchitectureId, Decl, DeclId, Stmt, StmtId},
    lexer::{Span, TokenKind},
    parser::{ParseError, ParseErrorKind, ParseResult},
};

impl<'a> Parser<'a> {
    pub(super) fn parse_architecture(&mut self) -> ParseResult<ArchitectureId> {
        self.advance();

        let arch_name_tok = self.expect(TokenKind::Identifier)?;
        let arch_name = self.get_text(arch_name_tok.span);

        self.expect(TokenKind::KwOf)?;

        let entity_name_tok = self.expect(TokenKind::Identifier)?;
        let entity_name = self.get_text(entity_name_tok.span);

        self.expect(TokenKind::KwIs)?;

        let decls_start = self.arena.decls.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwBegin {
                break;
            }
            if let Err(x) = self.parse_architecture_declaration(){
                self.errors.push(x);
                self.recover_to_declaration_boundary();
            };
        }

        let decls_end = self.arena.decls.len() as u32;

        self.expect(TokenKind::KwBegin)?;

        let stmts_start = self.arena.stmts.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwEnd {
                break;
            }
            // TODO: Parse concurrent assignments, processes, component instantiations
            if let Err(x) = self.parse_concurrent_statement(){
                self.errors.push(x);
                self.recover_to_statement_boundary();
            };
        }

        let stmts_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd)?;
        
        //same with entity, possible are "end [architecture] [my_architecture]";

        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwArchitecture) {
            self.advance();
        }

        if self.next_is_ident() {
            let t = self.advance();
            let end_name = self.get_text(t.span);

            if end_name != arch_name {
                return self.err(
                    ParseErrorKind::NameMismatch {
                        expected_span: arch_name_tok.span,
                        found_span: t.span,
                    },
                    t.span,
                );
            };
        }
        self.expect(TokenKind::Semicolon)?;
        dbg!("HERE");

        let arch = Architecture {
            name: arch_name,
            entity_name,
            decls_start: DeclId(decls_start),
            decls_end: DeclId(decls_end),
            stmts_start: StmtId(stmts_start),
            stmts_end: StmtId(stmts_end),
        };

        Ok(self.arena.alloc_architecture(arch))
    }
    fn parse_architecture_declaration(&mut self) -> ParseResult<()> {
        let start_tok = self.advance();

        dbg!(self.get_text(start_tok.span));
        match start_tok.kind {
            TokenKind::KwComponent => self.parse_component_declaration(),
            TokenKind::KwSignal => self.parse_scv_declaration(TokenKind::KwSignal),
            TokenKind::KwConstant => self.parse_scv_declaration(TokenKind::KwConstant),
            TokenKind::KwVariable => self.parse_scv_declaration(TokenKind::KwVariable),
            x => {
                exp_tks!(
                    x,
                    start_tok.span,
                    TokenKind::KwSignal,
                    TokenKind::KwConstant,
                    TokenKind::KwVariable
                );
            }
        }?;
        Ok(())
    }
    fn parse_concurrent_statement(&mut self) -> ParseResult<StmtId> {
        let first_token = self.advance();
        if first_token.kind == TokenKind::KwProcess {
            return self.parse_process(None);
        }

        if first_token.kind != TokenKind::Identifier {
            return self.err(
                ParseErrorKind::ExpectedToken {
                    expected: TokenKind::Identifier,
                    found: first_token.kind,
                },
                first_token.span,
            );
        }
        let identifier_name = self.get_text(first_token.span);

        let next_tok = self.advance();

        match next_tok.kind {
            TokenKind::OpSignalAssignOrLEq => {

                let expr_start = self.lexer.peek().map(|t| t.span.start).unwrap_or(0);
                let mut expr_end = expr_start;

                while let Some(tok) = self.lexer.peek() {
                    if tok.kind == TokenKind::Semicolon {
                        break;
                    }
                    expr_end = self.advance().span.end;
                }

                self.expect(TokenKind::Semicolon)?;

                let stmt = Stmt::ConcurrentAssignment {
                    target: identifier_name,
                    expression_span: Span {
                        start: expr_start,
                        end: expr_end,
                    },
                };

                Ok(self.arena.alloc_stmt(stmt))
            }

            // Either a label or a component instantiation
            TokenKind::Colon => {

                let after_colon = &self.lexer.peek().expect("Unexpected EOF after label").kind;

                if after_colon == &TokenKind::KwProcess {
                    self.advance(); // Consume 'process'
                    self.parse_process(Some(first_token.span))
                } else {
                    // For now, assume if it's a label but not a process, it's an instantiation TODO
                    self.parse_component_instantiation(identifier_name)
                }
            }
            _ => {
                exp_tks!(
                    first_token.kind,
                    first_token.span,
                    TokenKind::OpSignalAssignOrLEq,
                    TokenKind::Colon
                );
            }
        }
    }

    fn parse_component_declaration(&mut self) -> ParseResult<()> {
        let name_tok = self.expect(TokenKind::Identifier)?;
        let name = self.get_text(name_tok.span);
        let (ports_start, ports_end) = self.parse_port_clause()?;

        let decl = Decl::Component {
            name,
            ports_start,
            ports_end,
        };
        self.expect(TokenKind::KwEnd)?;

        //TODO only handles end component; for now

        self.expect(TokenKind::KwComponent)?;
        self.expect(TokenKind::Semicolon)?;

        self.arena.alloc_decl(decl);
        Ok(())
    }
    /// Only handles `signal identifier_1,identifier_n : subtype;`
    /// scv = signal, constant, variable
    fn parse_scv_declaration(&mut self, t: TokenKind) -> ParseResult<()> {
        let mut names = vec![];
        let name_tok = self.expect(TokenKind::Identifier)?;
        names.push(self.get_text(name_tok.span));
        // handle comma-separated signals
        while self.next_is(TokenKind::Comma) {
            self.advance();
            let name_tok = self.expect(TokenKind::Identifier)?;
            names.push(self.get_text(name_tok.span));
        }
        self.expect(TokenKind::Colon)?;

        let type_span =
            self.slice_until_depth_zero(&[TokenKind::Semicolon, TokenKind::OpAssign])?;
        let decl_type = self.get_text(type_span).trim();

        let mut default_val = None;
        if self.next_is(TokenKind::OpAssign) {
            self.advance();

            let expr_span = self.slice_until_depth_zero(&[TokenKind::Semicolon])?;
            default_val = Some(self.get_text(expr_span).trim());
        }

        self.expect(TokenKind::Semicolon)?;

        for name in names {
            let decl = match t {
                TokenKind::KwSignal => Decl::Signal {
                    name,
                    decl_type,
                    default_val,
                },
                TokenKind::KwVariable => Decl::Variable {
                    name,
                    decl_type,
                    default_val,
                },
                TokenKind::KwConstant => Decl::Constant {
                    name,
                    decl_type,
                    default_val,
                },
                _ => unreachable!("Token was already validated"),
            };
            self.arena.alloc_decl(decl);
        }

        Ok(())
    }
    fn parse_process(&mut self, label: Option<Span>) -> ParseResult<StmtId> {
        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::LParen) {
            self.advance();
            while let Some(tok) = self.lexer.peek() {
                if tok.kind == TokenKind::RParen {
                    break;
                }
                self.advance();
            }
            self.expect(TokenKind::RParen)?;
        }

        // TODO: optional process variables

        self.expect(TokenKind::KwBegin)?;

        let stmts_start = self.arena.stmts.len() as u32;

        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwEnd {
                break;
            }
            self.parse_sequential_statement()?;
        }

        let stmts_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd)?;

        // Handle optional "end process;" or "end process label;"
        if self.lexer.peek().map(|t| t.kind) == Some(TokenKind::KwProcess) {
            self.advance();
        }

        let mut l = None;

        if let Some(lbl) = label {
            if self.next_is_ident() {
                let t = self.advance();
                if self.get_text(t.span) != self.get_text(lbl) {
                    return self.err(
                        ParseErrorKind::NameMismatch {
                            expected_span: lbl,
                            found_span: t.span,
                        },
                        t.span,
                    );
                }
                l = Some(self.get_text(t.span))
            }
        }

        self.expect(TokenKind::Semicolon)?;

        let process_stmt = Stmt::Process {
            label:l,
            stmts_start: StmtId(stmts_start),
            stmts_end: StmtId(stmts_end),
        };

        Ok(self.arena.alloc_stmt(process_stmt))
    }
    fn parse_component_instantiation(&self, identifier_name: &str) -> ParseResult<StmtId> {
        todo!()
    }
    fn parse_sequential_statement(&mut self) -> ParseResult<StmtId> {
        match self.lexer.peek().map(|t| t.kind) {
            Some(TokenKind::KwIf) => self.parse_if_statement(),

            // TODO
            // TokenKind::KwCase => self.parse_case_statement(),
            // TokenKind::KwFor | TokenKind::KwWhile => self.parse_loop_statement(),
            Some(TokenKind::Identifier) => {
                // It's an assignment (either signal <= or variable :=)
                let name_tok = self.advance();
                let target = self.get_text(name_tok.span);

                
                let next_tok = self.advance();

                match next_tok.kind {
                    // Signal Assignment: target <= expr;
                    TokenKind::OpSignalAssignOrLEq => {
                        let expr_span = self.fast_forward_to_semicolon()?;

                        let stmt = Stmt::SequentialAssignment {
                            target,
                            expression_span: expr_span,
                        };
                        Ok(self.arena.alloc_stmt(stmt))
                    }

                    // Variable Assignment: target := expr;
                    TokenKind::OpAssign => {
                        let expr_span = self.fast_forward_to_semicolon()?;

                        let stmt = Stmt::VariableAssignment {
                            target,
                            expression_span: expr_span,
                        };
                        Ok(self.arena.alloc_stmt(stmt))
                    }
                    x => exp_tks!(x,name_tok.span,TokenKind::OpSignalAssignOrLEq,TokenKind::OpAssign),
                }
            }
            None => panic!("Unexpected EOF"),
            Some(tk) => panic!(
                "Syntax Error: Unexpected token {:?} in sequential statement",
                tk
            ),
        }
    }

    /// Discards tokens until we reach a semicolon or a major boundary.
    /// Returns true if it stopped on a semicolon (which we consume).
    fn recover_to_statement_boundary(&mut self) -> bool {
        while let Some(token) = self.lexer.peek() {
            match token.kind {
                TokenKind::Semicolon => {
                    self.lexer.next(); 
                    return true;
                }
                TokenKind::KwEnd 
                | TokenKind::KwBegin 
                | TokenKind::KwElsif 
                | TokenKind::KwElse 
                | TokenKind::Eof => {
                    return false;
                }
                _ => {
                    self.lexer.next(); 
                }
            }
        }
        false
    }

    fn recover_to_declaration_boundary(&mut self) {
        while let Some(token) = self.lexer.peek() {
            match token.kind {
                TokenKind::Semicolon => {
                    self.advance(); 
                    break;
                }
                TokenKind::KwBegin | TokenKind::KwEnd | TokenKind::Eof => {
                    break;
                }
                _ => {
                    self.advance(); 
                }
            }
        }
    }
    fn parse_if_statement(&mut self) -> ParseResult<StmtId> {
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
        self.expect(TokenKind::KwThen)?; // Consume 'then'

        let then_start = self.arena.stmts.len() as u32;
        while let Some(tok) = self.lexer.peek() {
            if tok.kind == TokenKind::KwElse || tok.kind == TokenKind::KwEnd {
                break;
            }
            self.parse_sequential_statement()?;
        }
        let then_end = self.arena.stmts.len() as u32;

        let elsifs_start = then_end;

        while self.next_is(TokenKind::KwElsif) {
            self.advance();
            // Restart from here
        }

        let else_start = self.arena.stmts.len() as u32;
        let mut has_else = false;

        if self.lexer.peek().map(|t| t.kind.clone()) == Some(TokenKind::KwElse) {
            self.advance(); // Consume 'else'
            has_else = true;

            while let Some(tok) = self.lexer.peek() {
                if tok.kind == TokenKind::KwEnd {
                    break;
                }
                self.parse_sequential_statement()?;
            }
        }
        let else_end = self.arena.stmts.len() as u32;

        self.expect(TokenKind::KwEnd)?;
        if self.lexer.peek().map(|t| t.kind.clone()) == Some(TokenKind::KwIf) {
            self.advance();
        }
        self.expect(TokenKind::Semicolon)?;

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
            elsifs_start: ElsifId(0),
            elsifs_end: ElsifId(0),
        };

        Ok(self.arena.alloc_stmt(if_stmt))
    }
}
