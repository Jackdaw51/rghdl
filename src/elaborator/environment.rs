use crate::{analyzer::SymbolId, elaborator::{Environment, EvaluatedValue, SignalId}};

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