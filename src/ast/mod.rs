pub(crate) mod ast;

use std::ops::Range;

use crate::parser::{Span, TokenKind};

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
pub enum Expr<'a> {
    Literal {
        text: &'a str,
        span: Span,
    },
    Identifier {
        name: &'a str, // debug purposes
        span: Span,
    },
    Binary {
        op: BinaryOp,
        lhs: ExprId, // Index of the left expression
        rhs: ExprId, // Index of the right expression
        span: Span,  // Span of the entire operation
    },
    Unary {
        op: UnaryOp,
        expr: ExprId,
        span: Span,
    },
    // Handles parentheses for precedence
    Grouping {
        expr: ExprId,
        span: Span,
    },
    /// Represents `target(arg1, arg2)` - could be an array index or function call
    // Let the semantic analyzer figure out what it is
    CallOrIndex {
        callee: ExprId,   // The identifier being called/indexed
        args: Range<u32>, // The expressions inside the parentheses
        span: Span,
    },
    // Expression to encode physical quantities
    PhysicalLiteral {
        value: ExprId, // Points to the numeric literal (e.g. 1)
        unit: &'a str, // Unit symbol (e.g. "ns")
        span: Span,
    },
    Others {
        span: Span,
    },
    Aggregate {
        elements: Range<u32>,
        span: Span,
    },
    Slice {
        target: ExprId,
        direction: TokenKind,
        left: ExprId,
        right: ExprId,
        span: Span,
    },
    RecordAccess {
        target: ExprId,
        field: &'a str,
        span: Span,
    },
}
#[derive(Debug, Clone, PartialEq)]
pub enum ContextItem<'a> {
    Library { name: &'a str },
    Use { path: &'a str },
}

#[derive(Debug, Clone, PartialEq, Eq, Copy)]
pub enum PortMode {
    In,
    Out,
    InOut,
    Buffer,
}

#[derive(Debug, Clone)]
pub struct Port<'a> {
    pub name: &'a str,
    pub name_span: Span,
    pub mode: PortMode,
    pub port_type: ExprId,
}

#[derive(Debug, Clone)]
pub struct Entity<'a> {
    pub name: &'a str,
    pub name_span: Span,
    pub ports_start: PortId,
    pub ports_end: PortId,
    pub generics_start: DeclId,
    pub generics_end: DeclId,
}

#[derive(Debug, Clone)]
pub enum Decl<'a> {
    Signal {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<ExprId>,
    },
    Constant {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<ExprId>,
    },
    Variable {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<ExprId>,
    },
    Component {
        name: &'a str,
        ports_start: PortId,
        ports_end: PortId,
    },
    //TODO: user-defined types, functions and procedures
}

#[derive(Debug, Clone)]
pub enum SequentialStmt<'a> {
    SequentialAssignment {
        target: ExprId,
        expression: ExprId,
        after: Option<ExprId>
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
    Case {
        expression_span: Span,
        cases_span: Span,
    },

    // for i in 0 to 7 loop ... end loop;
    Loop {
        label: Option<&'a str>,
        loop_scheme_span: Span, // "for i in 0 to 7"
        stmts: Range<u32>,
    },
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
pub enum ConcurrentStmt<'a> {
    ConcurrentAssignment {
        label: Option<Span>, // cause for some reason concurrent assignment can have a label `my_label : data_bus(0) <= '1'``
        target: ExprId,
        expression: ExprId,
        after: Option<ExprId>,
    },

    // out_port <= a when control = '1' else b;
    ConditionalAssignment {
        target: &'a str,
    },

    // u_gate: and_gate port map (A => in1, B => in2, Y => out_port);
    ComponentInstantiation {
        label: Option<Span>,
        component_name: Span,
        arch_qualifier: Option<Span>, // Like (rtl)
        generic_map: Range<u32>,
        port_map: Range<u32>,
    },

    // My_Process: process(clk) begin ... end process;
    Process {
        label: Option<&'a str>,
        process_vars: Option<&'a str>,
        stmts: Range<u32>,
    },
}

#[derive(Debug, Clone)]
pub struct Architecture<'a> {
    pub name: &'a str,
    pub entity_name: Span,
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
pub struct AstArena<'a> {
    pub contexts: Vec<ContextItem<'a>>,
    pub ports: Vec<Port<'a>>,
    pub entities: Vec<Entity<'a>>,
    pub decls: Vec<Decl<'a>>,
    pub architectures: Vec<Architecture<'a>>,
    pub elsifs: Vec<ElsifBranch>, // Will HAve to have an indirection table as well TODO
    pub associations: Vec<Association>,

    pub sequential_stmts: Vec<SequentialStmt<'a>>,
    pub seq_stmt_lists: Vec<SeqStmtId>,

    pub concurrent_stmts: Vec<ConcurrentStmt<'a>>,
    pub conc_stmt_lists: Vec<ConcStmtId>,

    pub exprs: Vec<Expr<'a>>,
    pub expr_lists: Vec<ExprId>,
}
