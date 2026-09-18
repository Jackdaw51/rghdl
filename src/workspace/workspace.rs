use crate::{
    analyzer::{DeclRef, ScopeId, SemanticAnalyzer, SymbolTable},
    ast::AstArena,
    elaborator::{Elaborator, LibraryRegistry},
    parser::{ParseError, Parser},
    printer::{FormatCtx, SAFormatCtx, VhdlEmitter},
    workspace::{FileId, Workspace},
};
use std::fmt::Write;

impl<'a> Workspace<'a> {
    pub fn new(paths: Vec<&'a str>, strings: Vec<&'a str>) -> Self {
        Self {
            table: SymbolTable::new(),
            files: vec![],
            file_counter: 0,
            strings,
            paths,
            registry: LibraryRegistry::new(),
        }
    }
    pub fn get_file(&self, file_id: FileId) -> Option<&AstArena> {
        self.files.get(file_id.0 as usize)
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
            self.files.push(arena);
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
    pub fn analyze(&mut self, top_entity: &str) -> Option<String>{
        let registry = LibraryRegistry::initialize_builtins(&mut self.table.interner);
        let s_ref = &mut self.table;
        let asts = self.files.as_slice();

        let mut sa = SemanticAnalyzer::new(asts, s_ref, &registry);
        sa.analyze_all_entities(&registry);
        sa.analyze_all_archs(&registry);
        self.registry = registry;
        if !sa.errors.is_empty() {
            eprintln!(
                "Semantic Analysis failed with {} error(s):",
                // self.paths[i],
                sa.errors.len()
            );
            for err in &sa.errors {
                let i = err.file_id.0 as usize;
                eprintln!(
                    "  {}",
                    SAFormatCtx {
                        item: err,
                        arena: &self.files[i],
                        indent: 0,
                        sa: &sa,
                        path: self.paths[i],
                        source: self.strings[i],
                    }
                );
            }
            return None;
        }
        let mut elaborator = Elaborator::new(&sa);

        let top_instance = match elaborator.elaborate_all(&self.registry, top_entity) {
            Ok(inst) => inst,
            Err(err) => {
                eprintln!("Elaboration Error: {:?}", err);
                return None;
            }
        };

        let elaborated_vhdl = VhdlEmitter::new(&sa, &elaborator.arena)
            .emit_design(&top_instance)
            .expect("Something went wrong with vhdl emitting");

        Some(elaborated_vhdl)
    }
}
