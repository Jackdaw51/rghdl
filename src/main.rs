#![doc = include_str!("../README.md")]

use std::fs;
use std::{fmt::Write, process::Command};

use crate::ast::PortMode;
use crate::elaborator::{ElaboratedDesign, LibraryRegistry};
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
    let path = "test_files/audio_testbench.vhd";
    // let path = "test_files/sine_wave_440hz.vhd";
    let source_string = fs::read_to_string(path).expect("Not found");
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    let mut parser = Parser::new(&source_string);
    parser.parse();
    dbg!("something");

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

    return Ok(());

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
            eprintln!("  {:?}", err);
        }
        return Ok(());
    }

    let ast = &parser.arena;
    let mut elaborator = Elaborator::new(ast, &sa);

    let top_entity_ast = ast.entities.first().ok_or("No entity found in AST")?;

    let top_instance = match elaborator.elaborate_top(top_entity_ast.name, &registry) {
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

    print!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    let output_path = &path.replace("test_files/", "");
    let name = &output_path.replace(".vhd", "");
    let flattened = format!("test_files/{}_flat.vhd", name);

    fs::write(&flattened, &elaborated_vhdl)?;

    let testbench = generate_equivalence_testbench(&top_instance, name, &elaborator.sa);

    fs::write("test_files/tb_equiv.vhd", &testbench)?;
    // run_ghdl_validation(&flattened, top_entity_ast.name)?;
    // run_ghdl_validation("test_files/tb_equiv.vhd", "and_gate")?;

    run_equivalence_testbench(top_entity_ast.name)?;

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

pub fn run_equivalence_testbench(analyzed_entity: &str) -> Result<(), Box<dyn std::error::Error>> {
    let normal = format!("test_files/{}.vhd", analyzed_entity);
    let flat = format!("test_files/{}_flat.vhd", analyzed_entity);
    let analyze_status = Command::new("ghdl")
        .args(["-a", &normal, &flat, "test_files/tb_equiv.vhd"])
        .status()?;

    if !analyze_status.success() {
        return Err("Original GHDL failed to parse/analyze output of rghdl elaborator!".into());
    }

    let synth_status = Command::new("ghdl").args(["-e", "tb_equiv"]).status()?;

    if !synth_status.success() {
        return Err("Original GHDL failed to elaborate output of rghdl elaborator!".into());
    }

    let simulation_status = Command::new("ghdl")
        .args(["-r", "tb_equiv", "--assert-level=error"])
        .status()?;

    if !simulation_status.success() {
        return Err("The simulation for the two elaborated files did not correspond".into());
    }

    println!("SUCCESS: the simulation behaved the same in both files!");
    Ok(())
}
pub fn generate_equivalence_testbench(
    design: &ElaboratedDesign,
    orig_entity_name: &str,
    sa: &crate::analyzer::SemanticAnalyzer,
) -> String {
    let top = &design.top_instance;
    let flat_entity_name = format!("{}_flat", orig_entity_name);

    let mut signal_decls = String::new();
    let mut port_maps_orig = String::new();
    let mut port_maps_flat = String::new();
    let mut assertions = String::new();

    let mut input_ports: Vec<(String, String)> = Vec::new(); // (name, type_str)
    let mut output_ports: Vec<(String, String, String)> = Vec::new(); // (port_name, sig_orig, sig_flat)

    for port in &top.ports {
        let port_name = sa.symbols.interner.get(port.name);
        let port_type = sa.types.get(port.type_id);

        let a = match port_type {
            Some(x) => match x {
                analyzer::TypeKind::Enum { name, literals } => name,
                analyzer::TypeKind::Integer { name } => todo!(),
                analyzer::TypeKind::Real { name } => todo!(),
                analyzer::TypeKind::Array { name, element_type } => todo!(),
                analyzer::TypeKind::Record { name, fields } => todo!(),
                analyzer::TypeKind::Function {
                    name,
                    args,
                    return_type,
                } => todo!(),
                analyzer::TypeKind::Error => todo!(),
            },
            None => todo!(),
        };
        let port_type = sa.symbols.interner.get(*a);

        match port.mode {
            PortMode::In => {
                signal_decls.push_str(&format!("    signal {} : {};\n", port_name, port_type));
                port_maps_orig.push_str(&format!("            {} => {},\n", port_name, port_name));
                port_maps_flat.push_str(&format!("            {} => {},\n", port_name, port_name));
                input_ports.push((port_name.into(), port_type.into()));
            }
            PortMode::Out | PortMode::InOut | PortMode::Buffer => {
                let sig_orig = format!("{}_orig", port_name);
                let sig_flat = format!("{}_flat", port_name);

                signal_decls.push_str(&format!("    signal {} : std_logic;\n", sig_orig));
                signal_decls.push_str(&format!("    signal {} : std_logic;\n", sig_flat));

                port_maps_orig.push_str(&format!("            {} => {},\n", port_name, sig_orig));
                port_maps_flat.push_str(&format!("            {} => {},\n", port_name, sig_flat));

                output_ports.push((port_name.into(), sig_orig, sig_flat));
            }
        }
    }

    let mut stimulus_process = String::new();
    let num_inputs = input_ports.len();

    if num_inputs > 0 {
        // Cap truth table generation to prevent massive files (up to 2^8 = 256 vectors)
        let num_vectors = 1 << num_inputs.min(8);

        for vec in 0..num_vectors {
            stimulus_process.push_str(&format!("        -- Stimulus Vector {}\n", vec));

            // Apply bit pattern across all input signals
            for (idx, (in_name, _)) in input_ports.iter().enumerate() {
                let bit_val = if (vec & (1 << idx)) != 0 {
                    "'1'"
                } else {
                    "'0'"
                };
                stimulus_process.push_str(&format!("        {} <= {};\n", in_name, bit_val));
            }

            stimulus_process.push_str("        wait for 10 ns;\n");

            // Assert output equivalence between original and flattened entities
            for (port_name, sig_orig, sig_flat) in &output_ports {
                stimulus_process.push_str(&format!(
                    "        assert {} = {}\n            report \"Equivalence Mismatch on port '{}' for vector {}\" severity error;\n",
                    sig_orig, sig_flat, port_name, vec
                ));
            }
            stimulus_process.push('\n');
        }
    } else {
        // no input ports
        stimulus_process.push_str("        wait for 10 ns;\n");
        for (port_name, sig_orig, sig_flat) in &output_ports {
            stimulus_process.push_str(&format!(
                "        assert {} = {}\n            report \"Equivalence Mismatch on port '{}'\" severity error;\n",
                sig_orig, sig_flat, port_name
            ));
        }
    }

    format!(
        r#"library ieee;
use ieee.std_logic_1164.all;

entity tb_equiv is
end entity tb_equiv;

architecture behavioral of tb_equiv is
{}
begin
    U_ORIG: entity work.{}
        port map (
{}        );

    U_FLAT: entity work.{}
        port map (
{}        );

    STIMULUS_PROC: process
    begin
{}        wait;
    end process;
end architecture;"#,
        signal_decls,
        orig_entity_name,
        port_maps_orig.trim_end_matches(",\n"),
        flat_entity_name,
        port_maps_flat.trim_end_matches(",\n"),
        stimulus_process
    )
}
