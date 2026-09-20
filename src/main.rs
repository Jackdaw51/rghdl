#![doc = include_str!("../README.md")]

use std::{env, fs};

use crate::analyzer::{DeclRef, ScopeId, SemanticAnalyzer};
use crate::ast::AstArena;
use crate::elaborator::Elaborator;
use crate::printer::{FormatCtx, SAFormatCtx, VhdlEmitter};
use crate::validation::validation::{
    generate_all_equivalence_testbenches, run_all_equivalence_testbenches,
};
use crate::workspace::Workspace;

mod analyzer;
pub(crate) mod ast;
mod elaborator;
mod parser;
mod printer;
mod validation;
mod workspace;
const TOP_E_NAME: &str = "full_adder";
const FOLDER_NAME: &str = "velha_test_files";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = env::args().collect();

    let a = args.iter().enumerate().find(|p| *p.1 == "--top");

    let Some(b) = a else {
        return Err("Please specify a top level entity using --top".into());
    };
    let file_names: Vec<&String> = args.iter().skip(1).take(b.0 - 1).collect();
    let top_entity: Vec<&String> = args.iter().skip(b.0 + 1).collect();

    if top_entity.len() > 1 {
        return Err("Format is rghdl <file_names> --top <top_entity>".into());
    }

    let top_entity_name = if top_entity.len() == 0 {
        println!("Using default top entity name: {}", TOP_E_NAME);
        TOP_E_NAME
    } else {
        top_entity.first().unwrap()
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

    let paths: Vec<String> = file_names
        .iter()
        .map(|f| format!("{FOLDER_NAME}/{}.vhd", f))
        .collect();
    let paths: Vec<&str> = paths.iter().map(|p| p.as_str()).collect();

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
    let mut sa = SemanticAnalyzer::new(&workspace.asts, &mut workspace.table, &workspace.registry);
    match sa.analyze(&mut workspace.registry) {
        Ok(_) => {}
        Err(errors) => {
            for err in &errors {
                let i = err.file_id.0 as usize;
                eprintln!(
                    "  {}",
                    SAFormatCtx {
                        item: err,
                        arena: &sa.asts[i],
                        indent: 0,
                        sa: &sa,
                        path: workspace.paths[i],
                        source: workspace.strings[i],
                    }
                );
            }
            return Err(format!(
                "Semantic Analysis failed with {} error(s):",
                // self.paths[i],
                errors.len()
            )
            .into());
        }
    };

    let elaborator = Elaborator::new(&sa);

    let mut elaborator = Elaborator::new(&sa);

    let top_instance = match elaborator.elaborate_all(&workspace.registry, top_entity_name) {
        Ok(inst) => inst,
        Err(err) => {
            eprintln!("Elaboration Error: {:?}", err);
            return Ok(());
        }
    };

    let elaborated_vhdl = VhdlEmitter::new(&sa, &elaborator.arena)
        .emit_design(&top_instance)
        .expect("Something went wrong with vhdl emitting");

    print!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    let top_e_sym = sa
        .symbols
        .interner
        .get_symbol(top_entity_name)
        .ok_or_else(|| "Provided top_entity_name was not found in the files".to_string())?;

    let top_e_decl = sa.symbols.lookup_local(ScopeId(0), top_e_sym);

    let Some(DeclRef::Entity {
        file_id,
        entity_id,
        scope_id,
    }) = top_e_decl
    else {
        return Err(
            "Provided top_entity_name was found but failed to be initialized correctly".into(),
        );
    };
    let top_file = file_names[file_id.0 as usize];

    let mut other_files = file_names.clone();
    other_files.remove(file_id.0 as usize);

    let flattened = format!("velha_test_files/{}_flat.vhd", top_entity_name);

    let testbench = generate_all_equivalence_testbenches(&elaborator.arena, &sa, top_entity_name);

    fs::write(&flattened, &elaborated_vhdl)?;

    let tb_path = format!("velha_test_files/tb_{}_equiv.vhd",top_entity_name);
    fs::write(tb_path, &testbench)?;
    run_all_equivalence_testbenches(top_entity_name, top_file,other_files)?;
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
