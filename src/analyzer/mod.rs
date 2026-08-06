mod semantic;
pub(crate) mod types;
mod scope_tree;
pub(super) mod symbol_table;
mod symbols;
mod type_inference;
use std::fmt::Debug;

use crate::analyzer::scope_tree::{DeclRef, ScopeId, ScopeKind};
use crate::analyzer::symbol_table::SymbolTable;
use crate::analyzer::types::{TypeArena, TypeId, TypeKind};
use crate::parser::ast::*;
use crate::parser::lexer::Span;
#[derive(Debug)]
pub enum SemanticErrorKind {
    UndefinedSymbol(String),
    DuplicateDeclaration(String),
    AssignmentTypeMismatch { expected: TypeId, found: TypeId },
    InvalidAssignmentKind { expected_signal: bool },
    WriteToInputPort(String),
    ConditionNotBoolean { found: TypeId },
    BinaryOperationTypeMismatch {
        lhs_type: TypeId,
        rhs_type: TypeId,
        operator: BinaryOp,
    },
    InvalidOperatorForType {
        found: TypeId,
        operator: BinaryOp,
    },
    UnknownType(String),
    CannotSliceNonArray,
    UnknownRecordField(String),
    InvalidLiteral(String),
    InvalidUnaryOperand,
    NotARecord,
    CannotIndexOrCallNonArray,
    CannotInferAggregateWithoutContext,
    OthersRequiresContextualType,
}



#[derive(Debug)]
pub struct SemanticError {
    pub kind: SemanticErrorKind,
    pub span: Span,
}


pub struct SemanticAnalyzer<'a> {
    pub ast: &'a AstArena<'a>,
    pub symbols: SymbolTable,
    pub types: TypeArena, // holds a vector of types that are referenced by TypeId

    pub current_scope: ScopeId,
    pub errors: Vec<SemanticError>,

    pub type_std_logic: TypeId,
    pub type_std_logic_vector: TypeId,
    pub type_integer: TypeId,
    pub type_boolean: TypeId,
    pub type_real:TypeId,
    pub source: &'a str,
}
impl<'a> Debug for SemanticAnalyzer<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("SemanticAnalyzer")
            .field("\nsym", &self.symbols)
            .field("\ntypes", &self.types)
            .field("\ncurrent_scope", &self.current_scope)
            .field("\nerrors", &self.errors)
            .field("\ntype_std_logic", &self.type_std_logic)
            .field("\ntype_integer", &self.type_integer)
            .finish()
    }
}

impl<'a> SemanticAnalyzer<'a> {
    pub fn new(ast: &'a AstArena<'a>, mut symbols: SymbolTable, source: &'a str) -> Self {
        let root_scope = symbols.scopes.alloc(ScopeKind::Global, None);
        let mut types = TypeArena::default();

        // Intern primitive VHDL types into Global Scope
        let std_logic_sym = symbols.interner.get_or_internalize("std_logic");
        let type_std_logic = types.alloc(TypeKind::Enum {
            name: std_logic_sym,
            literals: vec![],
        });
        let _ = symbols.define(root_scope, std_logic_sym, DeclRef::Type(type_std_logic));

        
        let integer_sym = symbols.interner.get_or_internalize("integer");
        let type_integer = types.alloc(TypeKind::Integer { name: integer_sym });
        let _ = symbols.define(root_scope, integer_sym, DeclRef::Type(type_integer));

        let real_sym = symbols.interner.get_or_internalize("real");
        let type_real = types.alloc(TypeKind::Real { name: real_sym });
        let _ = symbols.define(root_scope, real_sym, DeclRef::Type(type_real));
        
        let boolean_sym = symbols.interner.get_or_internalize("boolean");
        let type_boolean = types.alloc(TypeKind::Enum {
            name: boolean_sym,
            literals: vec![],
        });
        let _ = symbols.define(root_scope, boolean_sym, DeclRef::Type(type_boolean));
        
        let std_logic_vector_sym = symbols.interner.get_or_internalize("std_logic_vector");
        let type_std_logic_vector = types.alloc(TypeKind::Array { name: std_logic_vector_sym, element_type: type_std_logic });
        let _ = symbols.define(root_scope, std_logic_vector_sym, DeclRef::Type(type_std_logic_vector));

        Self {
            ast,
            symbols,
            types,
            current_scope: root_scope,
            errors: Vec::new(),
            type_std_logic,
            type_std_logic_vector,
            type_integer,
            type_boolean,
            type_real,
            source,
        }
    }
}
