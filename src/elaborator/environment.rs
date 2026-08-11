use std::collections::HashMap;
use crate::{analyzer::{scope_tree::DeclRef, symbols::SymbolId}, elaborator::{EvaluatedValue, SignalId}};

#[derive(Debug, Clone, Default)]
pub struct Environment {
    /// Tracks compile-time constants and evaluated generic values
    pub constants: HashMap<SymbolId, EvaluatedValue>,
    
    /// Maps a local AST symbol (like 'clk') to the physical wire in the ElaboratedArena
    pub signals: HashMap<SymbolId, SignalId>,
}

impl Environment {
    pub fn new() -> Self {
        Self::default()
    }

    /// Creates a new child scope (e.g. when entering a generate loop or sub-instance)
    pub fn extend(&self) -> Self {
        self.clone() 
    }
    
    pub(crate) fn insert_signal(&mut self, port_sym: SymbolId, sig_id: SignalId) -> Option<SignalId> {
        self.signals.insert(port_sym, sig_id)
    }
    
    pub(crate) fn insert_value(&mut self, sym: SymbolId, clone: EvaluatedValue) -> Option<EvaluatedValue> {
        self.constants.insert(sym, clone)
    }
    
    pub(crate) fn lookup_signal(&self, target_symbol: SymbolId) -> Option<SignalId> {
        self.signals.get(&target_symbol).copied()
    }
    
    pub(crate) fn lookup_value(&self, sym: SymbolId) -> Option<&EvaluatedValue> {
        self.constants.get(&sym)
    }
}