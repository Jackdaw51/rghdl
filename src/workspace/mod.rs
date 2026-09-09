mod workspace;

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
}