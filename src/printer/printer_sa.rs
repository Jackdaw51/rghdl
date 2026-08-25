use std::fmt::Display;

use crate::{
    analyzer::{SemanticError, SemanticErrorKind, TypeKind}, printer::SAFormatCtx,
};

impl<'a> Display for SAFormatCtx<'a, SemanticError> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}, around {}, on line {}",
            self.child(&self.item.kind),
            self.get_text(self.item.span),
            self.get_line_from_span(self.item.span)
        )
    }
}
impl<'a> Display for SAFormatCtx<'a, SemanticErrorKind> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self.item {
            SemanticErrorKind::AssignmentTypeMismatch { expected, found } => {
                write!(
                    f,
                    "expected: {}, found: {}",
                    self.child(self.sa.types.get(*expected).unwrap()),
                    self.child(self.sa.types.get(*found).unwrap())
                )
            }
            a => write!(f, "{:?}", a),
        }
    }
}

impl <'a> Display for SAFormatCtx<'a,TypeKind> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let name = match self.item {
            TypeKind::Enum { name, literals } => name,
            TypeKind::Integer { name } => name,
            TypeKind::Real { name } => name,
            TypeKind::Array { name, element_type } => name,
            TypeKind::Record { name, fields } => name,
            TypeKind::Function { name, args, return_type } => name,
            TypeKind::Physical { name, primary_unit, units } => name,
            TypeKind::Error => panic!(),
        };
        write!(f,"{}",self.sa.symbols.interner.get(*name))
    }
}