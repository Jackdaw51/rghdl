use std::{collections::HashMap, process::Command};

use crate::{
    analyzer::{DeclRef, ScopeId, SemanticAnalyzer},
    ast::{ContextItem, Entity, EntityId, Expr, Port, PortMode},
    elaborator::ElaboratedArena,
    workspace::FileId,
};

pub fn run_ghdl_validation(
    file_path: &str,
    top_entity: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    println!("[GHDL Verification] Analyzing elaborated code...");

    dbg!(file_path);
    let synth_status = Command::new("ghdl")
        .args(["-e", "--workdir=flattened", top_entity])
        .status()?;

    if !synth_status.success() {
        return Err("Original GHDL failed to elaborate output of rghdl elaborator!".into());
    }

    println!("[GHDL Verification] SUCCESS: Output accepted by GHDL!");
    Ok(())
}

// /// Runs GHDL analysis once, then elaborates and simulates the specific testbench for `analyzed_entity`.
pub fn run_equivalence_testbench(
    file_prefix: &str,
    analyzed_entity: &str,
) -> Result<(), Box<dyn std::error::Error>> {
    let folder = "velha_test_files";
    let normal = format!("{folder}/{}.vhd", file_prefix);
    let flat = format!("{folder}/{}_flat.vhd", file_prefix);
    let tb = format!("{folder}/tb_equiv.vhd");
    let tb_entity_name = format!("tb_{}_equiv", analyzed_entity);

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
    top_e_name: &str,
    top_file: &str,
    other_files: Vec<&String>,
) -> Result<(), Box<dyn std::error::Error>> {
    let folder = "velha_test_files";
    let other_files: Vec<String> = other_files
        .iter()
        .map(|f| format!("{folder}/{}.vhd", f))
        .collect();
    let mut other_files: Vec<&str> = other_files.iter().map(|f| f.as_str()).collect();
    let normal = format!("{folder}/{}.vhd", top_file);
    let flat = format!("{folder}/{}_flat.vhd", top_file);
    let tb = format!("{folder}/tb_{}_equiv.vhd", top_e_name);

    Command::new("ghdl").args(["--clean"]).status()?;
    // Command::new("del").args(["-f",".\\work-obj93.cf"]).status()?;

    let mut args = vec!["-a", "--workdir=velha_test_files"];
    args.append(&mut other_files);
    args.push(&normal);
    args.push(&flat);
    args.push(&tb);
    let output = Command::new("ghdl").args(args).output()?;
    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        let stdout = String::from_utf8_lossy(&output.stdout);

        eprintln!(
            "\n\
         === GHDL STDERR ===\n{}\n\
         === GHDL STDOUT ===\n{}",
            stderr.trim(),
            stdout.trim()
        );

        return Err("Original GHDL failed to analyze VHDL source files".into());
    }

    let tb_unit = format!("tb_{}_equiv", top_e_name);

    let synth_status = Command::new("ghdl")
        .args(["-e", "--workdir=velha_test_files", &tb_unit])
        .status()?;

    if !synth_status.success() {
        return Err(format!("GHDL elaboration failed for unit '{}'", tb_unit).into());
    }

    let sim_status = Command::new("ghdl")
        .args([
            "-r",
            "--workdir=velha_test_files",
            &tb_unit,
            "--assert-level=error",
        ])
        .status()?;

    if !sim_status.success() {
        return Err(format!("Equivalence check failed for unit '{}'", tb_unit).into());
    }

    println!(
        "PASS: Unit '{}' equivalence verified successfully.",
        tb_unit
    );

    Ok(())
}
// /// Helper to resolve the type string directly from the AST port type expression.
fn get_port_type_name<'a>(sa: &'a SemanticAnalyzer<'a>, port: &Port, file_id: FileId) -> &'a str {
    let ast = sa.get_ast(file_id);
    let expr = &ast.exprs[port.port_type.0 as usize];
    match expr {
        Expr::Identifier { name } => sa.get_str(*name),
        _ => "std_logic",
    }
}

// /// Emits standard libraries and forwards all user-defined library/use clauses from the AST.
fn generate_context_header(sa: &SemanticAnalyzer) -> String {
    let mut header =
        String::from("library ieee;\nuse ieee.std_logic_1164.all;\nuse ieee.numeric_std.all;\n");

    // for item in &sa.ast.contexts {
    //     match item {
    //         ContextItem::Library { name } => {
    //             if !name.eq_ignore_ascii_case("ieee") {
    //                 header.push_str(&format!("library {};\n", name));
    //             }
    //         }
    //         ContextItem::Use { path } => {
    //             if !path.to_lowercase().starts_with("ieee.std_logic_1164")
    //                 && !path.to_lowercase().starts_with("ieee.numeric_std")
    //             {
    //                 header.push_str(&format!("use {};\n", path));
    //             }
    //         }
    //     }
    // }

    // header.push('\n');
    header
}

/// Generates a VHDL file containing equivalence testbenches for ALL entities in the AST.
pub fn generate_all_equivalence_testbenches(
    arena: &ElaboratedArena,
    sa: &SemanticAnalyzer,
    top_entity: &str,
) -> String {
    let mut full_tb_code = String::new();
    let file_id = FileId(0);

    let top_entity_sym = sa.symbols.interner.get_symbol(top_entity).expect("AAA");
    let top_entity_decl = sa
        .symbols
        .lookup_local(ScopeId(0), top_entity_sym)
        .expect("BBB");

    let (top_entity_id, top_e_file_id, scope_id) = match top_entity_decl {
        DeclRef::Entity {
            file_id,
            entity_id,
            scope_id,
        } => (*entity_id, *file_id, *scope_id),
        _ => return "CCC".to_string(),
    };

    full_tb_code.push_str(&generate_context_header(sa));
    let single_tb = generate_single_entity_tb(top_entity_id, top_e_file_id, arena, sa);
    full_tb_code.push_str(&single_tb);
    full_tb_code.push_str("\n-- ========================================================\n\n");

    full_tb_code
}

fn generate_single_entity_tb(
    entity_id: EntityId,
    file_id: FileId,
    _arena: &ElaboratedArena,
    sa: &SemanticAnalyzer,
) -> String {
    let ast = sa.get_ast(file_id);
    let entity = &ast.entities[entity_id.0 as usize];
    let orig_entity_name = sa.get_str(entity.name);
    let flat_entity_name = format!("{}_flat", orig_entity_name);
    let tb_entity_name = format!("tb_{}_equiv", orig_entity_name);

    let target_archs: Option<Vec<&str>> =
        sa.entity_architectures.get(&(entity_id, file_id)).map(|v| {
            v.iter()
                .map(|f| {
                    let DeclRef::Architecture {
                        file_id,
                        ast_id,
                        entity_tuple,
                        scope_id,
                    } = f
                    else {
                        panic!();
                    };
                    let arch = &ast.architectures[ast_id.0 as usize];
                    sa.symbols.interner.get(arch.name)
                })
                .collect()
        });

    let target_archs = match target_archs {
        Some(x) => x,
        None => vec!["behavioral"],
    };

    let mut signal_decls = String::new();
    let mut port_maps: HashMap<&str, String> =
        target_archs.iter().map(|&a| (a, String::new())).collect();

    // Per-architecture port map storage for flattened entities
    let mut flat_port_maps: HashMap<&str, String> =
        target_archs.iter().map(|&a| (a, String::new())).collect();

    let mut input_ports: Vec<(String, String)> = Vec::new();
    let mut output_ports: Vec<(String, String)> = Vec::new();

    let ports = &ast.ports[entity.ports_start.0 as usize..entity.ports_end.0 as usize];

    for port in ports {
        let port_name = sa.get_str(port.name);
        let type_str = get_port_type_name(sa, port, file_id);

        match port.mode {
            PortMode::In => {
                signal_decls.push_str(&format!("    signal {} : {};\n", port_name, type_str));
                for arch in &target_archs {
                    port_maps
                        .get_mut(arch)
                        .unwrap()
                        .push_str(&format!("        {} => {},\n", port_name, port_name));
                    flat_port_maps
                        .get_mut(arch)
                        .unwrap()
                        .push_str(&format!("        {} => {},\n", port_name, port_name));
                }
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

                    let sig_flat = format!("{}_{}_flat", port_name, arch);
                    signal_decls.push_str(&format!("    signal {} : {};\n", sig_flat, type_str));
                    flat_port_maps
                        .get_mut(arch)
                        .unwrap()
                        .push_str(&format!("        {} => {},\n", port_name, sig_flat));
                }

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

    for &arch in &target_archs {
        let raw_flat_pm = &flat_port_maps[arch];
        let clean_flat_pm = raw_flat_pm
            .trim_end()
            .strip_suffix(',')
            .unwrap_or(raw_flat_pm);
        instance_blocks.push_str(&format!(
            "    U_{}_FLAT: entity work.{}({})\n        port map (\n{}\n        );\n\n",
            arch.to_uppercase(),
            flat_entity_name,
            arch,
            clean_flat_pm
        ));
    }

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
                for &arch in &target_archs {
                    let sig_arch = format!("{}_{}", port_name, arch);
                    let sig_flat = format!("{}_{}_flat", port_name, arch);
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
            for &arch in &target_archs {
                let sig_arch = format!("{}_{}", port_name, arch);
                let sig_flat = format!("{}_{}_flat", port_name, arch);
                stimulus_process.push_str(&format!(
                    "        assert {} = {}\n            report \"Equivalence Mismatch on entity '{}', port '{}' (arch '{}')\" severity error;\n",
                    sig_flat, sig_arch, orig_entity_name, port_name, arch
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
