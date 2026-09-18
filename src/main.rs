#![doc = include_str!("../README.md")]

use std::{env, fs};

use crate::ast::AstArena;
use crate::printer::FormatCtx;
use crate::validation::validation::run_ghdl_validation;
use crate::workspace::Workspace;

mod analyzer;
pub(crate) mod ast;
mod elaborator;
mod parser;
mod printer;
mod validation;
mod workspace;
const TOP_E_NAME: &str = "full_adder";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();
    if args.len() >= 3 {
        eprintln!("Maximum one top entity level name is expected");
        return Ok(());
    }

    let top_entity_name = match args.get(1) {
        Some(x) => x,
        None => {
            println!("Using default top entity name: {}", TOP_E_NAME);
            TOP_E_NAME
        }
    };

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
    // paths = vec![path_2];
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
    // workspace.print_ast()?;
    let sa = workspace.analyze(top_entity_name);
    let Some(elaborated_vhdl) = sa else {
        return Ok(());
    };
    print!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    let flattened = format!("flattened/{}_flat.vhd", top_entity_name);

    let top_e = format!("{top_entity_name}_flat");


    fs::write(&flattened, &elaborated_vhdl)?;
    run_ghdl_validation(&flattened, &top_e)?;

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
    return Ok(());
}
