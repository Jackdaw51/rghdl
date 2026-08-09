use std::{fmt::Display, ops::Range};

use crate::parser::lexer::Span;

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
impl Display for BinaryOp {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            BinaryOp::Eq => write!(f, "="),
            BinaryOp::Neq => write!(f, "/="),
            BinaryOp::Lt => write!(f, "<"),
            BinaryOp::Lte => write!(f, "<="),
            BinaryOp::Gt => write!(f, ">"),
            BinaryOp::Gte => write!(f, ">="),
            BinaryOp::Add => write!(f, "+"),
            BinaryOp::Sub => write!(f, "-"),
            BinaryOp::Mul => write!(f, "*"),
            BinaryOp::Div => write!(f, "/"),
            BinaryOp::And => write!(f, "and"),
            BinaryOp::Or => write!(f, "or"),
            BinaryOp::Xor => write!(f, "xor"),
            BinaryOp::Nand => write!(f, "nand"),
            BinaryOp::Nor => write!(f, "nor"),
            BinaryOp::Arrow => write!(f, "=>"),
            BinaryOp::Concat => write!(f, "&"),
        }
    }
}

impl BinaryOp {
    /// Returns (left_binding_power, right_binding_power)
    pub fn binding_power(&self) -> (u8, u8) {
        match self {
            // Logical Operators (Lowest Precedence)
            BinaryOp::And | BinaryOp::Or | BinaryOp::Xor | BinaryOp::Nand | BinaryOp::Nor => {
                (10, 11)
            }

            BinaryOp::Arrow => (10, 11),

            // Relational Operators
            BinaryOp::Eq
            | BinaryOp::Neq
            | BinaryOp::Lt
            | BinaryOp::Lte
            | BinaryOp::Gt
            | BinaryOp::Gte => (20, 21),

            // Adding Operators
            BinaryOp::Add | BinaryOp::Sub => (30, 31),

            // Multiplying Operators 
            BinaryOp::Mul | BinaryOp::Div => (40, 41),

            BinaryOp::Concat => (10, 11), //TODO reviex
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnaryOp {
    Not,
    Neg,
    Plus,
    Abs,
}
impl Display for UnaryOp {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            UnaryOp::Not => write!(f, "not"),
            UnaryOp::Neg => write!(f, "-"),
            UnaryOp::Plus => write!(f, "+"),
            UnaryOp::Abs => write!(f, "abs"),
        }
    }
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
    Others {
        span: Span,
    },
    Aggregate {
        elements: Range<u32>,
        span: Span,
    },
    Slice {
        target: ExprId,
        direction: super::lexer::TokenKind,
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
impl<'a> Expr<'a> {
    pub(crate) fn span(&self) -> Span {
        match self {
            Expr::Literal { span, .. } => *span,
            Expr::Identifier { span, .. } => *span,
            Expr::Binary { span, .. } => *span,
            Expr::Unary { span, .. } => *span,
            Expr::Grouping { span, .. } => *span,
            Expr::CallOrIndex { span, .. } => *span,
            Expr::Others { span } => *span,
            Expr::Aggregate { span, .. } => *span,
            Expr::Slice { span, .. } => *span,
            Expr::RecordAccess { span, .. } => *span,
        }
    }
}

#[derive(Debug, Clone)]
pub enum ContextItem<'a> {
    Library { name: &'a str },
    Use { path: &'a str },
}

#[derive(Debug, Clone, PartialEq)]
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
    pub port_type: &'a str,
}
impl<'a> PartialEq for Port<'a> {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name && self.mode == other.mode && self.port_type == other.port_type
    }
}

#[derive(Debug, Clone)]
pub struct Entity<'a> {
    pub name: &'a str,
    pub name_span:Span,
    pub ports_start: PortId,
    pub ports_end: PortId,
}

#[derive(Debug, Clone)]
pub enum Decl<'a> {
    Signal {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<&'a str>,
    },
    Constant {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<&'a str>,
    },
    Variable {
        name: &'a str,
        decl_type: &'a str,
        default_val: Option<&'a str>,
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
pub enum ConcurrentStmt<'a> {
    ConcurrentAssignment {
        label: Option<Span>, // cause for some reason concurrent assignment can have a label `my_label : data_bus(0) <= '1'``
        target: ExprId,
        expression: ExprId,
    },

    // out_port <= a when control = '1' else b;
    ConditionalAssignment {
        target: &'a str,
    },

    // u_gate: and_gate port map (A => in1, B => in2, Y => out_port);
    ComponentInstantiation {
        label: &'a str,
        component_name: &'a str,
        port_map_span: Span,
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
    pub elsifs: Vec<ElsifBranch>, // can't be a simple statement otherwise you lose the slice trick

    pub sequential_stmts: Vec<SequentialStmt<'a>>,
    pub seq_stmt_lists: Vec<SeqStmtId>,

    pub concurrent_stmts: Vec<ConcurrentStmt<'a>>,
    pub conc_stmt_lists: Vec<ConcStmtId>,

    pub exprs: Vec<Expr<'a>>,
    pub expr_lists: Vec<ExprId>,
}
impl<'a> AstArena<'a> {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn alloc_port(&mut self, port: Port<'a>) -> PortId {
        let id = self.ports.len() as u32;
        self.ports.push(port);
        PortId(id)
    }

    pub fn alloc_entity(&mut self, entity: Entity<'a>) -> EntityId {
        let id = self.entities.len() as u32;
        self.entities.push(entity);
        EntityId(id)
    }
    pub fn alloc_context(&mut self, item: ContextItem<'a>) -> ContextId {
        let id = self.contexts.len() as u32;
        self.contexts.push(item);
        ContextId(id)
    }
    pub fn alloc_decl(&mut self, decl: Decl<'a>) -> DeclId {
        let id = self.decls.len() as u32;
        self.decls.push(decl);
        DeclId(id)
    }
    pub fn alloc_conc_stmt(&mut self, stmt: ConcurrentStmt<'a>) -> ConcStmtId {
        let id = self.concurrent_stmts.len() as u32;
        self.concurrent_stmts.push(stmt);
        ConcStmtId(id)
    }
    pub fn alloc_seq_stmt(&mut self, stmt: SequentialStmt<'a>) -> SeqStmtId {
        let id = self.sequential_stmts.len() as u32;
        self.sequential_stmts.push(stmt);
        SeqStmtId(id)
    }

    pub fn alloc_architecture(&mut self, arch: Architecture<'a>) -> ArchitectureId {
        let id = self.architectures.len() as u32;
        self.architectures.push(arch);
        ArchitectureId(id)
    }

    pub(crate) fn alloc_expr(&mut self, expr: Expr<'a>) -> ExprId {
        let id = self.exprs.len() as u32;
        self.exprs.push(expr);
        ExprId(id)
    }
}

impl<'a> std::fmt::Display for AstArena<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?}",
            self.contexts,
            self.entities,
            self.ports,
            self.architectures,
            self.decls,
            self.concurrent_stmts,
        )
    }
}
