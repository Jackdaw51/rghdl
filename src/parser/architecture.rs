use std::ops::Range;

use super::Parser;
use crate::analyzer::SymbolId;
use crate::ast::{Association, ConcurrentStmt, ElsifBranch, Expr, ExprId, SequentialStmt};
use crate::exp_tks;
use crate::parser::{ParseResult, Token, TokenKind};

use crate::ast::{Architecture, ArchitectureId, Decl, DeclId};
use crate::printer::FormatCtx;
use crate::{parser::ParseErrorKind, parser::Span};

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

            let start = self.lexer.current_pos;
            // Parse the statement, fetch id and push it to the main array
            match self.parse_sequential_statement() {
                Ok(stmt) => {
                    let end = self.lexer.current_pos;
                    // println!("Sequential statement: \n{}",self.get_text(Span::new(start, end)));
                    let id = self.arena.alloc_seq_stmt(stmt, Span::new(start, end));
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
        let arch_name = self.intern(arch_name_tok.span);

        self.expect(TokenKind::KwOf)?;

        let entity_name_tok = self.expect(TokenKind::Identifier)?;
        let entity_name = self.intern(entity_name_tok.span);

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
            let start = self.lexer.current_pos;
            match self.parse_concurrent_statement() {
                Ok(stmt) => {
                    let end = self.lexer.current_pos;
                    let id = self.arena.alloc_conc_stmt(stmt, Span::new(start, end));
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
            let end_name = self.intern(t.span);

            if end_name != arch_name {
                return self.err(
                    ParseErrorKind::NameMismatch {
                        expected_symbol: arch_name,
                        found_symbol: end_name,
                    },
                    t.span,
                );
            };
        }
        self.expect(TokenKind::Semicolon)?;
        let arch = Architecture {
            name: arch_name,
            span: arch_name_tok.span,
            entity_name,
            decls_start: DeclId(decls_start),
            decls_end: DeclId(decls_end),
            stmts: stmts_start..stmts_end,
        };
        Ok(self.arena.alloc_architecture(arch))
    }
    fn parse_architecture_declaration(&mut self) -> ParseResult<()> {
        let start_tok = self.advance();

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
    fn parse_concurrent_statement(&mut self) -> ParseResult<ConcurrentStmt> {
        if self.lexer.peek().kind == TokenKind::KwProcess {
            self.advance();
            return self.parse_process(None);
        }

        let mut label = None;
        if self.next_is(TokenKind::Identifier) && self.lexer.peek_next().kind == TokenKind::Colon {
            let label_tok = self.advance();
            self.advance(); //colon
            label = Some(self.intern(label_tok.span));
            // label : process
            if self.next_is(TokenKind::KwProcess) {
                self.advance();
                return self.parse_process(label);
            }

            // u0: entity work.gate
            if self.next_is(TokenKind::KwEntity) {
                return self.parse_direct_entity_instantiation(label);
            }
        }

        let target_expr = self.parse_target_expression()?;

        let next_tok = self.advance();
        match next_tok.kind {
            // Concurrent Signal Assignment: target <= expr;
            TokenKind::OpSignalAssignOrLEq => {
                let rhs_expr = self.parse_expression()?;
                let after = if self.next_is(TokenKind::KwAfter) {
                    self.advance(); // consume `after`
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.expect(TokenKind::Semicolon)?;

                Ok(ConcurrentStmt::ConcurrentAssignment {
                    target: target_expr,
                    expression: rhs_expr,
                    label: label,
                    after,
                })
            }

            // Component Instantiation (`u1: my_component generic map(...) port map(...);`)
            // The Pratt parser parsed `my_component` as `target_expr` (Expr::Identifier).
            TokenKind::KwPort | TokenKind::KwGeneric => {
                self.parse_component_instantiation_body(target_expr, next_tok, label)
            }

            x => exp_tks!(
                x,
                next_tok.span,
                TokenKind::OpSignalAssignOrLEq,
                TokenKind::KwPort,
                TokenKind::KwGeneric
            ),
        }
    }
    fn parse_component_declaration(&mut self) -> ParseResult<()> {
        let name_tok = self.expect(TokenKind::Identifier)?;
        let name = self.intern(name_tok.span);

        if self.next_is(TokenKind::KwIs) {
            self.advance();
        }

        let (ports_start, ports_end) = self.parse_port_clause()?;

        let decl = Decl::Component {
            name,
            ports_start,
            ports_end,
        };

        self.expect(TokenKind::KwEnd)?;

        if self.next_is(TokenKind::KwComponent) {
            self.advance();
        }
        if self.next_is(TokenKind::Identifier) {
            let t = self.advance();
            let end_name = self.intern(t.span);

            if end_name != name {
                return self.err(
                    ParseErrorKind::NameMismatch {
                        expected_symbol: name,
                        found_symbol: end_name,
                    },
                    t.span,
                );
            };
        }

        self.expect(TokenKind::Semicolon)?;

        self.arena.alloc_decl(decl, name_tok.span);
        Ok(())
    }
    /// Only handles `signal identifier_1,identifier_n : subtype;`
    /// scv = signal, constant, variable
    fn parse_scv_declaration(&mut self, token_kind: TokenKind) -> ParseResult<()> {
        let mut names = vec![];
        let name_tok = self.expect(TokenKind::Identifier)?;
        names.push(name_tok.span);
        // handle comma-separated signals
        while self.next_is(TokenKind::Comma) {
            self.advance();
            let name_tok = self.expect(TokenKind::Identifier)?;
            names.push(name_tok.span);
        }
        self.expect(TokenKind::Colon)?;

        let decl_type_span =
            self.slice_until_depth_zero(&[TokenKind::Semicolon, TokenKind::OpAssign])?;
        let decl_type = self.intern(decl_type_span);

        let mut default_val = None;
        if self.next_is(TokenKind::OpAssign) {
            self.advance();
            default_val = Some(self.parse_expression()?);
        }

        self.expect(TokenKind::Semicolon)?;

        for name_span in names {
            let name = self.intern(name_span);
            let decl = match token_kind {
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
            self.arena.alloc_decl(decl, name_span);
        }

        Ok(())
    }
    fn parse_process(&mut self, label: Option<SymbolId>) -> ParseResult<ConcurrentStmt> {
        let mut sens_list: Option<Range<u32>> = None;

        if self.next_is(TokenKind::LParen) {
            self.advance();
            let mut local_sens = Vec::new();

            while !self.next_is(TokenKind::RParen) && self.not_eof() {
                let expr_id = self.parse_target_expression()?;
                local_sens.push(expr_id);

                if self.next_is(TokenKind::Comma) {
                    self.advance();
                } else {
                    break;
                }
            }
            self.expect(TokenKind::RParen)?;

            let start = self.arena.expr_lists.len() as u32;
            self.arena.expr_lists.extend(local_sens);
            let end = self.arena.expr_lists.len() as u32;

            sens_list = Some(start..end);
        }
        //Optional is
        if self.next_is(TokenKind::KwIs) {
            self.advance();
        };

        while !self.next_is(TokenKind::KwBegin) && self.not_eof() {
            self.advance();
            self.parse_scv_declaration(TokenKind::KwVariable)?;
        }
        self.expect(TokenKind::KwBegin)?;

        let stmts = self.parse_sequential_block()?;

        self.expect(TokenKind::KwEnd)?; //end

        // Handle optional "end process;" or "end process label;"
        if self.next_is(TokenKind::KwProcess) {
            self.advance();
        }

        let mut l = None;

        if let Some(lbl) = label {
            if self.next_is(TokenKind::Identifier) {
                let t = self.advance();
                let found = self.intern(t.span);
                if found != lbl {
                    return self.err(
                        ParseErrorKind::NameMismatch {
                            expected_symbol: lbl,
                            found_symbol: found,
                        },
                        t.span,
                    );
                }
            }
            l = Some(lbl);
        }

        self.expect(TokenKind::Semicolon)?;

        Ok(ConcurrentStmt::Process {
            label: l,
            stmts,
            sens_list,
        })
    }
    fn parse_sequential_statement(&mut self) -> ParseResult<SequentialStmt> {
        match self.lexer.peek().kind {
            TokenKind::KwIf => self.parse_if_statement(),

            // TODO
            // TokenKind::KwCase => self.parse_case_statement(),
            // TokenKind::KwFor | TokenKind::KwWhile => self.parse_loop_statement(),

            // If it's not a control-flow keyword, parse the target expression first
            _ => {
                // Parses bare identifiers ('clk'), indexed arrays ('arr(0)'), or procedure calls ('reset(clk)')
                let target_expr = self.parse_target_expression()?;

                
                let next_tok = self.advance();
                match next_tok.kind {
                    // Signal Assignment: target <= expr;
                    TokenKind::OpSignalAssignOrLEq => {
                        
                        self.print_expr(target_expr);
                        let expression = self.parse_expression()?;
                        self.print_expr(expression);
                        let after = if self.next_is(TokenKind::KwAfter) {
                            self.advance(); // consume `after`
                            Some(self.parse_expression()?)
                        } else {
                            None
                        };
                        self.expect(TokenKind::Semicolon)?;
                        Ok(SequentialStmt::SequentialAssignment {
                            target: target_expr,
                            expression,
                            after,
                        })
                    }

                    // Variable Assignment: target := expr;
                    TokenKind::OpAssign => {
                        let expression = self.parse_expression()?;
                        self.expect(TokenKind::Semicolon)?;
                        Ok(SequentialStmt::VariableAssignment {
                            expression,
                            target: target_expr,
                        })
                    }

                    // Procedure Call: my_procedure(args);
                    TokenKind::Semicolon => Ok(SequentialStmt::ProcedureCall { call: target_expr }),

                    x => exp_tks!(
                        x,
                        next_tok.span,
                        TokenKind::OpSignalAssignOrLEq,
                        TokenKind::OpAssign,
                        TokenKind::Semicolon
                    ),
                }
            }
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
    fn parse_if_statement(&mut self) -> ParseResult<SequentialStmt> {
        self.advance();

        let condition = self.parse_expression()?;
        self.expect(TokenKind::KwThen)?;

        let then_stmts = self.parse_sequential_block()?;

        let mut local_elsifs = Vec::new();

        while self.next_is(TokenKind::KwElsif) {
            self.advance();

            let condition = self.parse_expression()?;
            self.expect(TokenKind::KwThen)?;
            let stmts_range = self.parse_sequential_block()?;

            local_elsifs.push(ElsifBranch {
                condition,
                stmts: stmts_range,
            });
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
        self.expect(TokenKind::KwEnd)?;
        if self.next_is(TokenKind::KwIf) {
            self.advance();
        }
        self.expect(TokenKind::Semicolon)?;

        Ok(SequentialStmt::If {
            condition,
            then_stmts,
            elsif_stmts: elsifs,
            else_stmts,
        })
    }

    /// Parses a direct entity `label: entity library_name.entity_name(arch_name) port map (...);`
    /// A direct entity is the instantiation that directly targets a compiled entity in a design library
    fn parse_direct_entity_instantiation(
        &mut self,
        label: Option<SymbolId>,
    ) -> ParseResult<ConcurrentStmt> {
        self.expect(TokenKind::KwEntity)?;

        let component_name = self.parse_expression()?;

        todo!("Check if the arch qualifier is handled correctly");

        // Handles optional architecture qualifier: entity work.gate(rtl)
        let arch_qualifier = if self.next_is(TokenKind::LParen) {
            self.advance();
            let arch_tok = self.expect(TokenKind::Identifier)?;
            self.expect(TokenKind::RParen)?;
            Some(self.intern(arch_tok.span))
        } else {
            None
        };

        // Optional generic map
        let generic_map = if self.next_is(TokenKind::KwGeneric) {
            self.advance();
            self.expect(TokenKind::KwMap)?;
            self.parse_association_list()?
        } else {
            0..0
        };

        // Mandatory port map
        self.expect(TokenKind::KwPort)?;
        self.expect(TokenKind::KwMap)?;
        let port_map = self.parse_association_list()?;
        self.expect(TokenKind::Semicolon)?;

        Ok(ConcurrentStmt::ComponentInstantiation {
            label,
            component_name,
            arch_qualifier,
            generic_map,
            port_map,
        })
    }

    fn parse_association_list(&mut self) -> ParseResult<Range<u32>> {
        self.expect(TokenKind::LParen)?;
        let start_idx = self.arena.associations.len() as u32;

        while !self.next_is(TokenKind::RParen) && self.not_eof() {
            let first_expr = self.parse_target_expression()?;

            let assoc = if self.next_is(TokenKind::OpArrow) {
                self.advance(); // consume '=>'
                let actual = self.parse_expression()?;
                Association {
                    formal: Some(first_expr),
                    actual,
                }
            } else {
                // Positional mapping
                Association {
                    formal: None,
                    actual: first_expr,
                }
            };
            // dbg!(assoc.clone(), self.arena.expr(first_expr));
            self.arena.associations.push(assoc);

            if self.next_is(TokenKind::Comma) {
                self.advance();
            } else {
                break;
            }
        }

        self.expect(TokenKind::RParen)?;
        let end_idx = self.arena.associations.len() as u32;

        Ok(start_idx..end_idx)
    }

    fn parse_component_instantiation_body(
        &mut self,
        component_name: ExprId,
        first_tok: Token,
        label: Option<SymbolId>,
    ) -> ParseResult<ConcurrentStmt> {
        let mut generic_map = 0..0;

        if first_tok.kind == TokenKind::KwGeneric {
            self.expect(TokenKind::KwMap)?;
            generic_map = self.parse_association_list()?;

            // After generic map, port map is required in component instantiations
            self.expect(TokenKind::KwPort)?;
        } else if first_tok.kind != TokenKind::KwPort {
            exp_tks!(
                first_tok.kind,
                first_tok.span,
                TokenKind::KwPort,
                TokenKind::KwGeneric
            );
        }

        // Required port map (KwPort was either consumed above or passed as first_tok)
        self.expect(TokenKind::KwMap)?;
        let port_map = self.parse_association_list()?;
        self.expect(TokenKind::Semicolon)?;

        Ok(ConcurrentStmt::ComponentInstantiation {
            label,
            component_name,
            arch_qualifier: None, // Standard component instantiations do not specify architectures directly
            generic_map,
            port_map,
        })
    }

    pub(crate) fn print_expr(&self, expr_id: ExprId) {
        let f = FormatCtx {
            item: self.arena.expr(expr_id),
            source: self.source,
            symbols: self.interner,
            arena: &self.arena,
            indent: 0,
        };
        println!("{f}");
    }
}
