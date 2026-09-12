pub(crate) mod scope_tree;
mod semantic_analyzer;
pub(super) mod symbol_table;
pub(crate) mod symbols;
mod type_inference;
pub(crate) mod types;
use std::collections::HashMap;
use std::fmt::Debug;
use std::ops::Range;

use crate::ast::*;
use crate::parser::Span;
use crate::workspace::FileId;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct TypeId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ScopeId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SymbolId(pub u32);

#[derive(Debug)]
pub enum SemanticErrorKind {
    UndefinedSymbol,
    DuplicateDeclaration,
    AssignmentTypeMismatch {
        expected: TypeId,
        found: TypeId,
    },
    InvalidAssignmentKind {
        expected_signal: bool,
    },
    WriteToInputPort,
    ConditionNotBoolean {
        found: TypeId,
    },
    BinaryOperationTypeMismatch {
        lhs_type: TypeId,
        rhs_type: TypeId,
        operator: BinaryOp,
    },
    InvalidOperatorForType {
        found: TypeId,
        operator: BinaryOp,
    },
    UnknownType,
    CannotSliceNonArray,
    UnknownRecordField,
    InvalidLiteral,
    InvalidUnaryOperand,
    InvalidConcatenation,
    NotARecord,
    CannotIndexOrCallNonArray,
    CannotInferAggregateWithoutContext,
    OthersRequiresContextualType,
    AggregateSizeMismatch,
    PortAssocMustBeIdent,
    MalformedUseClause(ExprId),
    NonExistingSymbolInPackage(SymbolId),
    PositionalPortAssociationOutOfBounds,
    EntitySpecifiedNotFound,
}

#[derive(Debug)]
pub struct SemanticError {
    pub kind: SemanticErrorKind,
    pub span: Span,
    pub file_id: FileId,
}

impl SemanticError {
    pub fn new(kind: SemanticErrorKind, span: Span, file_id: FileId) -> Self {
        Self {
            kind,
            span,
            file_id,
        }
    }
}

pub struct SemanticAnalyzer<'a> {
    ast: &'a AstArena,
    units: &'a [AstArena],
    current_file: FileId,
    pub symbols: &'a mut SymbolTable,
    pub types: TypeArena, // holds a vector of types that are referenced by TypeId

    pub current_scope: ScopeId,
    pub errors: Vec<SemanticError>,

    pub type_std_logic: TypeId,
    pub type_std_logic_vector: TypeId,
    pub type_integer: TypeId,
    pub type_boolean: TypeId,
    pub type_real: TypeId,
    pub type_time: TypeId,
    pub entity_architectures: HashMap<EntityId, Vec<ArchitectureId>>,
    pub expr_types: Vec<TypeId>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum DeclRef {
    Entity {
        file_id: FileId,
        entity_id: EntityId,
        scope_id: ScopeId,
    },
    Architecture {
        file_id: FileId,
        ast_id: ArchitectureId,
        entity_id: EntityId,
        scope_id: ScopeId,
    },
    Port {
        id: PortId,
        type_id: TypeId,
        mode: PortMode,
    },
    Signal {
        id: DeclId,
        type_id: TypeId,
    },
    Variable {
        id: DeclId,
        type_id: TypeId,
    },
    Constant {
        id: DeclId,
        type_id: TypeId,
    },
    Component {
        id: DeclId,
    },
    Type(TypeId),
    Function(TypeId),
    Instance {
        name: SymbolId,
    },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ScopeKind {
    Global,
    Entity,
    Architecture,
    Process,
    Block,
}

#[derive(Debug)]
pub struct Scope {
    pub kind: ScopeKind,
    pub parent: Option<ScopeId>,
    pub bindings: HashMap<SymbolId, DeclRef>,
}

#[derive(Default, Debug)]
pub struct ScopeArena {
    scopes: Vec<Scope>,
}
#[derive(Default, Debug)]
pub struct SymbolInterner {
    map: HashMap<String, SymbolId>,
    pub vec: Vec<String>,
    symbol_list: Vec<SymbolId>,
}
pub struct SymbolTable {
    pub scopes: ScopeArena,
    pub interner: SymbolInterner,
}

#[derive(Default, Debug, Clone)]
pub struct TypeArena {
    types: Vec<TypeKind>,
}
#[derive(Debug, Clone)]
pub enum TypeKind {
    /// std_logic, boolean
    Enum {
        name: SymbolId,
        literals: Vec<SymbolId>,
    },
    /// integer
    Integer {
        name: SymbolId,
    },

    Real {
        name: SymbolId,
    },
    /// std_logic_vector
    Array {
        name: SymbolId,
        element_type: TypeId,
    },

    Record {
        name: SymbolId,
        fields: HashMap<SymbolId, TypeId>,
    },

    Function {
        name: SymbolId,
        args: Vec<TypeId>,
        return_type: TypeId,
    },
    Physical {
        name: SymbolId,
        primary_unit: SymbolId,
        units: Vec<(SymbolId, u64)>, // (unit_symbol, multiplier_relative_to_fs)
    },
    /// Unresolved or error
    Error,
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
