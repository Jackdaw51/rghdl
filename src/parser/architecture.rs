use std::ops::Range;

use super::Parser;
use crate::ast::{ConcStmtId, ConcurrentStmt, ElsifBranch, ElsifId, SeqStmtId, SequentialStmt};
use crate::exp_tks;

use crate::{
    ast::{Architecture, ArchitectureId, Decl, DeclId},
    lexer::{Span, TokenKind},
    parser::{ParseError, ParseErrorKind, ParseResult},
};

impl<'a> Parser<'a> {
    /// Parses sequential statements until it hits a boundary token (end, elsif, else).
    /// Accumulates IDs locally, then flushes them to the seq_stmt_lists.
    fn parse_sequential_block(&mut self) -> ParseResult<Range<u32>> {
        //saved ids of this local sequential block
        let mut local_ids = Vec::new();

        while self.not_eof() {
            let token_kind = self.lexer.peek().kind;
            
            if matches!(
                token_kind,
                TokenKind::KwEnd | TokenKind::KwElsif | TokenKind::KwElse
            ) {
                break;
            }

            // Parse the statement, fetch id and push it to the main array
            match self.parse_sequential_statement() {
                Ok(stmt) => {
                    let id = self.arena.alloc_seq_stmt(stmt);
                    local_ids.push(id);
                }
                Err(e) => {
                    self.errors.push(e);
                    self.recover_to_statement_boundary();
                }
            }
        }

        let start_idx = self.arena.seq_stmt_lists.len() as u32;
        self.arena.seq_stmt_lists.extend(local_ids);
        let end_idx = self.arena.seq_stmt_lists.len() as u32;

        //gives the indexes for seq_stmt_list, that contain this block's ids
        Ok(start_idx..end_idx)
    }
    pub(super) fn parse_architecture(&mut self) -> ParseResult<ArchitectureId> {
        self.advance();

        let arch_name_tok = self.expect(TokenKind::Identifier)?;
        let arch_name = self.get_text(arch_name_tok.span);

        self.expect(TokenKind::KwOf)?;

        let entity_name_tok = self.expect(TokenKind::Identifier)?;
        let entity_name = self.get_text(entity_name_tok.span);

        self.expect(TokenKind::KwIs)?;

        let decls_start = self.arena.decls.len() as u32;

        while !self.next_is(TokenKind::KwBegin) {
            if let Err(x) = self.parse_architecture_declaration() {
                self.errors.push(x);
                self.recover_to_declaration_boundary();
            };
        }

        let decls_end = self.arena.decls.len() as u32;

        self.expect(TokenKind::KwBegin)?;

        let mut local_conc_ids = Vec::new();

        while !self.next_is(TokenKind::KwEnd) {
            match self.parse_concurrent_statement() {
                Ok(stmt) => {
                    let id = ConcStmtId(self.arena.concurrent_stmts.len() as u32);
                    self.arena.concurrent_stmts.push(stmt);
                    local_conc_ids.push(id);
                }
                Err(x) => {
                    self.errors.push(x);
                    self.recover_to_statement_boundary();
                }
            };
        }

        let stmts_start = self.arena.conc_stmt_lists.len() as u32;
        self.arena.conc_stmt_lists.extend(local_conc_ids);
        let stmts_end = self.arena.conc_stmt_lists.len() as u32;
        
        self.expect(TokenKind::KwEnd)?;

        //same with entity, possible are "end [architecture] [my_architecture]";

        if self.next_is(TokenKind::KwArchitecture) {
            self.advance();
        }

        if self.next_is(TokenKind::Identifier) {
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
            stmts: stmts_start..stmts_end,
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
    fn parse_concurrent_statement(&mut self) -> ParseResult<ConcurrentStmt<'a>> {
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
                let expr_start = self.lexer.peek().span.start;
                let mut expr_end = expr_start;

                while !self.next_is(TokenKind::Semicolon) {
                    expr_end = self.advance().span.end;
                }

                self.expect(TokenKind::Semicolon)?;

                let stmt = ConcurrentStmt::ConcurrentAssignment {
                    target: identifier_name,
                    expression_span: Span {
                        start: expr_start,
                        end: expr_end,
                    },
                };

                Ok(stmt)
            }

            // Either a label or a component instantiation
            TokenKind::Colon => {
                let after_colon = self.lexer.peek().kind;

                if after_colon == TokenKind::KwProcess {
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
    fn parse_process(&mut self, label: Option<Span>) -> ParseResult<ConcurrentStmt<'a>> {

        let mut process_vars = None;

        if self.next_is(TokenKind::LParen) {
            let start = self.advance().span.start;
            while !self.next_is(TokenKind::RParen) {
                self.advance();
            }
            let end = self.expect(TokenKind::RParen)?.span.end;
            process_vars = Some(self.get_text(Span { start, end }));
        }

        // TODO: optional process variables


        

        self.expect(TokenKind::KwBegin)?;

        let stmts = self.parse_sequential_block()?;

        self.expect(TokenKind::KwEnd)?;
        
        // Handle optional "end process;" or "end process label;"
        if self.next_is(TokenKind::KwProcess) {
            self.advance();
        }

        let mut l = None;

        if let Some(lbl) = label {
            if self.next_is(TokenKind::Identifier) {
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
            }
            l = Some(self.get_text(lbl));
        }

        self.expect(TokenKind::Semicolon)?;

        Ok(ConcurrentStmt::Process { label: l, stmts, process_vars })
    }
    fn parse_component_instantiation(&self, identifier_name: &str) -> ParseResult<ConcurrentStmt<'a>> {
        todo!()
    }
    fn parse_sequential_statement(&mut self) -> ParseResult<SequentialStmt<'a>> {
        match self.lexer.peek().kind {
            TokenKind::KwIf => self.parse_if_statement(),

            // TODO
            // TokenKind::KwCase => self.parse_case_statement(),
            // TokenKind::KwFor | TokenKind::KwWhile => self.parse_loop_statement(),
            TokenKind::Identifier => {
                // It's an assignment (either signal <= or variable :=)
                let name_tok = self.advance();
                let target = self.get_text(name_tok.span);

                let next_tok = self.advance();

                match next_tok.kind {
                    // Signal Assignment: target <= expr;
                    TokenKind::OpSignalAssignOrLEq => {
                        let expression_span = self.fast_forward_to_semicolon()?;
                        Ok(SequentialStmt::SequentialAssignment { target, expression_span })
                    }

                    // Variable Assignment: target := expr;
                    TokenKind::OpAssign => {
                        let expression_span = self.fast_forward_to_semicolon()?;
                        Ok(SequentialStmt::VariableAssignment { target, expression_span })
                    }
                    x => exp_tks!(
                        x,
                        name_tok.span,
                        TokenKind::OpSignalAssignOrLEq,
                        TokenKind::OpAssign
                    ),
                }
            }
            TokenKind::Eof => panic!("Unexpected EOF"),
            tk => panic!(
                "Syntax Error: Unexpected token {:?} in sequential statement",
                tk
            ),
        }
    }

    /// Discards tokens until we reach a semicolon or a major boundary.
    /// Returns true if it stopped on a semicolon (which we consume).
    fn recover_to_statement_boundary(&mut self) -> bool {
        while self.not_eof() {
            let token = self.lexer.peek();
            match token.kind {
                TokenKind::Semicolon => {
                    self.advance();
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
                    self.advance();
                }
            }
        }
        false
    }

    fn recover_to_declaration_boundary(&mut self) {
        while self.not_eof() {
            let token = self.lexer.peek();
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
    fn parse_if_statement(&mut self) -> ParseResult<SequentialStmt<'a>> {
        self.advance(); // Consume if

        let cond_start = self.lexer.peek().span.start;
        let mut cond_end = cond_start;

        while !self.next_is(TokenKind::KwThen) {
            cond_end = self.advance().span.end;
        }
        let condition_span = Span {
            start: cond_start,
            end: cond_end,
        };
        self.expect(TokenKind::KwThen)?; // Consume 'then'

        let then_stmts = self.parse_sequential_block()?;

        let mut local_elsifs = Vec::new();
        

        while self.next_is(TokenKind::KwElsif) {
            dbg!("HERE");
            self.advance();

            let cond_start = self.lexer.peek().span.start;
            let mut cond_end = cond_start;
            while !self.next_is(TokenKind::KwThen) {
                cond_end = self.advance().span.end;
            }
            let condition_span = Span {
                start: cond_start,
                end: cond_end,
            };
            self.expect(TokenKind::KwThen)?;
            let stmts_range = self.parse_sequential_block()?;

            local_elsifs.push(ElsifBranch{ condition_span, stmts: stmts_range});
        }

        let elsifs_start = self.arena.elsifs.len() as u32;
        self.arena.elsifs.extend(local_elsifs);
        let elsifs = elsifs_start..(self.arena.elsifs.len() as u32);

        let else_stmts = if self.next_is(TokenKind::KwElse) {
            self.advance();
            self.parse_sequential_block()?
        } else {
            0..0
        };
        dbg!(else_stmts.clone());
        self.expect(TokenKind::KwEnd)?;
        if self.next_is(TokenKind::KwIf) {
            self.advance();
        }
        self.expect(TokenKind::Semicolon)?;

        Ok(SequentialStmt::If {
            condition_span,
            then_stmts,
            elsif_stmts:elsifs,
            else_stmts,
        })
    }
}
