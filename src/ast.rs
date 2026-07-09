use std::{fmt::Display, ops::Index};

use crate::{lexer::Span, parser};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ContextId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct PortId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct EntityId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DeclId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct StmtId(pub u32);
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ArchitectureId(pub u32);

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
pub enum Stmt<'a> {
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
        stmts_start: StmtId,
        stmts_end: StmtId,
    },

    // sig <= '1'; it looks like concurrent, but it's inside a clocked process
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
        then_start: StmtId,
        then_end: StmtId,
        else_start: Option<StmtId>,
        else_end: Option<StmtId>,
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
        stmts_start: StmtId,
        stmts_end: StmtId,
    },
}

#[derive(Debug, Clone)]
pub struct Architecture<'a> {
    pub name: &'a str,
    pub entity_name: &'a str,
    pub decls_start: DeclId,
    pub decls_end: DeclId,
    pub stmts_start: StmtId,
    pub stmts_end: StmtId,
}

#[derive(Default, Debug)]
pub struct AstArena<'a> {
    pub contexts: Vec<ContextItem<'a>>,
    pub ports: Vec<Port<'a>>,
    pub entities: Vec<Entity<'a>>,
    pub decls: Vec<Decl<'a>>,
    pub stmts: Vec<Stmt<'a>>,
    pub architectures: Vec<Architecture<'a>>,
    ref_to_text: &'a str,
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
    pub fn alloc_stmt(&mut self, stmt: Stmt<'a>) -> StmtId {
        let id = self.stmts.len() as u32;
        self.stmts.push(stmt);
        StmtId(id)
    }

    pub fn alloc_architecture(&mut self, arch: Architecture<'a>) -> ArchitectureId {
        let id = self.architectures.len() as u32;
        self.architectures.push(arch);
        ArchitectureId(id)
    }
    fn get_text(&self, span: Span) -> &'a str {
        &self.ref_to_text[span.start..span.end]
    }
}

impl<'a> std::fmt::Display for AstArena<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // write!(
        //     f,
        //     "{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?},\n\n{:?}",
        //     self.contexts, self.entities, self.ports, self.architectures, self.decls, self.stmts,
        // )
        for c in &self.contexts {
            writeln!(f, "\n{}", c)?;
        }

        for e in &self.entities {
            writeln!(f, "\n{}", e)?;
            for ports in &self.ports[e.ports_start.0 as usize..e.ports_end.0 as usize] {
                write!(f, "\t{}", ports)?;
            }
        }
        for a in &self.architectures {
            writeln!(f, "\n{}", a)?;
            writeln!(f, "Declarations:")?;
            for decls in &self.decls[a.decls_start.0 as usize..a.decls_end.0 as usize] {
                match decls {
                    Decl::Component {
                        name,
                        ports_start,
                        ports_end,
                    } => {
                        write!(f, "Component: {}", name)?;
                        for ports in &self.ports[ports_start.0 as usize..ports_end.0 as usize] {
                            write!(f, "{}", ports)?;
                        }
                    }
                    _ => (),
                }
                write!(f, "\t{}", decls)?;
            }
            writeln!(f, "Statements:")?;
            for stmts in &self.stmts {
                writeln!(f, "\t{}", stmts)?;
            }
        }
        Ok(())
    }
}
impl<'a> std::fmt::Display for Entity<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "Entity: {}", self.name)
    }
}

impl<'a> std::fmt::Display for Port<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "{}: {:?} {}", self.name, self.mode, self.port_type)
    }
}
impl<'a> std::fmt::Display for ContextItem<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ContextItem::Library { name } => write!(f, "Library: {}", name),
            ContextItem::Use { path } => write!(f, "Path: {}", path),
        }
    }
}
impl<'a> Display for Architecture<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "Architecture: {}, referencing {}",
            self.name, self.entity_name
        )
    }
}
impl<'a> Display for Decl<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Decl::Signal {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Signal: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
            Decl::Constant {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Constant: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
            Decl::Variable {
                name,
                decl_type,
                default_val,
            } => writeln!(
                f,
                "Variable: {}: {}, default: {:?}",
                name, decl_type, default_val
            ),
            Decl::Component {
                name: _,
                ports_start: _,
                ports_end: _,
            } => Err(std::fmt::Error),
        }
    }
}
impl<'a> Display for Stmt<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Stmt::ConcurrentAssignment {
                target,
                expression_span: _,
            } => write!(f, "Concurrent assignment: {}", target),
            Stmt::ConditionalAssignment { target } => todo!(),
            Stmt::ComponentInstantiation {
                label,
                component_name,
                port_map_span,
            } => todo!(),
            Stmt::Process {
                label,
                stmts_start,
                stmts_end,
            } => write!(f, "Process -> label: {:?}", label),
            Stmt::SequentialAssignment {
                target,
                expression_span,
            } => write!(f, "Sequential assignment: {}", target),
            Stmt::VariableAssignment {
                target,
                expression_span,
            } => todo!(),
            Stmt::If {
                condition_span,
                then_start,
                then_end,
                else_start,
                else_end,
            } => write!(f, "If statement: {:?}", condition_span),
            Stmt::Case {
                expression_span,
                cases_span,
            } => todo!(),
            Stmt::Loop {
                label,
                loop_scheme_span,
                stmts_start,
                stmts_end,
            } => todo!(),
        }
    }
}
