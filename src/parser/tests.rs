use crate::parser::{
    Parser,
    ast::{BinaryOp, Expr},
    TokenKind,
};

#[test]
fn test_pratt_target_vs_assign() {
    let mut parser = Parser::new("rom_addr <= to_integer(phase_acc(15 downto 8));");
    let target = parser.parse_target_expression().unwrap();

    // Assert target is strictly Identifier("rom_addr"), NOT a Binary LEq expression
    dbg!(&parser.arena.exprs[target.0 as usize].span());
    assert!(matches!(
        parser.arena.exprs[target.0 as usize],
        Expr::Identifier {
            name: "rom_addr",
            span: _
        }
    ));
    assert_eq!(parser.lexer.peek().kind, TokenKind::OpSignalAssignOrLEq);
}
fn setup_parser(source: &str) -> Parser<'_> {
    Parser::new(source)
}
#[test]
fn test_operator_precedence() {
    let source = "a + b * c;";
    let mut parser = setup_parser(source);

    
    let expr_id = parser
    .parse_expression()
    .expect("Failed to parse expression");
    dbg!(parser.arena.clone());
    let expr = &parser.arena.exprs[expr_id.0 as usize];

    match expr {
        Expr::Binary {
            op: BinaryOp::Add,
            lhs,
            rhs,
            ..
        } => {
            let left_node = &parser.arena.exprs[lhs.0 as usize];
            let right_node = &parser.arena.exprs[rhs.0 as usize];

            assert!(matches!(left_node, Expr::Identifier { name: "a", .. }));
            assert!(
                matches!(
                    right_node,
                    Expr::Binary {
                        op: BinaryOp::Mul,
                        ..
                    }
                ),
                "Expected RHS to be a multiplication expression"
            );
        }
        _ => panic!("Expected root expression to be Addition"),
    }
}

#[test]
fn test_complex_postfix_chain() {
    // accessing a specific bit of a sliced array inside a record
    let source = "my_record.bus(15 downto 8)(3)";
    let mut parser = setup_parser(source);

    let target_id = parser
        .parse_target_expression()
        .expect("Failed to parse target");

    // Unroll the AST from the outside in
    // The outermost node should be the index `(3)`
    let call_expr = &parser.arena.exprs[target_id.0 as usize];
    let callee_id = match call_expr {
        Expr::CallOrIndex { callee, .. } => *callee,
        _ => panic!("Expected outermost node to be CallOrIndex"),
    };

    // The next node down should be the slice `(15 downto 8)`
    let slice_expr = &parser.arena.exprs[callee_id.0 as usize];
    let slice_target_id = match slice_expr {
        Expr::Slice {
            target,
            direction: TokenKind::KwDownto,
            ..
        } => *target,
        _ => panic!("Expected middle node to be a Slice with Downto"),
    };

    // The innermost node should be the record access `.bus`
    let record_expr = &parser.arena.exprs[slice_target_id.0 as usize];
    match record_expr {
        Expr::RecordAccess { field, .. } => assert_eq!(*field, "bus"),
        _ => panic!("Expected innermost node to be RecordAccess"),
    }
}

#[test]
fn test_target_vs_assignment_regression() {
    let source = "rom_addr <= base + offset;";
    let mut parser = setup_parser(source);

    // Parse the LHS
    let target_id = parser
        .parse_target_expression()
        .expect("Failed to parse target");
    assert!(matches!(
        parser.arena.exprs[target_id.0 as usize],
        Expr::Identifier {
            name: "rom_addr",
            ..
        }
    ));

    // Check the assignment operator
    let assign_tok = parser.advance();
    assert_eq!(assign_tok.kind, TokenKind::OpSignalAssignOrLEq);

    // Parse the RHS
    let value_id = parser
        .parse_expression()
        .expect("Failed to parse expression");
    assert!(matches!(
        parser.arena.exprs[value_id.0 as usize],
        Expr::Binary {
            op: BinaryOp::Add,
            ..
        }
    ));

    assert_eq!(parser.advance().kind, TokenKind::Semicolon);
}
