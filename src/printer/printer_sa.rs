use std::fmt::Display;

use crate::{
    analyzer::{SemanticError, SemanticErrorKind, TypeKind}, printer::SAFormatCtx,
};

impl<'a> Display for SAFormatCtx<'a, SemanticError> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}, {}:{}",
            self.child(&self.item.kind),
            self.path,
            self.get_position(self.item)
            
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
                    self.child(self.sa.types.get(*expected).expect("Types not registered properly")),
                    self.child(self.sa.types.get(*found).expect("Types not registered properly")),
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