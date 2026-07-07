use std::fs;

use crate::{
    lexer::{Lexer, TokenKind},
    parser::Parser,
};

pub(crate) mod ast;
pub(crate) mod lexer;
mod parser;

fn main() {
    // let source_string = fs::read_to_string("test_files/and_gate.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/custom_types_pkg.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/latch_inference.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/param_mux.vhd").expect("Not found");
    // let source_string = fs::read_to_string("test_files/audio_testbench.vhd").expect("Not found");
    let source_string = fs::read_to_string("test_files/sine_wave_440hz.vhd").expect("Not found");

    // let mut lexer = Lexer::new(&source_string);

    let mut parser = Parser::new(&source_string);
    parser.parse();
    println!("{}", parser.arena);

    // loop {
    // let token = lexer.next_token();

    // println!("{:?}", token);

    // if token.kind == TokenKind::Eof {
    //     break;
    // }
    // }
}
