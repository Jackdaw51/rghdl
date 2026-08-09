//!instance tree,
//!bound entity/architecture pairs,
//! generic values,
//! elaborated subtypes (i.e. actual constraints after generic substitution),
//! the signal net after port association collapsing,
//! driver sets per signal,
//! and the process list.

mod elaborator;
mod environment;

use crate::analyzer::SemanticAnalyzer;
use crate::analyzer::symbols::SymbolId;
use crate::analyzer::types::TypeId;
use crate::parser::ast::{AstArena, BinaryOp, PortMode};
use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ExprId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct SignalId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ProcessId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct InstanceId(pub u32);

#[derive(Debug, Clone, PartialEq)]
pub enum EvaluatedValue {
    Integer(i64),
    Boolean(bool),
    EnumLiteral(SymbolId),
    Vector(Vec<EvaluatedValue>),
}

#[derive(Debug, Clone)]
pub struct PortBinding {
    pub port_name: SymbolId,
    pub actual_signal: SignalId, // Points to the physical wire in the Arena
}

#[derive(Debug, Clone)]
pub struct ElaboratedPort {
    pub name: SymbolId,
    pub mode: PortMode,
    pub type_id: TypeId,
    pub high_bound: i64,
    pub low_bound: i64,
}

#[derive(Debug, Clone)]
pub struct ElaboratedSignal {
    pub name: SymbolId,
    pub type_id: TypeId,
    pub high_bound: i64,
    pub low_bound: i64,
    pub driver_count: usize,
}

#[derive(Debug, Clone)]
pub struct ElaboratedProcess {
    pub label: SymbolId,
    pub sensitivity_list: Vec<SignalId>, // Processes are sensitive to physical wires, not just names
    pub body_stmts: Vec<ElaboratedSequentialStmt>,
}

#[derive(Debug, Clone)]
pub enum ElaboratedSequentialStmt {
    SignalAssignment {
        target: SignalId, // Target is a physical wire
        value_expr: ExprId,
    },
    If {
        condition: ExprId,
        then_branch: Vec<ElaboratedSequentialStmt>,
        else_branch: Option<Vec<ElaboratedSequentialStmt>>,
    },
}

#[derive(Debug, Clone)]
pub struct ElaboratedConcurrentAssignment {
    pub target_signal: SignalId,
    pub value_expr: ExprId,
}

#[derive(Debug, Clone)]
pub enum EvaluatedExpr {
    Literal(EvaluatedValue),
    SignalRead(SignalId), // Reads a physical wire
    BinaryOp {
        lhs: ExprId,
        op: BinaryOp,
        rhs: ExprId,
    },
}

#[derive(Debug, Clone)]
pub struct InstanceNode {
    pub instance_name: SymbolId,
    pub entity_name: SymbolId,
    pub architecture_name: SymbolId,
    pub hierarchical_path: String,
    pub generics: HashMap<SymbolId, EvaluatedValue>,
    pub ports: Vec<ElaboratedPort>,
    pub port_bindings: Vec<PortBinding>,
    pub local_signals: Vec<SignalId>,
    pub local_constants: HashMap<SymbolId, EvaluatedValue>,
    pub concurrent_assignments: Vec<ElaboratedConcurrentAssignment>,
    pub processes: Vec<ProcessId>,
    pub children: Vec<InstanceId>,
}

#[derive(Debug, Clone)]
pub struct ElaboratedDesign {
    pub top_instance: InstanceNode, //root
}

#[derive(Default, Debug)]
pub struct ElaboratedArena {
    pub exprs: Vec<EvaluatedExpr>,
    pub signals: Vec<ElaboratedSignal>,
    pub processes: Vec<ElaboratedProcess>,
    pub instances: Vec<InstanceNode>,
}

impl ElaboratedArena {
    pub fn alloc_expr(&mut self, expr: EvaluatedExpr) -> ExprId {
        let id = ExprId(self.exprs.len() as u32);
        self.exprs.push(expr);
        id
    }

    pub fn alloc_signal(&mut self, sig: ElaboratedSignal) -> SignalId {
        let id = SignalId(self.signals.len() as u32);
        self.signals.push(sig);
        id
    }
}

/// The structure that manages the Data of the elaboration
pub struct Elaborator<'a> {
    pub ast: &'a AstArena<'a>,
    pub sa: &'a SemanticAnalyzer<'a>,

    /// The physical netlist being constructed
    pub arena: ElaboratedArena,

    /// Counter to generate unique hierarchical names if needed
    instance_counter: u32,
}

use crate::parser::lexer::Span;
use std::fmt;

#[derive(Debug, Clone)]
pub enum ElaboratorError {
    /// The requested top-level entity was not found in the AST.
    EntityNotFound(String),

    /// No architecture was found for the given entity.
    ArchitectureNotFound(String),

    /// An error occurred while evaluating a constant or generic expression.
    EvaluationFailed { reason: String, span: Span },

    /// Tried to map a port or signal incorrectly (e.g., width mismatch).
    BindingError { reason: String, span: Span },

    /// For incremental development: when we hit a VHDL feature we haven't implemented yet.
    NotYetImplemented { feature: String, span: Span },
}

impl fmt::Display for ElaboratorError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ElaboratorError::EntityNotFound(name) => write!(f, "Entity '{}' not found", name),
            ElaboratorError::ArchitectureNotFound(name) => {
                write!(f, "Architecture for entity '{}' not found", name)
            }
            ElaboratorError::EvaluationFailed { reason, .. } => {
                write!(f, "Evaluation failed: {}", reason)
            }
            ElaboratorError::BindingError { reason, .. } => write!(f, "Binding error: {}", reason),
            ElaboratorError::NotYetImplemented { feature, .. } => {
                write!(f, "Not yet implemented: {}", feature)
            }
        }
    }
}

impl std::error::Error for ElaboratorError {}
