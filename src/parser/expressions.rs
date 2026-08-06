use crate::parser::{
    ParseError, ParseResult, Parser,
    ast::{BinaryOp, Expr, ExprId, UnaryOp},
    lexer::{Span, TokenKind},
};

impl<'a> Parser<'a> {
    /// Entry point for parsing an expression.
    pub fn parse_expression(&mut self) -> Result<ExprId, ParseError> {
        self.parse_expr_bp(0) // Start with lowest binding power (0)
    }

    /// Pratt parsing loop
    fn parse_expr_bp(&mut self, min_bp: u8) -> Result<ExprId, ParseError> {
        // Parse the left side (Prefix)
        let mut lhs_id = self.parse_prefix()?;

        // Loop for Postfix and Infix operators
        loop {
            // postfix: Parentheses for Call / Index / Slice
            if self.next_is(TokenKind::LParen) {
                if 60 < min_bp {
                    break;
                }
                lhs_id = self.parse_postfix_call_or_slice(lhs_id)?;
                continue;
            }

            // postfix: Record Access (.field)
            if self.next_is(TokenKind::Dot) {
                if 60 < min_bp {
                    break;
                }
                self.advance();
                let field_tok = self.expect(TokenKind::Identifier)?;

                let start_span = self.arena.exprs[lhs_id.0 as usize].span();
                let full_span = Span {
                    start: start_span.start,
                    end: field_tok.span.end,
                };

                lhs_id = self.arena.alloc_expr(Expr::RecordAccess {
                    target: lhs_id,
                    field: self.get_text(field_tok.span),
                    span: full_span,
                });
                continue;
            }

            // Infix: Binary Operators
            let op = match self.peek_binary_operator() {
                Some(op) => op,
                None => break, // No more binary operators
            };

            let (l_bp, r_bp) = op.binding_power();

            if l_bp < min_bp {
                break;
            }

            // Consume operator
            self.advance();

            // Parse right-hand side recursively
            let rhs_id = self.parse_expr_bp(r_bp)?;

            let lhs_span = self.arena.exprs[lhs_id.0 as usize].span();
            let rhs_span = self.arena.exprs[rhs_id.0 as usize].span();

            let bin_expr = Expr::Binary {
                op,
                lhs: lhs_id,
                rhs: rhs_id,
                span: Span {
                    start: lhs_span.start,
                    end: rhs_span.end,
                },
            };

            lhs_id = self.arena.alloc_expr(bin_expr);
        }

        Ok(lhs_id)
    }

    fn parse_prefix(&mut self) -> Result<ExprId, ParseError> {
        let token = self.lexer.peek();
        match token.kind {
            TokenKind::Number | TokenKind::CharLit | TokenKind::StringLit => {
                let expr = Expr::Literal {
                    text: self.get_text(token.span),
                    span: token.span,
                };
                self.advance();
                Ok(self.alloc_expr(expr))
            }
            TokenKind::Identifier => {
                let expr = Expr::Identifier {
                    name: self.get_text(token.span),
                    span: token.span,
                };
                self.advance();
                Ok(self.alloc_expr(expr))
            }

            TokenKind::KwOthers => {
                let span = token.span;
                self.advance();
                Ok(self.alloc_expr(Expr::Others { span }))
            }

            // Grouping (Parentheses)
            TokenKind::LParen => {
                let start_span = token.span;
                self.advance();
                let start_idx = self.arena.expr_lists.len() as u32;

                // Loop to parse comma-separated expressions
                while !self.next_is(TokenKind::RParen) {
                    let expr = self.parse_expression()?;
                    self.arena.expr_lists.push(expr);

                    if self.next_is(TokenKind::Comma) {
                        self.advance();
                    } else {
                        break; // No comma, expect RParen next
                    }
                }

                let rparen_tok = self.expect(TokenKind::RParen)?;

                let span = Span {
                    start: start_span.start,
                    end: rparen_tok.span.end,
                };

                let end_idx = self.arena.expr_lists.len() as u32;

                let num_elements = end_idx - start_idx;

                // grouping vs aggregate
                if num_elements == 1 {
                    let expr_id = self.arena.expr_lists[start_idx as usize];
                    let is_assoc = matches!(
                        self.arena.exprs[expr_id.0 as usize],
                        Expr::Binary {
                            op: BinaryOp::Arrow,
                            ..
                        }
                    );

                    if !is_assoc {
                        // Since this is just a grouping, we don't need it to take up space
                        self.arena.expr_lists.truncate(start_idx as usize);
                        return Ok(self.alloc_expr(Expr::Grouping {
                            expr: expr_id,
                            span,
                        }));
                    }
                }

                // Otherwise, it's an Aggregate "`(others => '0')`" or "`('1', '0')`"
                Ok(self.alloc_expr(Expr::Aggregate {
                    elements: start_idx..end_idx,
                    span,
                }))
            }

            // Unary Operators (negative numbers, NOT)
            TokenKind::OpMinus | TokenKind::OpPlus | TokenKind::KwAbs | TokenKind::KwNot => {
                let op = match token.kind {
                    TokenKind::OpMinus => UnaryOp::Neg,
                    TokenKind::OpPlus => UnaryOp::Plus,
                    TokenKind::KwNot => UnaryOp::Not,
                    TokenKind::KwAbs => UnaryOp::Abs,
                    _ => unreachable!(),
                };
                self.advance();

                let right_expr = self.parse_expr_bp(50)?;

                let expr = Expr::Unary {
                    op,
                    expr: right_expr,
                    span: token.span,
                };
                Ok(self.alloc_expr(expr))
            }

            tk => {
                self.print_errors();
                panic!("{},{:?}", &&self.lexer.get_current_line(), tk)
            }
        }
    }

    /// Resolves either `target(15 downto 0)` (Slice) or `target(arg1, arg2)` (Call / Index)
    fn parse_postfix_call_or_slice(&mut self, target: ExprId) -> ParseResult<ExprId> {
        self.expect(TokenKind::LParen)?;

        //hold it on the stack
        let first_expr = self.parse_expression()?;

        // Check for Slice: `target(15 downto 0)` or `target(0 to 7)`
        if self.next_is(TokenKind::KwDownto) || self.next_is(TokenKind::KwTo) {
            let direction = self.advance().kind;
            let second_expr = self.parse_expression()?;
            let rparen_tok = self.expect(TokenKind::RParen)?;

            let target_span = self.arena.exprs[target.0 as usize].span();

            return Ok(self.arena.alloc_expr(Expr::Slice {
                target,
                direction,
                left: first_expr,
                right: second_expr,
                span: Span {
                    start: target_span.start,
                    end: rparen_tok.span.end,
                },
            }));
        }

        // Call or Index: `target(expr1, expr2)`
        let start_idx = self.arena.expr_lists.len() as u32;
        self.arena.expr_lists.push(first_expr);
        while self.next_is(TokenKind::Comma) {
            self.advance();
            let next_expr = self.parse_expression()?;
            self.arena.expr_lists.push(next_expr);
        }
        let rparen_tok = self.expect(TokenKind::RParen)?;
        let end_idx = self.arena.expr_lists.len() as u32;

        let target_span = self.arena.exprs[target.0 as usize].span();

        Ok(self.arena.alloc_expr(Expr::CallOrIndex {
            callee: target,
            args: start_idx..end_idx,
            span: Span {
                start: target_span.start,
                end: rparen_tok.span.end,
            },
        }))
    }

    /// Parses LHS of assignments: `a`, `a(0)`, `a(15 downto 8)`, `a.b`
    pub fn parse_target_expression(&mut self) -> ParseResult<ExprId> {
        let id_tok = self.expect(TokenKind::Identifier)?;
        let mut current_target = self.arena.alloc_expr(Expr::Identifier {
            span: id_tok.span,
            name: self.get_text(id_tok.span),
        });

        // Loop to consume postfix modifiers: array indices, slices, or record accesses
        while self.not_eof() {
            if self.next_is(TokenKind::LParen) {
                // `a(0)` or `a(15 downto 8)`
                current_target = self.parse_postfix_call_or_slice(current_target)?;
            } else if self.next_is(TokenKind::Dot) {
                // `record_name.field_name`
                self.advance();
                let field_tok = self.expect(TokenKind::Identifier)?;
                current_target = self.arena.alloc_expr(Expr::RecordAccess {
                    target: current_target,
                    field: self.get_text(field_tok.span),
                    span: field_tok.span,
                });
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

            // Named Association (`=>`) used in positional aggregates or port maps
            TokenKind::OpArrow => Some(BinaryOp::Arrow),

            _ => None,
        }
    }
    fn alloc_expr(&mut self, expr: Expr<'a>) -> ExprId {
        self.arena.alloc_expr(expr)
    }
}
