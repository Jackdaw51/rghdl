//!instance tree,
//!bound entity/architecture pairs,
//! generic values,
//! elaborated subtypes (i.e. actual constraints after generic substitution),
//! the signal net after port association collapsing,
//! driver sets per signal,
//! and the process list.

mod elaborator;
mod environment;
mod evaluated_value;

use crate::analyzer::{ScopeId, SemanticAnalyzer, SymbolId, TypeId};
use crate::ast::{BinaryOp, GetSpan, PortId, PortMode, UnaryOp};
use crate::workspace::FileId;
use std::collections::HashMap;
use std::ops::Range;

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
impl EvaluatedValue {
    fn to_integer(&self) -> Result<i64, ElaboratorError> {
        match self {
            EvaluatedValue::Integer(i) => Ok(*i),
            other => Err(ElaboratorError::EvaluationFailed {
                reason: format!("Expected integer expression, found {:?}", other),
                span: Span { start: 0, end: 0 },
                file_id: FileId(0), //TODO
            }),
        }
    }
}

#[derive(Debug, Clone)]
pub struct PortBinding {
    pub port_name: SymbolId,
    pub actual_signal: ExprId, // Points to the physical wire in the Arena
}

#[derive(Debug, Clone)]
pub struct ElaboratedPort {
    pub name: SymbolId,
    pub mode: PortMode,
    pub type_id: TypeId,
    pub high_bound: i64,
    pub low_bound: i64,
}
impl ElaboratedPort {
    pub fn width(&self) -> usize {
        if self.high_bound < self.low_bound {
            0
        } else {
            let a = (self.high_bound - self.low_bound + 1) as usize;
            if a < 1073741824 { a } else { 1 }
        }
    }
}

#[derive(Debug, Clone)]
pub struct ElaboratedSignal {
    pub name: SymbolId,
    pub type_id: TypeId,
    pub high_bound: i64,
    pub low_bound: i64,
    /// a driver for a physical signal can originate from three sources:
    /// * Concurrent signal assignment
    /// * Processes
    /// * An out or inout of a child component, creates a driver on that signal
    pub driver_count: usize,
    //needed because generate statements need unique signals
    pub optional_locality: Option<String>,
}
impl ElaboratedSignal {
    pub fn width(&self) -> usize {
        if self.high_bound < self.low_bound {
            0
        } else {
            (self.high_bound - self.low_bound + 1) as usize
        }
    }

    /// Checks if a statically evaluated index is within bounds.
    pub fn contains_index(&self, index: i64) -> bool {
        index >= self.low_bound && index <= self.high_bound
    }

    /// Checks if a sub-range slice fits entirely within this signal's range.
    pub fn contains_range(&self, slice_low: i64, slice_high: i64) -> bool {
        slice_low >= self.low_bound && slice_high <= self.high_bound
    }
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
    VariableAssignment {
        target_symbol: SymbolId,
        value_expr: ExprId,
    },
}

#[derive(Debug, Clone)]
pub struct ElaboratedConcurrentAssignment {
    pub target_signal: ExprId,
    pub value_expr: ExprId,
    pub delay_expr: Option<ExprId>,
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
    UnaryOp {
        op: UnaryOp,
        expr: ExprId,
    },
    ArrayIndex {
        target: ExprId,
        index: ExprId,
    },
}

#[derive(Debug, Clone)]
pub struct InstanceNode {
    pub instance_name: SymbolId,
    pub entity_name: SymbolId,
    pub architecture_name: SymbolId,
    pub hierarchical_path: String,
    // pub generics: HashMap<SymbolId, EvaluatedValue>,
    pub ports: Vec<ElaboratedPort>,
    pub port_bindings: Vec<PortBinding>,
    pub local_signals: Vec<SignalId>,
    // pub local_constants: HashMap<SymbolId, EvaluatedValue>,
    pub concurrent_assignments: Vec<ElaboratedConcurrentAssignment>,
    pub processes: Vec<ProcessId>,
    pub children: Vec<InstanceId>,
    pub local_env: Environment,
}

#[derive(Debug, Clone)]
pub struct ElaboratedDesign {
    pub instances: Vec<InstanceId>,
    pub root_instance: InstanceId,
}

#[derive(Default, Debug)]
pub struct ElaboratedArena {
    pub exprs: Vec<EvaluatedExpr>,
    pub signals: Vec<ElaboratedSignal>,
    pub processes: Vec<ElaboratedProcess>,
    pub instances: Vec<InstanceNode>,
    signals_span: Vec<Span>,
}

impl GetSpan<SignalId> for ElaboratedArena {
    #[inline]
    fn span(&self, id: SignalId) -> Span {
        self.signals_span[id.0 as usize]
    }
}

impl ElaboratedArena {
    pub fn alloc_expr(&mut self, expr: EvaluatedExpr) -> ExprId {
        let id = ExprId(self.exprs.len() as u32);
        self.exprs.push(expr);
        id
    }

    pub fn alloc_signal(&mut self, sig: ElaboratedSignal, span: Span) -> SignalId {
        let id = SignalId(self.signals.len() as u32);
        self.signals.push(sig);
        self.signals_span.push(span);
        id
    }
}

/// The structure that manages the Data of the elaboration
pub struct Elaborator<'a> {
    pub sa: &'a SemanticAnalyzer<'a>,

    /// The physical netlist being constructed
    pub arena: ElaboratedArena,

    /// Counter to generate unique hierarchical names if needed
    instance_counter: u32,

    file_id: FileId,
}

use crate::parser::Span;

#[derive(Debug, Clone)]
pub enum ElaboratorError {
    /// The requested top-level entity was not found in the AST.
    EntityNotFound(String),

    /// No architecture was found for the given entity.
    ArchitectureNotFound(SymbolId),

    /// An error occurred while evaluating a constant or generic expression.
    EvaluationFailed {
        reason: String,
        span: Span,
        file_id: FileId,
    },

    /// Tried to map a port or signal incorrectly (e.g., width mismatch).
    BindingError {
        reason: String,
        span: Span,
        file_id: FileId,
    },

    /// For incremental development: when we hit a VHDL feature we haven't implemented yet.
    NotYetImplemented {
        feature: String,
        span: Span,
        file_id: FileId,
    },
    SignalNotFound(String),
    SymbolNotFound(String),
    NotAnEntity,
    NoMatchingArchitectures(SymbolId),
}

// Environment

#[derive(Debug, Clone, Default)]
pub struct Environment {
    /// Tracks compile-time constants and evaluated generic values
    constants: HashMap<SymbolId, EvaluatedValue>,

    /// Maps a local AST symbol (like 'clk') to the physical wire in the ElaboratedArena
    signals: HashMap<SymbolId, SignalId>,

    /// Local variables inside processes or loop frames
    variables: HashMap<SymbolId, EvaluatedValue>,

    components: HashMap<SymbolId, ComponentSignature>,

    generic_overrides: HashMap<SymbolId, EvaluatedValue>,

    current_scope: ScopeId,
}

#[derive(Debug, Clone)]
pub struct ComponentSignature {
    pub ports_start: PortId,
    pub ports_end: PortId,
}

// impl fmt::Display for ElaboratorError {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         match self {
//             ElaboratorError::EntityNotFound(name) => write!(f, "Entity '{}' not found", name),
//             ElaboratorError::ArchitectureNotFound(name) => {
//                 write!(f, "Architecture for entity '{}' not found", name)
//             }
//             ElaboratorError::EvaluationFailed { reason, .. } => {
//                 write!(f, "Evaluation failed: {}", reason)
//             }
//             ElaboratorError::BindingError { reason, .. } => write!(f, "Binding error: {}", reason),
//             ElaboratorError::NotYetImplemented { feature, .. } => {
//                 write!(f, "Not yet implemented: {}", feature)
//             }
//             ElaboratorError::SignalNotFound(reason) => todo!(),
//         }
//     }
// }

// impl std::error::Error for ElaboratorError {}

use crate::analyzer::TypeArena;

#[derive(Debug, Clone)]
pub struct FnSig {
    pub param_types: Range<u32>,
    pub return_type: TypeId,
}

#[derive(Debug, Default, Clone)]
pub struct Package {
    /// Types exported by this package (keyed by SymbolId for fast AST scope resolution)
    pub types: HashMap<SymbolId, TypeId>,

    /// Constants exported by this package (e.g., ieee.numeric_std constants)
    pub constants: HashMap<SymbolId, EvaluatedValue>,

    /// Package-level signals or shared variables
    pub signals: HashMap<SymbolId, SignalId>,

    /// Function signatures exported by this package
    pub functions: HashMap<SymbolId, FnSig>,
    pub param_types_pool: Vec<TypeId>,

    /// Internal helper map: string name -> SymbolId for compiler string lookups
    pub name_map: HashMap<String, SymbolId>,
}

impl Package {
    pub fn add_type(&mut self, name: &str, sym: SymbolId, type_id: TypeId) {
        let name_lower = name.to_lowercase();
        self.types.insert(sym, type_id);
        self.name_map.insert(name_lower, sym);
    }

    pub fn add_constant(&mut self, name: &str, sym: SymbolId, val: EvaluatedValue) {
        let name_lower = name.to_lowercase();
        self.constants.insert(sym, val);
        self.name_map.insert(name_lower, sym);
    }
    pub fn add_function(
        &mut self,
        name: &str,
        sym: SymbolId,
        param_types: &[TypeId],
        return_type: TypeId,
    ) {
        let start = self.param_types_pool.len() as u32;
        self.param_types_pool.extend_from_slice(param_types);
        let end = self.param_types_pool.len() as u32;

        let sig = FnSig {
            return_type,
            param_types: start..end,
        };

        self.functions.insert(sym, sig);
        self.name_map.insert(name.to_lowercase(), sym);
    }
}

#[derive(Debug, Default, Clone)]
pub struct Library {
    pub packages: HashMap<String, Package>,
}

#[derive(Debug, Default, Clone)]
pub struct LibraryRegistry {
    pub libraries: HashMap<String, Library>,
    pub types: TypeArena,
}

impl LibraryRegistry {
    pub fn new() -> Self {
        Self::default()
    }

    /// Fetches a package using case-insensitive library and package names
    pub fn get_package(&self, lib_name: &str, pkg_name: &str) -> Option<&Package> {
        self.libraries
            .get(&lib_name.to_lowercase())?
            .packages
            .get(&pkg_name.to_lowercase())
    }

    /// Fetches a mutable reference to a package (used during package elaboration)
    pub fn get_package_mut(&mut self, lib_name: &str, pkg_name: &str) -> Option<&mut Package> {
        self.libraries
            .get_mut(&lib_name.to_lowercase())?
            .packages
            .get_mut(&pkg_name.to_lowercase())
    }

    /// Helper for the compiler to look up primitive TypeIds by string
    pub fn get_type(&self, lib_name: &str, pkg_name: &str, type_name: &str) -> Option<TypeId> {
        let pkg = self.get_package(lib_name, pkg_name)?;
        let sym_id = pkg.name_map.get(&type_name.to_lowercase())?;
        pkg.types.get(sym_id).copied()
    }
}
