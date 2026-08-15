use std::fmt::Debug;

use crate::analyzer::{
    DeclRef, ScopeArena, ScopeId, SymbolId, SymbolInterner, SymbolTable,
};

impl Debug for SymbolTable {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("SymbolTable")
            .field("\n\nscopes", &self.scopes)
            .field("\n\ninterner", &self.interner)
            .finish()
    }
}
impl SymbolTable {
    // Creates a new symbol table with core library already injected
    pub fn new() -> Self {
        let mut symbols = Self {
            scopes: ScopeArena::default(),
            interner: SymbolInterner::default(),
        };
        let _sym_ieee = symbols.interner.get_or_internalize("ieee");
        let _sym_std  = symbols.interner.get_or_internalize("std");
        let _sym_work = symbols.interner.get_or_internalize("work");
        symbols
    }

    /// Inserts a declaration into a specific scope. Returns `Err` if symbol was already defined in the current scope.
    pub fn define(
        &mut self,
        scope: ScopeId,
        symbol: SymbolId,
        decl: DeclRef,
    ) -> Result<(), SymbolId> {
        let current_scope = self.scopes.get_mut(scope);
        if current_scope.bindings.contains_key(&symbol) {
            return Err(symbol);
        }
        current_scope.bindings.insert(symbol, decl);
        Ok(())
    }

    /// Looks up a symbol starting at `start_scope` and walking up to parent scopes.
    pub fn lookup(&self, start_scope: ScopeId, symbol: SymbolId) -> Option<DeclRef> {
        let mut current = Some(start_scope);

        while let Some(scope_id) = current {
            let scope = self.scopes.get(scope_id);
            if let Some(&decl) = scope.bindings.get(&symbol) {
                return Some(decl);
            }
            // Move up to parent scope
            current = scope.parent;
        }

        None // Undefined symbol error
    }
}
