use std::ops::{Index, Range};

use crate::lexer::Span;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ContextId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PortId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct EntityId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ArchitectureId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ElsifId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SeqStmtId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ConcStmtId(pub u32);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DeclId(pub u32);

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
    pub mode: PortMode,
    pub port_type: &'a str,
}

#[derive(Debug, Clone)]
pub struct Entity<'a> {
    pub name: &'a str,
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
        target: &'a str,
        expression_span: Span,
    },
    // var := var + 1;
    VariableAssignment {
        target: &'a str,
        expression_span: Span,
    },
    // if condition then ... else ... end if;
    If {
        condition_span: Span,
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
}

#[derive(Debug, Clone)]
pub enum ConcurrentStmt<'a> {
    ConcurrentAssignment {
        target: &'a str,
        expression_span: Span,
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
        stmts: Range<u32>,
    },
}

#[derive(Debug, Clone)]
pub struct Architecture<'a> {
    pub name: &'a str,
    pub entity_name: &'a str,
    pub decls_start: DeclId,
    pub decls_end: DeclId,
    pub stmts: Range<u32>,
}

#[derive(Debug, Clone)]
pub struct ElsifBranch {
    pub condition_span: Span,
    pub stmts: Range<u32>,
}

#[derive(Default, Debug)]
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
    pub fn alloc_seq_stmt(&mut self,stmt:SequentialStmt<'a>)->SeqStmtId{
        let id = self.sequential_stmts.len() as u32;
        self.sequential_stmts.push(stmt);
        SeqStmtId(id)
    }

    pub fn alloc_architecture(&mut self, arch: Architecture<'a>) -> ArchitectureId {
        let id = self.architectures.len() as u32;
        self.architectures.push(arch);
        ArchitectureId(id)
    }
}

impl<'a> std::fmt::Display for AstArena<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?}",
            self.contexts, self.entities, self.ports, self.architectures, self.decls, self.concurrent_stmts,
        )
    }
}