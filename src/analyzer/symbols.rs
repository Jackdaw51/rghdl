use crate::analyzer::{SymbolId, SymbolInterner};

impl SymbolInterner {
    /// Returns the symbol if it's present in the map, otherwise inserts it and returns its Id
    pub fn get_or_internalize(&mut self, name: &str) -> SymbolId {
        let normalized = name.to_lowercase();

        if let Some(&id) = self.map.get(&normalized) {
            return id;
        }
        dbg!(normalized.clone());

        let id = SymbolId(self.vec.len() as u32);
        self.vec.push(normalized.clone());
        self.map.insert(normalized, id);
        id
    }
    /// Use only when you are sure the symbol is already present
    pub fn get_symbol(&self, name: &str) -> Option<SymbolId> {
        let normalized = name.to_lowercase();
        self.map.get(&normalized).copied()
    }

    pub(crate) fn iter(&self) -> std::slice::Iter<'_, String> {
        self.vec.iter()
    }
    pub fn get(&self, symbol_id: SymbolId) -> &str {
        &self.vec[symbol_id.0 as usize]
    }
}
