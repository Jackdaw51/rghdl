#![doc = include_str!("../README.md")]

use std::process::Command;
use std::time::Instant;
use std::{env, fs};

use crate::analyzer::{DeclRef, ScopeId, SemanticAnalyzer};
use crate::ast::AstArena;
use crate::elaborator::Elaborator;
use crate::printer::{ElaboratedFormatCtx, FormatCtx, SAFormatCtx, VhdlEmitter};
use crate::validation::validation::{
    generate_all_equivalence_testbenches, run_all_equivalence_testbenches,
};
use crate::workspace::Workspace;

#[cfg(feature = "dhat-heap")]
#[global_allocator]
static ALLOC: dhat::Alloc = dhat::Alloc;

mod analyzer;
pub(crate) mod ast;
mod elaborator;
mod parser;
mod printer;
mod validation;
mod workspace;
const TOP_E_NAME: &str = "full_adder";
const FOLDER_NAME: &str = "velha_test_files";
const TEST_FOLDER_NAME: &str = "testsuite-vests_vhdl-93_billowitch_non_compliant_analyzer_failure";

fn main() -> Result<(), Box<dyn std::error::Error>> {
    #[cfg(feature = "dhat-heap")]
    let _profiler = dhat::Profiler::new_heap();

    let now = Instant::now();

    let args: Vec<String> = env::args().collect();

    let a = args.iter().enumerate().find(|p| *p.1 == "--top");
    let is_test = args.iter().enumerate().find(|p| *p.1 == "--test");

    if let Some(a) = is_test {
        return run_tests(args);
    }
    let Some(b) = a else {
        return Err("Please specify a top level entity using --top".into());
    };

    let file_names: Vec<&String> = args.iter().skip(1).take(b.0 - 1).collect();
    let top_entity: Vec<&String> = args.iter().skip(b.0 + 1).collect();

    if top_entity.len() > 1 {
        return Err("Format is rghdl <file_names> --top <top_entity>".into());
    }

    // let path = "test_files/and_gate.vhd";
    // let path = "test_files/audio_testbench.vhd";
    // let path = "test_files/sine_wave_440hz.vhd";
    // let path_1 = "velha_test_files/01_nand2.vhd";
    // let path_2 = "velha_test_files/02_primitives.vhd";
    // let path_3 = "velha_test_files/03_adders.vhd";
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

    let mut workspace = Workspace::new(paths.clone(), strings);
    let file = match workspace.parse() {
        Ok(x) => x,
        Err(x) => {
            let a: Vec<&&str> = x.iter().map(|f| paths.get(f.0 as usize).unwrap()).collect();
            eprintln!("Errors found in:");
            for i in a {
                println!("\t{i}");
            }
            return Err(format!("Parsing failed").into());
            // return Ok(());
        }
    };
    let top_entity_name = if top_entity.len() == 0 {
        let name = workspace
            .asts
            .first()
            .unwrap()
            .entities
            .get(0)
            .ok_or_else(|| "No entity found!".to_string())?
            .name;
        let name = workspace.table.interner.get(name).to_string();

        println!("Using found default top entity name: {}", name);
        name
    } else {
        top_entity.first().unwrap().to_string()
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

    // let elaborator = Elaborator::new(&sa);

    let mut elaborator = Elaborator::new(&sa);

    let top_instance = match elaborator.elaborate_top(&workspace.registry, &top_entity_name) {
        Ok(inst) => inst,
        Err(err) => {
            eprintln!(
                "Elaboration Error: {}",
                ElaboratedFormatCtx {
                    item: &err,
                    arena: &elaborator.arena,
                    sa: &sa,
                    indent: 0,
                    path: &workspace.paths,
                    source: &workspace.strings,
                }
            );
            return Ok(());
        }
    };

    let elaborated_vhdl = VhdlEmitter::new(&sa, &elaborator.arena)
        .emit_design(&top_instance)
        .expect("Something went wrong with vhdl emitting");

    eprintln!(
        "[RGH_TIMING] {},{}",
        top_entity_name,
        now.elapsed().as_micros()
    );
    return Ok(());
    // println!(
    //     "Design {} elaborated and emitted in {} micros",
    //     top_entity_name,
    //     now.elapsed().as_micros()
    // );
    // print!("=== Elaborated VHDL Output ===\n{}", elaborated_vhdl);

    // drop(_profiler);
    // return Ok(());

    let top_e_sym = sa
        .symbols
        .interner
        .get_symbol(&top_entity_name)
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

    let flattened = format!("velha_test_files/{}_flat.vhd", top_file);

    let testbench = generate_all_equivalence_testbenches(
        &elaborator.arena,
        &sa,
        &top_entity_name,
        top_instance.root_instance,
    );

    fs::write(&flattened, &elaborated_vhdl)?;

    let tb_path = format!("velha_test_files/tb_{}_equiv.vhd", top_entity_name);
    fs::write(tb_path, &testbench)?;
    run_all_equivalence_testbenches(&top_entity_name, top_file, other_files)?;
    eprintln!(
        "[RGH_TIMING] {},{}",
        top_entity_name,
        now.elapsed().as_micros()
    );
    return Ok(());
}

const FAILURES: &[i32] = &[
    44, 46, 49, 60, 75, 85, 96, 189, 190, 191, 192, 193, 345, 733, 736, 738, 739, 766, 767, 769,
    770, 771, 773, 774, 775, 828, 944, 963, 994, 1014, 1016, 1068, 1184, 1185, 1186, 1188, 1189,
    1190, 1191, 1193, 1194, 1195, 1196, 1198, 1200, 1201, 1202, 1204, 1217, 1219, 1228, 1231, 1235,
    1236, 1237, 1238, 1239, 1241, 1242, 1243, 1244, 1245, 1246, 1247, 1250, 1251, 1252, 1253, 1254,
    1264, 1293, 1308, 1329, 1330, 1333, 1334, 1345, 1346, 1407, 1417, 1419, 1430, 1537, 1538, 1682,
    1700, 1702, 1706, 1715, 1726, 1755, 1780, 1783, 1786, 1796, 1979, 2036, 2037, 2038, 2039, 2040,
    2041, 2042, 2043, 2047, 2048, 2049, 2050, 2051, 2052, 2312, 2314, 2318, 2319, 2335, 2336, 2337,
    2341, 2348, 2349, 2350, 2354, 2397, 2409, 2413, 2571, 2577, 2714, 2715, 2716, 2717, 2727, 2749,
    2750, 2751, 2752, 2754, 2755, 2756, 2757, 2766, 2857, 2858, 2859, 3027, 3031,
];
const RECOGNIZED: &[i32] = &[
    12, 42, 48, 50, 58, 65, 129, 130, 221, 714, 715, 716, 718, 720, 726, 732, 806, 807, 811, 812,
    813, 815, 818, 819, 1041, 1270, 1275, 1276, 1277, 1278, 1279, 1284, 1290, 1291, 1295, 1296,
    1301, 1302, 1305, 1324, 1325, 1326, 1352, 1353, 1357, 1358, 1382, 1383, 1396, 1433, 1437, 1438,
    1439, 1440, 1454, 1455, 1645, 1652, 1716, 1722, 1741, 1777, 1791, 1797, 1799, 1800, 1805, 1806,
    1905, 1913, 2029, 2030, 2031, 2032, 2066, 2075, 2278, 2279, 2313, 2572, 2580, 2631, 2632, 2644,
    2678, 2692, 2741, 2770, 2772, 2773, 2774, 2775, 2776, 2777, 2778, 2779, 2780, 2781, 2782, 2783,
    2784, 2785, 2786, 2787, 2788, 2789, 2790, 2791, 2792, 2793, 2794, 2795, 2796, 2797, 2798, 2799,
    2800, 2801, 2802, 2803, 2804, 2805, 2806, 2807, 2808, 2809, 2810, 2811, 2812, 2813, 2814, 2815,
    2816, 2817, 2818, 2819, 2820, 2821, 2822, 2823, 2824, 2825, 2826, 2827, 2828, 2829, 2830, 2831,
    2832, 2833, 2834, 2835, 2836, 2837, 2838, 2839, 2840, 2841, 2842, 2843, 2844, 2845, 2846, 2847,
    2848, 2849, 2850, 2851, 2852, 3020, 3021, 3087, 3207,
];

fn run_tests(args: Vec<String>) -> Result<(), Box<dyn std::error::Error>> {
    let a = match args.get(2) {
        Some(x) => x,
        None => "*",
    };
    if a == "*" {
        let b = fs::read_dir(TEST_FOLDER_NAME).unwrap();
        let mut count = 0;
        for i in b {
            count += 1;
        }
        println!(
            "failures: {}, recognized: {}, total: {}",
            FAILURES.len(),
            RECOGNIZED.len(),
            count - 1
        );
        // return Ok(());
        // let min = FAILURES.last().max(RECOGNIZED.last()).unwrap();
        // for i in *min..3208 {
        for i in 1..3208 {
            if FAILURES.contains(&i) || RECOGNIZED.contains(&i) {
                continue;
            }
            let output = Command::new("cargo")
                .args(["run", format!("tc{i}").as_str(), "--top"])
                .output()?;
            let stderr = String::from_utf8_lossy(&output.stderr);
            let stdout = String::from_utf8_lossy(&output.stdout);
            println!("{}", stdout);

            if stderr.contains("Not yet implemented") {
                println!("Not yet implemented for tc{i}");
                continue;
            }

            if stderr.contains("Not found: Os") {
                continue;
            }

            if !output.status.success() {
                println!("{}", stderr);
                return Err("Test not successfull".into());
            }
        }
        return Ok(());
    }
    let output = Command::new("cargo").args(["run", a, "--top"]).output()?;
    let stderr = String::from_utf8_lossy(&output.stderr);
    let stdout = String::from_utf8_lossy(&output.stdout);

    if stderr.contains("Not yet implemented") {
        println!("Not yet implemented");
        return Ok(());
    }

    if stderr.contains("Not found: Os") {}
    println!("{}", stderr);

    if !output.status.success() {
        return Err("Test not successfull".into());
    }
    println!("{}", stdout);
    Ok(())
}
