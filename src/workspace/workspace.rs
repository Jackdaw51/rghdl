use crate::{
    analyzer::SymbolTable,
    ast::AstArena,
    elaborator::LibraryRegistry,
    parser::{ParseError, Parser},
    printer::FormatCtx,
    workspace::{FileId, Workspace},
};
use std::fmt::Write;

impl<'a> Workspace<'a> {
    pub fn new(paths: Vec<&'a str>, strings: Vec<&'a str>) -> Self {
        let mut table = SymbolTable::new();
        let registry = LibraryRegistry::initialize_builtins(&mut table.interner);
        Self {
            asts: vec![],
            file_counter: 0,
            strings,
            paths,
            registry,
            table,
        }
    }
    pub fn get_file(&self, file_id: FileId) -> Option<&AstArena> {
        self.asts.get(file_id.0 as usize)
    }
    pub fn get_string(&self, file_id: FileId) -> Option<&&str> {
        self.strings.get(file_id.0 as usize)
    }

    pub fn parse(&mut self) -> Result<FileId, (FileId, Vec<ParseError>)> {
        let file_id = FileId(self.file_counter);
        for source in &self.strings {
            println!("Parsing {}", self.paths[self.file_counter as usize]);
            self.file_counter += 1;

            let mut parser = Parser::new(source, &mut self.table.interner);
            if parser.parse().is_err() {
                parser.print_errors();
                continue;
            };

            if !parser.errors.is_empty() {
                return Err((file_id, parser.errors));
            }
            let arena = parser.arena;
            self.asts.push(arena);
        }
        Ok(file_id)
    }
    pub fn print_ast(&mut self) -> Result<(), Box<dyn std::error::Error>> {
        let mut ast_dump = String::new();
        for file_id in (0..self.file_counter).map(|f| FileId(f)) {
            let arena = self.get_file(file_id).unwrap();
            let source_string = self.get_string(file_id).unwrap();
            write!(
                &mut ast_dump,
                "{}",
                FormatCtx {
                    item: arena,
                    source: source_string,
                    arena,
                    indent: 0,
                    symbols: &self.table.interner
                }
            )?;
            println!("=== Parsed AST ===\n{}", ast_dump);
        }
        Ok(())
    }
}
