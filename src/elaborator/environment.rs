use std::collections::HashMap;
use crate::{analyzer::symbols::SymbolId, elaborator::{EvaluatedValue, SignalId}};

#[derive(Debug, Clone, Default)]
pub struct EvalEnv {
    /// Tracks compile-time constants and evaluated generic values
    pub constants: HashMap<SymbolId, EvaluatedValue>,
    
    /// Maps a local AST symbol (like 'clk') to the physical wire in the ElaboratedArena
    pub signals: HashMap<SymbolId, SignalId>,
}

impl EvalEnv {
    pub fn new() -> Self {
        Self::default()
    }

    /// Creates a new child scope (e.g. when entering a generate loop or sub-instance)
    pub fn extend(&self) -> Self {
        self.clone() 
    }
}