use crate::ast::{BinaryOp, Expr, ExprId, UnaryOp};
use crate::exp_tks;
use crate::parser::{ParseError, ParseErrorKind, ParseResult, Parser, Span, TokenKind};

impl<'a> Parser<'a> {
    /// Entry point for parsing an expression.
    pub fn parse_expression(&mut self) -> Result<ExprId, ParseError> {
        self.parse_expr_bp(0) // Start with lowest binding power (0)
    }

    /// Pratt parsing loop
    fn parse_expr_bp(&mut self, min_bp: u8) -> Result<ExprId, ParseError> {
        // Example a + b * c

        let start = self.lexer.current_pos;

        // Parse the left side (Prefix)
        // returns ExprId of a, now ' + b * c '
        let mut lhs_id = self.parse_prefix()?;

        // c + a.b

        // Loop for Postfix and Infix operators
        loop {
            let op = match self.peek_binary_operator() {
                Some(op) => op,
                None => break, // No more binary operators
            };

            let (l_bp, r_bp) = op.binding_power();

            if min_bp > l_bp {
                break;
            }

            let tok = self.advance();

            lhs_id = match tok.kind {
                TokenKind::LParen => self.parse_postfix_call_or_slice(lhs_id)?,
                TokenKind::Dot => self.parse_postfix_record_access(lhs_id)?,
                _ => {
                    let rhs_id = self.parse_expr_bp(r_bp)?;

                    let bin_expr = Expr::Binary {
                        op,
                        lhs: lhs_id,
                        rhs: rhs_id,
                    };
                    let end = self.lexer.current_pos;
                    self.alloc_expr(bin_expr, Span::new(start, end))
                }
            }
        }

        Ok(lhs_id)
    }

    fn parse_prefix(&mut self) -> Result<ExprId, ParseError> {
        let token = self.lexer.peek();
        match token.kind {
            TokenKind::Number => {
                let num_span = token.span;
                self.advance();
                let name = self.intern(num_span);

                let num_expr = self.alloc_expr(Expr::Literal { name }, num_span);

                // VHDL physical literals consist of a number followed by a unit identifier
                if self.next_is(TokenKind::Identifier) {
                    let unit_tok = self.advance();
                    let unit = self.intern(unit_tok.span);

                    Ok(self.alloc_expr(
                        Expr::PhysicalLiteral {
                            value: num_expr,
                            unit,
                        },
                        unit_tok.span,
                    ))
                } else {
                    Ok(num_expr)
                }
            }
            TokenKind::CharLit | TokenKind::StringLit | TokenKind::BitStringLit => {
                let expr = Expr::Literal {
                    name: self.intern(token.span),
                };
                self.advance();
                Ok(self.alloc_expr(expr, token.span))
            }
            TokenKind::Identifier => {
                let name = self.intern(token.span);
                let expr = Expr::Identifier { name };
                self.advance();
                Ok(self.alloc_expr(expr, token.span))
            }
            TokenKind::KwAll => {
                self.advance();
                Ok(self.alloc_expr(Expr::All, token.span))
            }

            TokenKind::KwOthers => {
                self.advance();
                Ok(self.alloc_expr(Expr::Others, token.span))
            }

            // Grouping (Parentheses)
            TokenKind::LParen => {
                self.advance();
                let start = self.lexer.current_pos;
                self.arena.expr_lists.len() as u32;

                let mut elements = Vec::new();

                // Loop to parse comma-separated expressions
                while !self.next_is(TokenKind::RParen) {
                    let expr = self.parse_expression()?;
                    elements.push(expr);
                    if self.next_is(TokenKind::Comma) {
                        self.advance();
                    } else {
                        break; // No comma, expect RParen next
                    }
                }

                let end = self.lexer.current_pos;

                self.expect(TokenKind::RParen)?;

                // grouping vs aggregate
                if elements.len() == 1 {
                    let expr_id = elements[0];
                    let is_assoc = matches!(
                        self.arena.exprs[expr_id.0 as usize],
                        Expr::Binary {
                            op: BinaryOp::Arrow,
                            ..
                        }
                    );

                    if !is_assoc {
                        // grouping does not reqire expr_list
                        return Ok(self
                            .alloc_expr(Expr::Grouping { expr: expr_id }, Span::new(start, end)));
                    }
                }

                // Otherwise, it's an Aggregate "`(others => '0')`" or "`('1', '0')`"
                let start_idx = self.arena.expr_lists.len() as u32;
                self.arena.expr_lists.extend(elements);
                let end_idx = self.arena.expr_lists.len() as u32;

                Ok(self.alloc_expr(
                    Expr::Aggregate {
                        elements: start_idx..end_idx,
                    },
                    Span::new(start, end),
                ))
            }

            TokenKind::KwNot | TokenKind::KwAbs => {
                let op = match token.kind {
                    TokenKind::KwNot => UnaryOp::Not,
                    TokenKind::KwAbs => UnaryOp::Abs,
                    _ => unreachable!(),
                };
                let start = self.lexer.current_pos;
                self.advance();
                let right_expr = self.parse_expr_bp(60)?;
                Ok(self.alloc_expr(
                    Expr::Unary {
                        op,
                        expr: right_expr,
                    },
                    Span {
                        start,
                        end: self.lexer.current_pos,
                    },
                ))
            }

            TokenKind::OpMinus | TokenKind::OpPlus => {
                let op = match token.kind {
                    TokenKind::OpMinus => UnaryOp::Neg,
                    TokenKind::OpPlus => UnaryOp::Plus,
                    _ => unreachable!(),
                };
                let start = self.lexer.current_pos;
                self.advance();
                // Sign level precedence: 40 (Lower than multiplying 50, higher than adding 30)
                let right_expr = self.parse_expr_bp(40)?;
                let end = self.lexer.current_pos;
                Ok(self.alloc_expr(
                    Expr::Unary {
                        op,
                        expr: right_expr,
                    },
                    Span::new(start, end),
                ))
            }

            tk => {
                self.print_errors();
                panic!(
                    "line {}, {:?}, {:?}",
                    &&self.lexer.get_current_line(),
                    tk,
                    token.span
                )
            }
        }
    }

    /// Resolves either `target(15 downto 0)` (Slice) or `target(arg1, arg2)` (Call / Index)
    fn parse_postfix_call_or_slice(&mut self, target: ExprId) -> ParseResult<ExprId> {
        //hold it on the stack
        let start = self.lexer.current_pos;
        let first_expr = self.parse_expression()?;

        // Check for Slice: `target(15 downto 0)` or `target(0 to 7)`
        if self.next_is(TokenKind::KwDownto) || self.next_is(TokenKind::KwTo) {
            let direction = self.advance().kind;
            let second_expr = self.parse_expression()?;
            let end = self.lexer.current_pos - 1;
            self.expect(TokenKind::RParen)?;
            
            return Ok(self.alloc_expr(
                Expr::Slice {
                    target,
                    direction,
                    left: first_expr,
                    right: second_expr,
                },
                Span::new(start, end),
            ));
        }
        
        let mut args = Vec::new();
        args.push(first_expr);
        while self.next_is(TokenKind::Comma) {
            self.advance();
            args.push(self.parse_expression()?);
        }
        self.expect(TokenKind::RParen)?;

        let start_idx = self.arena.expr_lists.len() as u32;
        self.arena.expr_lists.extend(args);
        let end_idx = self.arena.expr_lists.len() as u32;

        let end = self.lexer.current_pos - 1;

        Ok(self.alloc_expr(
            Expr::CallOrIndex {
                callee: target,
                args: start_idx..end_idx,
            },
            Span::new(start, end),
        ))
    }

    /// Parses LHS of assignments: `a`, `a(0)`, `a(15 downto 8)`, `a.b`
    pub fn parse_target_expression(&mut self) -> ParseResult<ExprId> {
        let id_tok = self.expect(TokenKind::Identifier)?;
        let name = self.intern(id_tok.span);
        let mut current_target = self
            .arena
            .alloc_expr(Expr::Identifier { name }, id_tok.span);

        // Loop to consume postfix modifiers: array indices, slices, or record accesses
        while self.not_eof() {
            if self.next_is(TokenKind::LParen) {
                // `a(0)` or `a(15 downto 8)`
                self.advance();
                current_target = self.parse_postfix_call_or_slice(current_target)?;
            } else if self.next_is(TokenKind::Dot) {
                self.advance();

                let tok = self.lexer.peek();
                let field = match tok.kind {
                    TokenKind::Identifier | TokenKind::KwAll => {
                        let name = self.intern(tok.span);
                        self.advance();
                        name
                    }
                    _ => exp_tks!(tok.kind, tok.span, TokenKind::Identifier, TokenKind::KwAll),
                };
                current_target = self.alloc_expr(
                    Expr::RecordAccess {
                        target: current_target,
                        field,
                    },
                    tok.span,
                );
            } else {
                break;
            }
        }
        Ok(current_target)
    }

    /// Checks if the current token is a binary operator.
    /// Does NOT advance the parser (the Pratt loop handles that).
    pub fn peek_binary_operator(&mut self) -> Option<BinaryOp> {
        match self.lexer.peek().kind {
            // Relational
            TokenKind::OpEq => Some(BinaryOp::Eq),
            TokenKind::OpNeq => Some(BinaryOp::Neq),
            TokenKind::OpLt => Some(BinaryOp::Lt),
            TokenKind::OpGt => Some(BinaryOp::Gt),
            TokenKind::OpGeq => Some(BinaryOp::Gte),
            TokenKind::OpSignalAssignOrLEq => Some(BinaryOp::Lte),

            // Arithmetic
            TokenKind::OpPlus => Some(BinaryOp::Add),
            TokenKind::OpMinus => Some(BinaryOp::Sub),
            TokenKind::OpStar => Some(BinaryOp::Mul),
            TokenKind::OpSlash => Some(BinaryOp::Div),

            // Logical
            TokenKind::KwAnd => Some(BinaryOp::And),
            TokenKind::KwOr => Some(BinaryOp::Or),
            TokenKind::KwXor => Some(BinaryOp::Xor),
            TokenKind::KwNand => Some(BinaryOp::Nand),
            TokenKind::KwNor => Some(BinaryOp::Nor),
            TokenKind::OpConcat => Some(BinaryOp::Concat),

            // Named Association (`=>`) used in positional aggregates or port maps
            TokenKind::OpArrow => Some(BinaryOp::Arrow),
            TokenKind::Dot => Some(BinaryOp::RecordAccess),
            TokenKind::LParen => Some(BinaryOp::CallOrIndex),

            _ => None,
        }
    }
    fn alloc_expr(&mut self, expr: Expr, span: Span) -> ExprId {
        self.arena.alloc_expr(expr, span)
    }

    fn parse_postfix_record_access(&mut self, lhs_id: ExprId) -> ParseResult<ExprId> {
        let tok = self.lexer.peek();
        let field_name = match tok.kind {
            TokenKind::Identifier | TokenKind::KwAll => {
                let name = self.intern(tok.span);
                self.advance();
                name
            }
            _ => exp_tks!(tok.kind, tok.span, TokenKind::Identifier, TokenKind::KwAll),
        };

        Ok(self.alloc_expr(
            Expr::RecordAccess {
                target: lhs_id,
                field: field_name,
            },
            tok.span,
        ))
    }
}
mod tests {
    use crate::{analyzer::SymbolInterner, ast::ExprId, parser::Parser, printer::FormatCtx};

    #[test]
    fn complex_expr() {
        let mut interner = SymbolInterner::default();
        // let source = "mask /= x\"00\"";
        // let source = "not abs -rec.data_buf(idx * 2 + 1)(7 downto 0) + 16#FF# = (others => '0') and (config.lut(addr + 42) *- 3.14 / val + abs val) >= (b\"10101010\" + '1') or not (status_reg.flags(i) and mask /= x\"00\")";
        // let source = "(others => '0') and (config.lut(addr + 42) *- 3.14 / val + abs val) >= (b\"10101010\" + '1') or not (status_reg.flags(i) and mask /= x\"00\")";
        // let source = "(config.lut(addr + 42) *- 3.14 / val + abs val) >= (b\"10101010\" + '1') or not (status_reg.flags(i) and mask /= x\"00\")";
        // let source = "(b\"10101010\" + '1') or not (status_reg.flags(i) and mask /= x\"00\")";
        // let source = "status_reg.flags(i) and mask /= x\"00\"";
        // let source = "status_reg.flags(i)";
        let source = "peak_freq_hz & peak_freq_tenths & std_logic_vector(to_unsigned(second_counter, 12))";
        let mut parser = Parser::new(source, &mut interner);
        let a = parser.parse_expression();

        match a {
            Ok(x) => {
                parser.print_expr(x);
            }
            Err(x) => panic!("{:?}", x),
        }
        for item in &parser.arena.exprs {
            let a = FormatCtx {
                item,
                source,
                symbols: parser.interner,
                arena: &parser.arena,
                indent: 0,
            };
            println!("{a}");
        }
    }
}
