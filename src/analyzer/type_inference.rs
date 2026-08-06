use std::ops::Range;

use crate::{
    analyzer::{
        SemanticAnalyzer, SemanticError, SemanticErrorKind,
        types::{TypeId, TypeKind},
    },
    parser::{
        ast::{BinaryOp, Expr, ExprId, UnaryOp},
        lexer::Span,
    },
};

impl<'a> SemanticAnalyzer<'a> {
    pub fn infer_expr_type(
        &mut self,
        expr_id: ExprId,
        expected_type: Option<TypeId>,
    ) -> Result<TypeId, SemanticError> {
        let expr = self.ast.exprs[expr_id.0 as usize].clone();

        match expr {
            Expr::Identifier { name, span } => self.infer_identifier(&name, span),
            Expr::Literal { text, span } => self.infer_literal(&text, expected_type, span),
            Expr::Unary { op, expr, span } => self.infer_unary(op, expr, expected_type, span),
            Expr::Binary { op, lhs, rhs, span } => {
                self.infer_binary(op, lhs, rhs, expected_type, span)
            }
            Expr::Grouping { expr, .. } => self.infer_expr_type(expr, expected_type),
            Expr::CallOrIndex { callee, args, span } => {
                self.infer_call_or_index(callee, &args, span)
            }
            Expr::Aggregate { elements, span } => {
                self.infer_aggregate(elements, expected_type, span)
            }
            Expr::Others { span } => self.infer_others(expected_type, span),
            Expr::Slice {
                target,
                direction: _,
                left,
                right,
                span,
            } => self.infer_slice(expected_type, target, left, right, span),
            Expr::RecordAccess {
                target,
                field,
                span,
            } => self.infer_record_access(target, field, span),
        }
    }

    fn infer_record_access(
        &mut self,
        target: ExprId,
        field: &str,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        let target_ty = self.infer_expr_type(target, None)?;

        match self.types.get(target_ty) {
            Some(TypeKind::Record { fields, name }) => {
                let field_sym = self.symbols.interner.get_or_internalize(&field);
                fields
                    .get(&field_sym)
                    .copied()
                    .ok_or_else(|| SemanticError {
                        kind: SemanticErrorKind::UnknownRecordField(field.to_string()),
                        span,
                    })
            }
            _ => Err(SemanticError {
                kind: SemanticErrorKind::NotARecord,
                span,
            }),
        }
    }

    fn infer_slice(
        &mut self,
        expected_type: Option<TypeId>,
        target: ExprId,
        left: ExprId,
        right: ExprId,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        let target_ty = self.infer_expr_type(target, expected_type)?;

        // Index bounds must evaluate to an integer or discrete type
        let _ = self.infer_expr_type(left, Some(self.type_integer));
        let _ = self.infer_expr_type(right, Some(self.type_integer));

        // Slicing an array (`signal(7 downto 0)`) produces the same array type
        match self.types.get(target_ty) {
            Some(TypeKind::Array { .. }) => Ok(target_ty),
            _ => Err(SemanticError {
                kind: SemanticErrorKind::CannotSliceNonArray,
                span,
            }),
        }
    }

    fn infer_identifier(&mut self, name: &str, span: Span) -> Result<TypeId, SemanticError> {
        let sym = self.symbols.interner.get_or_internalize(name);

        if let Some(decl_ref) = self.symbols.lookup(self.current_scope, sym) {
            let ty = self.get_decl_type(decl_ref);

            if ty != TypeId::ERROR {
                Ok(ty)
            } else {
                // The symbol exists, but its underlying type is broken/unresolved.
                Err(SemanticError {
                    kind: SemanticErrorKind::UnknownType(name.into()),
                    span,
                })
            }
        } else {
            // The symbol was never declared in this scope at all.
            Err(SemanticError {
                kind: SemanticErrorKind::UndefinedSymbol(name.into()),
                span,
            })
        }
    }

    fn infer_literal(
        &mut self,
        text: &str,
        expected_type: Option<TypeId>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        // String / Bit-String Literals: "1010", x"FF", b"11"
        if text.starts_with('"') || text.contains('"') {
            if let Some(expected) = expected_type {
                if matches!(self.types.get(expected), Some(TypeKind::Array { .. })) {
                    return Ok(expected);
                }
            }
            return Ok(self.type_std_logic_vector);
        }

        // Character Literals: '0', '1', 'Z', 'X'
        if text.starts_with('\'') && text.ends_with('\'') {
            if let Some(expected) = expected_type {
                return Ok(expected);
            }
            return Ok(self.type_std_logic);
        }

        // Real / Floating Point Literals: 3.14
        if text.contains('.') {
            return Ok(self.type_real);
        }

        // Integer Literals: 42
        if text.chars().next().map_or(false, |c| c.is_ascii_digit()) {
            if let Some(expected) = expected_type {
                if matches!(self.types.get(expected), Some(TypeKind::Integer { name })) {
                    return Ok(expected);
                }
            }
            return Ok(self.type_integer);
        }

        Err(SemanticError {
            kind: SemanticErrorKind::InvalidLiteral(text.to_string()),
            span,
        })
    }

    fn infer_unary(
        &mut self,
        op: UnaryOp,
        expr: ExprId,
        expected_type: Option<TypeId>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        let operand_ty = self.infer_expr_type(expr, expected_type)?;

        match op {
            UnaryOp::Not => Ok(operand_ty),
            UnaryOp::Abs | UnaryOp::Neg | UnaryOp::Plus => match self.types.get(operand_ty) {
                Some(TypeKind::Integer { name }) | Some(TypeKind::Real { name }) => Ok(operand_ty),
                _ => Err(SemanticError {
                    kind: SemanticErrorKind::InvalidUnaryOperand,
                    span,
                }),
            },
        }
    }

    fn infer_binary(
        &mut self,
        op: BinaryOp,
        lhs: ExprId,
        rhs: ExprId,
        expected_type: Option<TypeId>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        match op {
            // Relational operators ALWAYS return BOOLEAN
            BinaryOp::Eq
            | BinaryOp::Neq
            | BinaryOp::Lt
            | BinaryOp::Lte
            | BinaryOp::Gt
            | BinaryOp::Gte => {
                let lhs_ty = self.infer_expr_type(lhs, None)?;
                let rhs_ty = self.infer_expr_type(rhs, Some(lhs_ty))?;

                if lhs_ty != rhs_ty {
                    return Err(SemanticError {
                        kind: SemanticErrorKind::AssignmentTypeMismatch {
                            expected: lhs_ty,
                            found: rhs_ty,
                        },
                        span,
                    });
                }
                Ok(self.type_boolean)
            }

            BinaryOp::Concat => {
                let lhs_ty = self.infer_expr_type(lhs, expected_type)?;
                let _rhs_ty = self.infer_expr_type(rhs, expected_type)?;

                if let Some(exp) = expected_type {
                    Ok(exp)
                } else {
                    Ok(lhs_ty)
                }
            }

            // Arithmetic & Logical operations: Operands must match and return operand type
            _ => {
                let lhs_ty = self.infer_expr_type(lhs, expected_type)?;
                let rhs_ty = self.infer_expr_type(rhs, Some(lhs_ty))?;

                if lhs_ty != rhs_ty {
                    return Err(SemanticError {
                        kind: SemanticErrorKind::AssignmentTypeMismatch {
                            expected: lhs_ty,
                            found: rhs_ty,
                        },
                        span,
                    });
                }
                Ok(lhs_ty)
            }
        }
    }

    fn infer_call_or_index(
        &mut self,
        target: ExprId,
        args: &std::ops::Range<u32>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        let target_ty = self.infer_expr_type(target, None)?;

        // Validate index expressions evaluate to valid index types
        let arg_ids = &self.ast.expr_lists[args.start as usize..args.end as usize];
        for &arg_id in arg_ids {
            let _ = self.infer_expr_type(arg_id, Some(self.type_integer))?;
        }

        match self.types.get(target_ty) {
            Some(TypeKind::Array { element_type, .. }) => Ok(*element_type),
            Some(TypeKind::Function { return_type, .. }) => Ok(*return_type),
            _ => Err(SemanticError {
                kind: SemanticErrorKind::CannotIndexOrCallNonArray,
                span,
            }),
        }
    }

    fn infer_aggregate(
        &mut self,
        elements: Range<u32>,
        expected_type: Option<TypeId>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        let expected = expected_type.ok_or_else(|| SemanticError {
            kind: SemanticErrorKind::CannotInferAggregateWithoutContext,
            span,
        })?;

        // Determine what element type we should enforce inside the aggregate
        let elem_type = match self.types.get(expected) {
            Some(TypeKind::Array { element_type, .. }) => *element_type,
            _ => expected,
        };

        // Type-check all child elements against the element type
        let element_expr_ids = &self.ast.expr_lists[elements.start as usize..elements.end as usize];
        for &elem_id in element_expr_ids {
            let _ = self.infer_expr_type(elem_id, Some(elem_type))?;
        }

        Ok(expected)
    }

    fn infer_others(
        &mut self,
        expected_type: Option<TypeId>,
        span: Span,
    ) -> Result<TypeId, SemanticError> {
        // `others` inherits the element type passed down from `infer_aggregate`
        expected_type.ok_or_else(|| SemanticError {
            kind: SemanticErrorKind::OthersRequiresContextualType,
            span,
        })
    }
}
