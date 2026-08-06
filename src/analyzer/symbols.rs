use crate::{
    analyzer::{scope_tree::ScopeId, types::TypeId}, parser::ast::{DeclId, PortId},
};
use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SymbolId(pub u32);

#[derive(Default, Debug)]
pub struct SymbolInterner {
    map: HashMap<String, SymbolId>,
    vec: Vec<String>,
}

impl SymbolInterner {
    /// Returns the symbol if it's present in the map, otherwise inserts it and returns its Id
    pub fn get_or_internalize(&mut self, name: &str) -> SymbolId {
        let normalized = name.to_lowercase();

        if let Some(&id) = self.map.get(&normalized) {
            return id;
        }

        let id = SymbolId(self.vec.len() as u32);
        self.vec.push(normalized.clone());
        self.map.insert(normalized, id);
        id
    }
}