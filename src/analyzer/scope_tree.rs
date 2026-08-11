use std::collections::HashMap;

use crate::{
    analyzer::{symbols::SymbolId, types::TypeId}, parser::ast::{ArchitectureId, DeclId, EntityId, PortId, PortMode},
};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DeclRef {
    Entity {
        entity_id: EntityId,
        scope_id: ScopeId,
    },
    Architecture {
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
    Type(TypeId),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ScopeId(pub u32);

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

impl ScopeArena {
    pub fn alloc(&mut self, kind: ScopeKind, parent: Option<ScopeId>) -> ScopeId {
        let id = ScopeId(self.scopes.len() as u32);
        self.scopes.push(Scope {
            kind,
            parent,
            bindings: HashMap::new(),
        });
        id
    }

    pub fn get(&self, id: ScopeId) -> &Scope {
        &self.scopes[id.0 as usize]
    }

    pub fn get_mut(&mut self, id: ScopeId) -> &mut Scope {
        &mut self.scopes[id.0 as usize]
    }
}
