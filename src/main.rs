#![doc = include_str!("../README.md")]


use std::fmt::Write;
use std::fs;

use crate::{analyzer::SemanticAnalyzer,analyzer::symbol_table::SymbolTable, parser::Parser, printer::FormatCtx};

mod analyzer;
mod parser;
mod printer;
mod elaborator;

fn main() {
    // let source_string = fs::read_to_string("test_files/and_gate.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    let mut parser = Parser::new(&source_string);
    parser.parse();
    let mut f = String::new();
    let a = write!(
        &mut f,
        "{}",
        FormatCtx {
            item: &parser.arena,
            source: &source_string,
            arena: &parser.arena,
            indent: 0
        }
    );
    a.unwrap();
    println!("{f}");

    // let mut parser_1 = Parser::new(&f);
    let mut a = SemanticAnalyzer::new(&parser.arena, SymbolTable::new(), &source_string);
    a.analyze_all();
    println!("{:?}", a.errors);
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
