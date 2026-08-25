use std::{fmt::Display, ops::Range};

use crate::{
    ast::{
        Architecture, ArchitectureId, AstArena, BinaryOp, ConcStmtId, ConcurrentStmt, ContextId,
        ContextItem, Decl, DeclId, Entity, EntityId, Expr, ExprId, Port, PortId, SeqStmtId,
        SequentialStmt, UnaryOp,
    },
    parser::{Span, TokenKind},
};

// Arena

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
    pub fn ports(&self, entity: &Entity) -> &[Port<'a>] {
        &self.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize]
    }

    pub(crate) fn declarations(&self, arch: &Architecture<'a>) -> &[Decl<'a>] {
        &self.decls[arch.decls_start.0 as usize..arch.decls_end.0 as usize]
    }

    pub(crate) fn seq_statements(
        &'a self,
        range: Range<u32>,
    ) -> impl Iterator<Item = &SequentialStmt> {
        let seq_ids = &self.seq_stmt_lists[range.start as usize..range.end as usize];

        seq_ids
            .iter()
            .map(|id| &self.sequential_stmts[id.0 as usize])
    }
    pub(crate) fn conc_statements(
        &self,
        range: Range<u32>,
    ) -> impl Iterator<Item = &ConcurrentStmt> {
        let conc_ids = &self.conc_stmt_lists[range.start as usize..range.end as usize];
        conc_ids
            .iter()
            .map(|id| &self.concurrent_stmts[id.0 as usize])
    }

    pub(crate) fn expr(&self, target: ExprId) -> &Expr<'a> {
        &self.exprs[target.0 as usize]
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

// Expression

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
            Expr::PhysicalLiteral { span, .. } => *span,
        }
    }
}

// Binary Operation

impl BinaryOp {
    /// Returns (left_binding_power, right_binding_power)
    pub fn binding_power(&self) -> (u8, u8) {
        match self {
            // Logical Operators (Lowest Precedence)
            BinaryOp::And | BinaryOp::Or | BinaryOp::Xor | BinaryOp::Nand | BinaryOp::Nor => {
                (10, 11)
            }

            BinaryOp::Arrow => (5, 6),

            // Relational Operators
            BinaryOp::Eq
            | BinaryOp::Neq
            | BinaryOp::Lt
            | BinaryOp::Lte
            | BinaryOp::Gt
            | BinaryOp::Gte => (20, 21),

            // Adding Operators
            BinaryOp::Add | BinaryOp::Sub | BinaryOp::Concat => (30, 31),

            // Multiplying Operators
            BinaryOp::Mul | BinaryOp::Div => (50, 51),
        }
    }
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

// Unary Operator

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

// Port

impl<'a> PartialEq for Port<'a> {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name && self.mode == other.mode && self.port_type == other.port_type
    }
}
