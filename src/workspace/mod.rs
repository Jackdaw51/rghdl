mod workspace;

use std::fmt::Display;

use crate::analyzer::{SymbolInterner, SymbolTable};
use crate::ast::AstArena;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct FileId(pub u32);

pub struct Workspace<'a> {
    pub table: SymbolTable,
    files: Vec<AstArena>,
    strings: Vec<&'a str>,
    pub paths: Vec<&'a str>,
    file_counter: u32,
    pub(crate) registry: crate::elaborator::LibraryRegistry,
}
impl Display for FileId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}
