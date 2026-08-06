#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct TypeId(pub u32);
use std::collections::HashMap;

use crate::analyzer::symbols::SymbolId;


impl TypeId {
    pub const ERROR: TypeId = TypeId(u32::MAX);

    pub fn is_error(&self) -> bool {
        self.0 == u32::MAX
    }
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
    /// Unresolved or error
    Error,
}

#[derive(Default, Debug)]
pub struct TypeArena {
    types: Vec<TypeKind>,
}

impl TypeArena {
    pub fn alloc(&mut self, kind: TypeKind) -> TypeId {
        let id = TypeId(self.types.len() as u32);
        self.types.push(kind);
        id
    }

    pub fn get(&self, id: TypeId) -> Option<&TypeKind> {
        if id == TypeId::ERROR {
            return None;
        }
        self.types.get(id.0 as usize)
    }
}
