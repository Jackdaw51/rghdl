#![doc = include_str!("../README.md")]

use std::collections::HashMap;
use std::fs;
use std::{fmt::Write, process::Command};

use crate::analyzer::{TypeId, TypeKind};
use crate::ast::{ContextItem, Entity, Expr, Port, PortMode};
use crate::elaborator::{ElaboratedArena, ElaboratedDesign, LibraryRegistry};
use crate::printer::{SAFormatCtx, VhdlEmitter};
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
    // let path = "test_files/and_gate.vhd";
    // let path = "test_files/audio_testbench.vhd";
    // let path = "test_files/sine_wave_440hz.vhd";
    // let path = "velha_test_files/01_nand2.vhd";
    let path = "velha_test_files/02_primitives.vhd";
    let source_string = fs::read_to_string(path).expect("Not found");
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    let mut parser = Parser::new(&source_string);
    parser.parse();
    if !parser.errors.is_empty() {
        eprintln!("Parsing failed with {} error(s):", parser.errors.len());
        for err in &parser.errors {
            eprintln!(
                "  {}",
                FormatCtx {
                    item: err,
                    source: &source_string,
                    arena: &parser.arena,
                    indent: 0,
                }
            );
        }
        return Ok(());
    }
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

    let mut s_table = SymbolTable::new();
    let registry = LibraryRegistry::initialize_builtins(&mut s_table.interner);

    let mut sa = SemanticAnalyzer::new(&parser.arena, s_table, &source_string, &registry);
    sa.analyze_all(&registry);

    if !sa.errors.is_empty() {
        eprintln!(
            "Semantic Analysis failed with {} error(s):",
            sa.errors.len()
        );
        for err in &sa.errors {
            eprintln!(
                "  {}",
                SAFormatCtx {
                    item: err,
                    source: &source_string,
                    arena: &parser.arena,
                    indent: 0,
                    sa: &sa
                }
            );
        }
        return Ok(());
    }

    let ast = &parser.arena;
    let mut elaborator = Elaborator::new(ast, &sa);

    let top_entity_ast = ast.entities.first().ok_or("No entity found in AST")?;

    let top_instance = match elaborator.elaborate_all(&registry, top_entity_ast.name) {
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

    let output_path = &path.replace("velha_test_files/", "");
    let name = &output_path.replace(".vhd", "");
    let flattened = format!("velha_test_files/{}_flat.vhd", name);

    fs::write(&flattened, &elaborated_vhdl)?;

    let testbench = generate_all_equivalence_testbenches(&elaborator.arena, &sa);

    fs::write("velha_test_files/tb_equiv.vhd", &testbench)?;
    run_all_equivalence_testbenches(name, &sa)?;
    // run_ghdl_validation(&flattened, top_entity_ast.name)?;
    // run_ghdl_validation("test_files/tb_equiv.vhd", "and_gate")?;

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

fn run_ghdl_validation(
    file_path: &str,
    top_entity: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    println!("[GHDL Verification] Analyzing elaborated code...");

    let analyze_status = Command::new("ghdl").args(["-a", file_path]).status()?;

    if !analyze_status.success() {
        return Err("Original GHDL failed to parse/analyze output of rghdl elaborator!".into());
    }

    let synth_status = Command::new("ghdl").args(["-e", top_entity]).status()?;

    if !synth_status.success() {
        return Err("Original GHDL failed to elaborate output of rghdl elaborator!".into());
    }

    println!("[GHDL Verification] SUCCESS: Output accepted by GHDL!");
    Ok(())
}

/// Runs GHDL analysis once, then elaborates and simulates the specific testbench for `analyzed_entity`.
pub fn run_equivalence_testbench(
    file_prefix: &str,
    analyzed_entity: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let folder = "velha_test_files";
    let normal = format!("{folder}/{}.vhd", file_prefix);
    let flat = format!("{folder}/{}_flat.vhd", file_prefix);
    let tb = format!("{folder}/tb_equiv.vhd");
    let tb_entity_name = format!("tb_{}_equiv", analyzed_entity);

    dbg!(&normal, &flat, &tb_entity_name);

    let analyze_status = Command::new("ghdl")
        .args(["-a", &normal, &flat, &tb])
        .status()?;

    if !analyze_status.success() {
        return Err("Original GHDL failed to parse/analyze VHDL design files!".into());
    }

    let synth_status = Command::new("ghdl")
        .args(["-e", &tb_entity_name])
        .status()?;

    if !synth_status.success() {
        return Err(format!(
            "Original GHDL failed to elaborate testbench unit '{}'!",
            tb_entity_name
        )
        .into());
    }

    let simulation_status = Command::new("ghdl")
        .args(["-r", &tb_entity_name, "--assert-level=error"])
        .status()?;

    if !simulation_status.success() {
        return Err(format!("Equivalence test failed for entity '{}'!", analyzed_entity).into());
    }

    println!(
        "SUCCESS: Simulation for '{}' matched exactly!",
        tb_entity_name
    );
    Ok(())
}

/// Analyzes all files once, then iterates over every entity in the AST to elaborate
/// and simulate its corresponding testbench unit.
pub fn run_all_equivalence_testbenches(
    file_prefix: &str,
    sa: &SemanticAnalyzer,
) -> Result<(), Box<dyn std::error::Error>> {
    let folder = "velha_test_files";
    let normal = format!("{folder}/{}.vhd", file_prefix);
    let flat = format!("{folder}/{}_flat.vhd", file_prefix);
    let tb = format!("{folder}/tb_equiv.vhd");

    let analyze_status = Command::new("ghdl")
        .args(["-a", &normal, &flat, &tb])
        .status()?;

    if !analyze_status.success() {
        return Err("Original GHDL failed to analyze VHDL source files!".into());
    }

    for entity in &sa.ast.entities {
        let tb_unit = format!("tb_{}_equiv", entity.name);

        let synth_status = Command::new("ghdl").args(["-e", &tb_unit]).status()?;

        if !synth_status.success() {
            return Err(format!("GHDL elaboration failed for unit '{}'", tb_unit).into());
        }

        let sim_status = Command::new("ghdl")
            .args(["-r", &tb_unit, "--assert-level=error"])
            .status()?;

        if !sim_status.success() {
            return Err(format!("Equivalence check failed for unit '{}'", tb_unit).into());
        }

        println!(
            "PASS: Unit '{}' equivalence verified successfully.",
            tb_unit
        );
    }

    Ok(())
}
/// Helper to resolve the type string directly from the AST port type expression.
fn get_port_type_name<'a>(sa: &'a SemanticAnalyzer<'a>, port: &Port<'a>) -> &'a str {
    let expr = &sa.ast.exprs[port.port_type.0 as usize];
    match expr {
        Expr::Identifier { name, .. } => name,
        _ => "std_logic",
    }
}

/// Emits standard libraries and forwards all user-defined library/use clauses from the AST.
fn generate_context_header(sa: &SemanticAnalyzer) -> String {
    let mut header =
        String::from("library ieee;\nuse ieee.std_logic_1164.all;\nuse ieee.numeric_std.all;\n");

    for item in &sa.ast.contexts {
        match item {
            ContextItem::Library { name } => {
                if !name.eq_ignore_ascii_case("ieee") {
                    header.push_str(&format!("library {};\n", name));
                }
            }
            ContextItem::Use { path } => {
                if !path.to_lowercase().starts_with("ieee.std_logic_1164")
                    && !path.to_lowercase().starts_with("ieee.numeric_std")
                {
                    header.push_str(&format!("use {};\n", path));
                }
            }
        }
    }

    header.push('\n');
    header
}

/// Generates a VHDL file containing equivalence testbenches for ALL entities in the AST.
pub fn generate_all_equivalence_testbenches(
    arena: &ElaboratedArena,
    sa: &SemanticAnalyzer,
) -> String {
    let mut full_tb_code = String::new();

    for entity in &sa.ast.entities {
        full_tb_code.push_str(&generate_context_header(sa));
        let single_tb = generate_single_entity_tb(entity, arena, sa);
        full_tb_code.push_str(&single_tb);
        full_tb_code.push_str("\n-- ========================================================\n\n");
    }

    full_tb_code
}

fn generate_single_entity_tb(
    entity: &Entity,
    _arena: &ElaboratedArena,
    sa: &SemanticAnalyzer,
) -> String {
    let orig_entity_name = entity.name;
    let flat_entity_name = format!("{}_flat", orig_entity_name);
    let tb_entity_name = format!("tb_{}_equiv", orig_entity_name);

    // All architectures targeting this specific entity
    let target_archs: Vec<&str> = sa
        .ast
        .architectures
        .iter()
        .filter_map(|arch| {
            let entity_span_str = &sa.source[arch.entity_name.start..arch.entity_name.end];
            if entity_span_str.eq_ignore_ascii_case(orig_entity_name) {
                Some(arch.name)
            } else {
                None
            }
        })
        .collect();

    let target_archs = if target_archs.is_empty() {
        vec!["behavioral"]
    } else {
        target_archs
    };

    let mut signal_decls = String::new();
    let mut port_maps: HashMap<&str, String> =
        target_archs.iter().map(|&a| (a, String::new())).collect();
    let mut flat_port_map = String::new();

    let mut input_ports: Vec<(String, String)> = Vec::new();
    let mut output_ports: Vec<(String, String)> = Vec::new();

    let ports = &sa.ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];

    for port in ports {
        let port_name = port.name;
        let type_str = get_port_type_name(sa, port);

        match port.mode {
            PortMode::In => {
                signal_decls.push_str(&format!("    signal {} : {};\n", port_name, type_str));
                for arch in &target_archs {
                    port_maps
                        .get_mut(arch)
                        .unwrap()
                        .push_str(&format!("        {} => {},\n", port_name, port_name));
                }
                flat_port_map.push_str(&format!("        {} => {},\n", port_name, port_name));
                input_ports.push((port_name.to_string(), type_str.to_string()));
            }
            PortMode::Out | PortMode::InOut | PortMode::Buffer => {
                for arch in &target_archs {
                    let sig_arch = format!("{}_{}", port_name, arch);
                    signal_decls.push_str(&format!("    signal {} : {};\n", sig_arch, type_str));
                    port_maps
                        .get_mut(arch)
                        .unwrap()
                        .push_str(&format!("        {} => {},\n", port_name, sig_arch));
                }

                let sig_flat = format!("{}_flat", port_name);
                signal_decls.push_str(&format!("    signal {} : {};\n", sig_flat, type_str));
                flat_port_map.push_str(&format!("        {} => {},\n", port_name, sig_flat));

                output_ports.push((port_name.to_string(), type_str.to_string()));
            }
        }
    }

    let mut instance_blocks = String::new();
    for &arch in &target_archs {
        let raw_pm = &port_maps[arch];
        let clean_pm = raw_pm.trim_end().strip_suffix(',').unwrap_or(raw_pm);
        instance_blocks.push_str(&format!(
            "    U_{}: entity work.{}({})\n        port map (\n{}\n        );\n\n",
            arch.to_uppercase(),
            orig_entity_name,
            arch,
            clean_pm
        ));
    }

    let clean_flat_pm = flat_port_map
        .trim_end()
        .strip_suffix(',')
        .unwrap_or(&flat_port_map);
    instance_blocks.push_str(&format!(
        "    U_FLAT: entity work.{}\n        port map (\n{}\n        );\n\n",
        flat_entity_name, clean_flat_pm
    ));

    let mut stimulus_process = String::new();
    let num_inputs = input_ports.len();

    if num_inputs > 0 {
        let num_vectors = 1 << num_inputs.min(8);

        for vec in 0..num_vectors {
            stimulus_process.push_str(&format!("        -- Stimulus Vector {}\n", vec));

            for (idx, (in_name, type_str)) in input_ports.iter().enumerate() {
                let is_bit_high = (vec & (1 << idx)) != 0;
                let val_str = match type_str.as_str() {
                    "boolean" => {
                        if is_bit_high {
                            "true"
                        } else {
                            "false"
                        }
                    }
                    "integer" => {
                        if is_bit_high {
                            "1"
                        } else {
                            "0"
                        }
                    }
                    _ => {
                        if is_bit_high {
                            "'1'"
                        } else {
                            "'0'"
                        }
                    }
                };
                stimulus_process.push_str(&format!("        {} <= {};\n", in_name, val_str));
            }

            stimulus_process.push_str("        wait for 10 ns;\n");

            for (port_name, _) in &output_ports {
                let sig_flat = format!("{}_flat", port_name);
                for &arch in &target_archs {
                    let sig_arch = format!("{}_{}", port_name, arch);
                    stimulus_process.push_str(&format!(
                        "        assert {} = {}\n            report \"Equivalence Mismatch on entity '{}', port '{}' (arch '{}') for vector {}\" severity error;\n",
                        sig_flat, sig_arch, orig_entity_name, port_name, arch, vec
                    ));
                }
            }
            stimulus_process.push('\n');
        }
    } else {
        stimulus_process.push_str("        wait for 10 ns;\n");
        for (port_name, _) in &output_ports {
            let sig_flat = format!("{}_flat", port_name);
            for &arch in &target_archs {
                let sig_arch = format!("{}_{}", port_name, arch);
                stimulus_process.push_str(&format!(
                    "        assert {} = {}\n            report \"Equivalence Mismatch on entity '{}', port '{}' (arch '{}')\" severity error;\n",
                    orig_entity_name, sig_arch, sig_flat, port_name, arch
                ));
            }
        }
    }

    format!(
        r#"entity {} is
end entity {};

architecture behavioral of {} is
{}
begin
{}    STIMULUS_PROC: process
    begin
{}        wait;
    end process;
end architecture;"#,
        tb_entity_name,
        tb_entity_name,
        tb_entity_name,
        signal_decls,
        instance_blocks,
        stimulus_process
    )
}
