use std::ops::Range;

use crate::{
    analyzer::{SemanticAnalyzer, SemanticError, SemanticErrorKind, TypeId, TypeKind},
    parser::{
        Span,
    },
};
use crate::ast::{BinaryOp, Expr, ExprId, UnaryOp};

impl<'a> SemanticAnalyzer<'a> {
    pub fn infer_expr_type(
        &mut self,
        expr_id: ExprId,
        expected_type: Option<TypeId>,
    ) -> Result<TypeId, SemanticError> {
        let expr = self.ast.exprs[expr_id.0 as usize].clone();

        let ty = match expr {
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
        }?;
        if (expr_id.0 as usize) >= self.expr_types.len() {
            self.expr_types
                .resize((expr_id.0 as usize) + 1, TypeId::ERROR);
        }
        self.expr_types[expr_id.0 as usize] = ty;
        Ok(ty)
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
                let field_sym = self.symbols.interner.get_or_internalize(field);
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
        self.infer_expr_type(left, Some(self.type_integer))?;
        self.infer_expr_type(right, Some(self.type_integer))?;

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
            UnaryOp::Not => {
                if operand_ty == self.type_boolean || operand_ty == self.type_std_logic {
                    Ok(operand_ty)
                } else {
                    // Also allow Arrays of bits/booleans (e.g. std_logic_vector)
                    match self.types.get(operand_ty) {
                        Some(TypeKind::Array { element_type, .. })
                            if *element_type == self.type_boolean
                                || *element_type == self.type_std_logic =>
                        {
                            Ok(operand_ty)
                        }
                        _ => Err(SemanticError {
                            kind: SemanticErrorKind::InvalidUnaryOperand,
                            span,
                        }),
                    }
                }
            }
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
                // We must have an expected array type to build a concatenation
                let target_array_ty = expected_type.ok_or_else(|| SemanticError {
                    kind: SemanticErrorKind::CannotInferAggregateWithoutContext,
                    span,
                })?;

                // TODO
                // VHDL allows concatenating elements to form an array.
                // We MUST recognize that if LHS or RHS is an unresolved literal (like '1'), they need `elem_type`.

                let _lhs_ty = self.infer_expr_type(lhs, None)?;
                let _rhs_ty = self.infer_expr_type(rhs, None)?;

                // In a full implementation, we would check if `lhs_ty` and `rhs_ty`
                // are either `target_array_ty` OR the `element_type` of that array.

                Ok(target_array_ty)
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
        let arg_ids = &self.ast.expr_lists[args.start as usize..args.end as usize];

        // Temporary enum so the borrow of `self.types` ends
        enum TargetKind {
            Array(TypeId),
            Function(Vec<TypeId>, TypeId),
            Invalid,
        }

        let target_kind = match self.types.get(target_ty) {
            Some(TypeKind::Array { element_type, .. }) => {
                TargetKind::Array(*element_type) // TypeId is Copy
            }
            Some(TypeKind::Function {
                args, return_type, ..
            }) => {
                // Clone the argument list so it is detached from self.types
                TargetKind::Function(args.clone(), *return_type)
            }
            _ => TargetKind::Invalid,
        };

        match target_kind {
            TargetKind::Array(element_type) => {
                for &arg_id in arg_ids {
                    self.infer_expr_type(arg_id, Some(self.type_integer))?;
                }
                Ok(element_type)
            }
            TargetKind::Function(expected_args, return_type) => {
                for (&arg_id, &expected_param_ty) in arg_ids.iter().zip(expected_args.iter()) {
                    self.infer_expr_type(arg_id, Some(expected_param_ty))?;
                }
                Ok(return_type)
            }
            TargetKind::Invalid => Err(SemanticError {
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

        enum AggKind {
            Array(TypeId),       // Stores the element's TypeId
            Record(Vec<TypeId>), // Stores the ordered TypeIds of the fields
            Invalid,
        }

        let agg_kind = match self.types.get(expected) {
            Some(TypeKind::Array { element_type, .. }) => AggKind::Array(*element_type),
            Some(TypeKind::Record { fields, .. }) => {
                // Extract just the TypeIds of the fields so we can drop the borrow on self.types
                let field_tys: Vec<TypeId> = fields.iter().map(|(_sym, ty)| *ty).collect();
                AggKind::Record(field_tys)
            }
            _ => AggKind::Invalid,
        };
        let element_expr_ids = &self.ast.expr_lists[elements.start as usize..elements.end as usize];

        match agg_kind {
            AggKind::Array(elem_ty) => {
                for &elem_id in element_expr_ids {
                    self.infer_expr_type(elem_id, Some(elem_ty))?;
                }
                Ok(expected)
            }
            AggKind::Record(field_tys) => {
                // This assumes positional aggregate mapping.
                // TODO Named associations (e.g., `(a => '1', b => '0')`) require more complex logic.
                if element_expr_ids.len() != field_tys.len() {
                    return Err(SemanticError {
                        kind: SemanticErrorKind::AggregateSizeMismatch,
                        span,
                    });
                }
                for (&elem_id, &field_ty) in element_expr_ids.iter().zip(field_tys.iter()) {
                    self.infer_expr_type(elem_id, Some(field_ty))?;
                }
                Ok(expected)
            }
            AggKind::Invalid => Err(SemanticError {
                kind: SemanticErrorKind::AssignmentTypeMismatch {
                    expected,
                    found: expected,
                },
                span,
            }),
        }
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
