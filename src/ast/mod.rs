pub(crate) mod ast;

use std::ops::Range;

use crate::{
    analyzer::SymbolId,
    parser::{Span, TokenKind},
};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ContextId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PortId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct EntityId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ArchitectureId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SeqStmtId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ConcStmtId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DeclId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ExprId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinaryOp {
    // Relational (Return BOOLEAN)
    Eq,
    Neq,
    Lt,
    Lte,
    Gt,
    Gte,
    // Arithmetic (Return same as operands)
    Add,
    Sub,
    Mul,
    Div,
    Concat, //&
    // Logical (Return same as operands)
    And,
    Or,
    Xor,
    Nand,
    Nor,
    // Needed for the parser
    RecordAccess, // .
    CallOrIndex,  // ()

    Arrow, // TODO should make sure it disallows stuff like a=>b
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnaryOp {
    Not,
    Neg,
    Plus,
    Abs,
}

#[derive(Debug, Clone)]
pub enum Expr {
    Literal {
        name: SymbolId,
    },
    Identifier {
        name: SymbolId,
    },
    Binary {
        op: BinaryOp,
        lhs: ExprId, // Index of the left expression
        rhs: ExprId, // Index of the right expression
    },
    Unary {
        op: UnaryOp,
        expr: ExprId,
    },
    // Handles parentheses for precedence
    Grouping {
        expr: ExprId,
    },
    /// Represents `target(arg1, arg2)` - could be an array index or function call
    // Let the semantic analyzer figure out what it is
    CallOrIndex {
        callee: ExprId,   // The identifier being called/indexed
        args: Range<u32>, // The expressions inside the parentheses
    },
    // Expression to encode physical quantities
    PhysicalLiteral {
        value: ExprId,  // Points to the numeric literal (e.g. 1)
        unit: SymbolId, // Unit symbol (e.g. "ns")
    },
    Others,
    All,
    Aggregate {
        elements: Range<u32>,
    },
    Slice {
        target: ExprId,
        direction: TokenKind,
        left: ExprId,
        right: ExprId,
    },
    RecordAccess {
        target: ExprId,
        field: SymbolId,
    },
}
#[derive(Debug, Clone, PartialEq)]
pub enum ContextItem {
    Library { name: SymbolId, span: Span },
    Use { path: ExprId, span: Span },
}

#[derive(Debug, Clone, PartialEq, Eq, Copy)]
pub enum PortMode {
    In,
    Out,
    InOut,
    Buffer,
}

#[derive(Debug, Clone)]
pub struct Port {
    pub name: SymbolId,
    pub mode: PortMode,
    pub port_type: ExprId,
}

#[derive(Debug, Clone)]
pub struct Entity {
    pub name: SymbolId,
    pub span: Span,
    pub ports_start: PortId,
    pub ports_end: PortId,
    pub generics_start: DeclId,
    pub generics_end: DeclId,
}

#[derive(Debug, Clone)]
pub enum Decl {
    Signal {
        name: SymbolId,
        decl_type: SymbolId,
        default_val: Option<ExprId>,
    },
    Constant {
        name: SymbolId,
        decl_type: SymbolId,
        default_val: Option<ExprId>,
    },
    Variable {
        name: SymbolId,
        decl_type: SymbolId,
        default_val: Option<ExprId>,
    },
    Component {
        name: SymbolId,
        ports_start: PortId,
        ports_end: PortId,
    },
    //TODO: user-defined types, functions and procedures
}

#[derive(Debug, Clone)]
pub enum SequentialStmt {
    SequentialAssignment {
        target: ExprId,
        expression: ExprId,
        after: Option<ExprId>,
    },
    // var := var + 1;
    VariableAssignment {
        target: ExprId,
        expression: ExprId,
    },
    // if condition then ... else ... end if;
    If {
        condition: ExprId,
        then_stmts: Range<u32>,
        elsif_stmts: Range<u32>,
        else_stmts: Range<u32>,
    },
    // case state is when IDLE => ... when others => ... end case;
    // Case {
    //     expression_span: SymbolId,
    //     cases_span: SymbolId,
    // },

    // for i in 0 to 7 loop ... end loop;
    // Loop {
    //     label: Option<SymbolId>,
    //     loop_scheme_span: SymbolId, // "for i in 0 to 7"
    //     stmts: Range<u32>,
    // },
    ProcedureCall {
        call: ExprId,
    },
}

#[derive(Debug, Clone)]
pub struct Association {
    /// `Some(expr)` for named mapping (`A => sig`), `None` for positional mapping (`sig`)
    pub formal: Option<ExprId>,
    /// The signal or expression being mapped (`sig`, `open`, `a and b`)
    pub actual: ExprId,
}

#[derive(Debug, Clone)]
pub enum ConcurrentStmt {
    ConcurrentAssignment {
        label: Option<SymbolId>, // cause for some reason concurrent assignment can have a label `my_label : data_bus(0) <= '1'``
        target: ExprId,
        expression: ExprId,
        after: Option<ExprId>,
    },

    // out_port <= a when control = '1' else b;
    // ConditionalAssignment {
    //     target: SymbolId,
    // },

    // u_gate: and_gate port map (A => in1, B => in2, Y => out_port);
    ComponentInstantiation {
        label: Option<SymbolId>,
        component_name: ExprId,
        arch_qualifier: Option<SymbolId>, // Like (rtl)
        generic_map: Range<u32>,
        port_map: Range<u32>,
    },

    // My_Process: process(clk) begin ... end process;
    Process {
        label: Option<SymbolId>,
        sens_list: Option<Range<u32>>, // Refers to expr_lists
        stmts: Range<u32>,
    },
}

#[derive(Debug, Clone)]
pub struct Architecture {
    pub name: SymbolId,
    pub span: Span,
    pub entity_name: SymbolId,
    pub decls_start: DeclId,
    pub decls_end: DeclId,
    pub stmts: Range<u32>,
}

#[derive(Debug, Clone)]
pub struct ElsifBranch {
    pub condition: ExprId,
    pub stmts: Range<u32>,
}

#[derive(Default, Debug, Clone)]
pub struct AstArena {
    pub entities: Vec<Entity>,
    pub architectures: Vec<Architecture>,
    pub contexts: Vec<ContextItem>,

    pub ports: Vec<Port>,
    port_spans: Vec<Span>,

    pub decls: Vec<Decl>,
    decl_span: Vec<Span>,

    pub sequential_stmts: Vec<SequentialStmt>,
    seq_span: Vec<Span>,

    pub concurrent_stmts: Vec<ConcurrentStmt>,
    conc_span: Vec<Span>,

    pub exprs: Vec<Expr>,
    pub expr_span: Vec<Span>,

    pub associations: Vec<Association>,

    // Indirection lists
    pub elsifs: Vec<ElsifBranch>,
    pub seq_stmt_lists: Vec<SeqStmtId>,
    pub conc_stmt_lists: Vec<ConcStmtId>,
    pub expr_lists: Vec<ExprId>,
}

pub trait GetSpan<Id> {
    fn span(&self, id: Id) -> Span;
}

impl GetSpan<PortId> for AstArena{
    #[inline]
    fn span(&self, id: PortId) -> Span {
        self.port_spans[id.0 as usize]
    }
} 
impl GetSpan<DeclId> for AstArena{
    #[inline]
    fn span(&self, id: DeclId) -> Span {
        self.decl_span[id.0 as usize]
    }
} 
impl GetSpan<SeqStmtId> for AstArena{
    #[inline]
    fn span(&self, id: SeqStmtId) -> Span {
        self.seq_span[id.0 as usize]
    }
} 
impl GetSpan<ConcStmtId> for AstArena{
    #[inline]
    fn span(&self, id: ConcStmtId) -> Span {
        self.conc_span[id.0 as usize]
    }
} 
impl GetSpan<ExprId> for AstArena{
    #[inline]
    fn span(&self, id: ExprId) -> Span {
        self.expr_span[id.0 as usize]
    }
} 