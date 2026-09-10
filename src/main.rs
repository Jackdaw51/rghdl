#![doc = include_str!("../README.md")]

use std::collections::HashMap;
use std::fs;
use std::{fmt::Write, process::Command};

use crate::ast::{AstArena, ContextItem, Entity, Expr, Port, PortMode};
use crate::elaborator::{ElaboratedArena, ElaboratedDesign, LibraryRegistry};
use crate::printer::{SAFormatCtx, VhdlEmitter};
use crate::workspace::Workspace;
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
mod workspace;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // let path = "test_files/and_gate.vhd";
    let path = "test_files/audio_testbench.vhd";
    // let path = "test_files/sine_wave_440hz.vhd";
    let path_1 = "velha_test_files/01_nand2.vhd";
    let path_2 = "velha_test_files/02_primitives.vhd";
    let path_3 = "velha_test_files/03_adders.vhd";
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    let mut paths: Vec<&str> = vec![path_2, path_3];
    paths = vec![path_1];
    let strings: Vec<String> = paths
        .iter()
        .map(|f| fs::read_to_string(f).expect("Not found"))
        .collect();
    let strings = strings.iter().map(|f| f.as_str()).collect();

    let mut workspace = Workspace::new(paths, strings);

    let file = match workspace.parse() {
        Ok(x) => x,
        Err(x) => {
            eprintln!("Parsing failed with {} error(s):", x.1.len());
            let source_string = workspace.get_string(x.0).unwrap();
            for err in &x.1 {
                eprintln!(
                    "  {}",
                    FormatCtx {
                        item: err,
                        source: source_string,
                        arena: &AstArena::new(),
                        indent: 0,
                        symbols: &workspace.table.interner
                    }
                );
            }
            return Ok(());
        }
    };
    workspace.print_ast()?;
    workspace.analyze();
    return Ok(());

    // let mut s_table = SymbolTable::new();
    // let registry = LibraryRegistry::initialize_builtins(&mut s_table.interner);

    // let mut sa = SemanticAnalyzer::new(&parser.arena, s_table, &source_string, &registry);
    // sa.analyze_all(&registry);

    // if !sa.errors.is_empty() {
    //     eprintln!(
    //         "Semantic Analysis failed with {} error(s):",
    //         sa.errors.len()
    //     );
    //     for err in &sa.errors {
    //         eprintln!(
    //             "  {}",
    //             SAFormatCtx {
    //                 item: err,
    //                 source: &source_string,
    //                 arena: &parser.arena,
    //                 indent: 0,
    //                 sa: &sa
    //             }
    //         );
    //     }
    //     return Ok(());
    // }

    // let ast = &parser.arena;
    // let mut elaborator = Elaborator::new(ast, &sa);

    // let top_entity_ast = ast.entities.first().ok_or("No entity found in AST")?;

    // let top_instance = match elaborator.elaborate_all(&registry, top_entity_ast.name) {
    //     Ok(inst) => inst,
    //     Err(err) => {
    //         eprintln!("Elaboration Error: {:?}", err);
    //         return Ok(());
    //     }
    // };

    // let elaborated_vhdl = VhdlEmitter::new(&sa, &elaborator.arena)
    //     .emit_design(&top_instance)
    //     .expect("Something went wrong with vhdl emitting");

    // print!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    // let output_path = &path.replace("velha_test_files/", "");
    // let name = &output_path.replace(".vhd", "");
    // let flattened = format!("velha_test_files/{}_flat.vhd", name);

    // fs::write(&flattened, &elaborated_vhdl)?;

    // let testbench = generate_all_equivalence_testbenches(&elaborator.arena, &sa);

    // fs::write("velha_test_files/tb_equiv.vhd", &testbench)?;
    // run_all_equivalence_testbenches(name, &sa)?;
    // // run_ghdl_validation(&flattened, top_entity_ast.name)?;
    // // run_ghdl_validation("test_files/tb_equiv.vhd", "and_gate")?;

    // Ok(())
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
