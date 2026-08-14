#![doc = include_str!("../README.md")]

use std::fmt::Write;
use std::fs;

use crate::{
    analyzer::{SemanticAnalyzer, SymbolTable},
    elaborator::Elaborator,
    parser::Parser,
    printer::{ElaboratedFormatCtx, FormatCtx},
};

mod analyzer;
pub(crate) mod ast;
mod elaborator;
mod parser;
mod printer;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let source_string = fs::read_to_string("test_files/and_gate.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    let mut parser = Parser::new(&source_string);
    parser.parse();

    // Optional: Debug print parsed AST
    let mut ast_dump = String::new();
    write!(
        &mut ast_dump,
        "{}",
        FormatCtx {
            item: &parser.arena,
            source: &source_string,
            arena: &parser.arena,
            indent: 0,
        }
    )?;
    println!("=== Parsed AST ===\n{}", ast_dump);

    let mut sa = SemanticAnalyzer::new(&parser.arena, SymbolTable::new(), &source_string);
    sa.analyze_all();

    if !sa.errors.is_empty() {
        eprintln!(
            "Semantic Analysis failed with {} error(s):",
            sa.errors.len()
        );
        for err in &sa.errors {
            eprintln!("  {:?}", err);
        }
        return Ok(());
    }

    let ast = &parser.arena;
    let mut elaborator = Elaborator::new(ast, &sa);

    let top_entity_ast = ast.entities.first().ok_or("No entity found in AST")?;

    let top_instance = match elaborator.elaborate_top(top_entity_ast.name) {
        Ok(inst) => inst,
        Err(err) => {
            eprintln!("Elaboration Error: {:?}", err);
            return Ok(());
        }
    };

    let fmt_ctx = ElaboratedFormatCtx {
        item: &top_instance,
        arena: &elaborator.arena,
        sa: &sa,
        indent: 0,
    };

    let mut elaborated_vhdl = String::new();
    write!(&mut elaborated_vhdl, "{}", fmt_ctx)?;

    println!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    Ok(())
    // println!("{:?}",a.symbols);

    // parser_1.parse();
    // let format = FormatCtx {
    //         item: &parser_1.arena,
    //         source: &f,
    //         arena: &parser_1.arena,
    //         indent: 0
    //     };
    // println!("{format}");

}
