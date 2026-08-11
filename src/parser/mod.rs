use std::{iter::Peekable, str::Chars};

use crate::parser::ast::AstArena;

mod architecture;
pub(crate) mod ast;
mod entity;
mod expressions;
pub(crate) mod lexer;
mod library;
mod parser;
mod tests;

#[derive(Clone, Debug, PartialEq, Copy)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct Span {
    pub start: usize,
    pub end: usize,
}

#[derive(Clone, Debug, PartialEq, Copy)]
pub enum TokenKind {
    Identifier,
    Number,       // 16#FF#, 3.14
    StringLit,    // "Marco"
    CharLit,      // '1', 'Z'
    BitStringLit, // x"FF", b"1010"

    KwEntity,
    KwArchitecture,
    KwPackage,
    KwIs,
    KwPort,
    KwGeneric,
    KwBegin,
    KwEnd,
    KwProcess,
    KwIf,
    KwThen,
    KwElse,
    KwElsif,
    KwLibrary,
    KwUse,
    KwAll,
    KwIn,
    KwOut,
    KwInOut,
    KwBuffer,
    KwOf,
    KwSignal,
    KwConstant,
    KwComponent,
    KwVariable,
    KwNot,
    KwOthers,
    KwDownto,
    KwTo,
    KwAnd,
    KwOr,
    KwXor,
    KwNand,
    KwNor,
    KwAbs,

    // TODO * and /
    OpAssign,            // :=
    OpArrow,             // => (Port mapping)
    OpSignalAssignOrLEq, // <= Signal assignment or less equal
    OpEq,                // =
    OpNeq,               // /=
    OpLt,                // <
    OpGt,                // >
    OpGeq,               // >=
    OpBox,               // <> (Unconstrained range)
    OpPlus,              // +
    OpMinus,             // -
    OpStar,              // *
    OpSlash,             // /
    Colon,               // :
    Semicolon,           // ;
    Comma,               // ,
    Dot,                 // .
    Tick,                // '
    LParen,              // (
    RParen,              // )

    Eof,
    Error,
}

const KEYWORDS: &[(&str, TokenKind)] = &[
    ("library", TokenKind::KwLibrary),
    ("entity", TokenKind::KwEntity),
    ("architecture", TokenKind::KwArchitecture),
    ("package", TokenKind::KwPackage),
    ("is", TokenKind::KwIs),
    ("port", TokenKind::KwPort),
    ("generic", TokenKind::KwGeneric),
    ("begin", TokenKind::KwBegin),
    ("end", TokenKind::KwEnd),
    ("process", TokenKind::KwProcess),
    ("if", TokenKind::KwIf),
    ("then", TokenKind::KwThen),
    ("else", TokenKind::KwElse),
    ("elsif", TokenKind::KwElsif),
    ("use", TokenKind::KwUse),
    ("all", TokenKind::KwAll),
    ("in", TokenKind::KwIn),
    ("out", TokenKind::KwOut),
    ("inout", TokenKind::KwInOut),
    ("buffer", TokenKind::KwBuffer),
    ("of", TokenKind::KwOf),
    ("signal", TokenKind::KwSignal),
    ("constant", TokenKind::KwConstant),
    ("component", TokenKind::KwComponent),
    ("variable", TokenKind::KwVariable),
    ("not", TokenKind::KwNot),
    ("others", TokenKind::KwOthers),
    ("downto", TokenKind::KwDownto),
    ("to", TokenKind::KwTo),
    ("and", TokenKind::KwAnd),
    ("not", TokenKind::KwNot),
    ("or", TokenKind::KwOr),
    ("xor", TokenKind::KwXor),
    ("nand", TokenKind::KwNand),
    ("nor", TokenKind::KwNor),
    ("abs", TokenKind::KwAbs),
];

pub struct Lexer<'a> {
    source: &'a str,
    chars: Peekable<Chars<'a>>,
    current_pos: usize,
    current_line: usize,
    cached_0: Option<Token>,
    cached_1: Option<Token>,
}

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct ContextId(pub u32);
// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct PortId(pub u32);
// #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
// pub struct EntityId(pub u32);
// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct ArchitectureId(pub u32);

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct SeqStmtId(pub u32);

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct ConcStmtId(pub u32);

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct DeclId(pub u32);

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
// pub struct ExprId(pub u32);

// #[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinaryOp {
    // Relational (Return BOOLEAN)
    Eq,
    Neq,
    Lt,
    Lte,
    Gt,
    Gte,
    // Arithmetic (Return same as operands)
    Add,
    Sub,
    Mul,
    Div,
    Concat, //&
    // Logical (Return same as operands)
    And,
    Or,
    Xor,
    Nand,
    Nor,

    Arrow, // TODO should make sure it disallows stuff like a=>b
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnaryOp {
    Not,
    Neg,
    Plus,
    Abs,
}


#[derive(Debug, Clone)]
pub struct ParseError {
    pub kind: ParseErrorKind,
    pub span: Span,
}

pub type ParseResult<T> = Result<T, ParseError>;

/// Usage (found, span, expected[4])
#[macro_export]
macro_rules! exp_tks {
    ($found:expr, $span:expr, $t1:expr) => {
        return Err($crate::parser::ParseError {
            kind: ParseErrorKind::ExpectedTokens {
                expected: [Some($t1), None, None, None],
                found: $found,
            },
            span: $span,
        })
    };
    ($found:expr, $span:expr, $t1:expr, $t2:expr) => {
        return Err($crate::parser::ParseError {
            kind: ParseErrorKind::ExpectedTokens {
                expected: [Some($t1), Some($t2), None, None],
                found: $found,
            },
            span: $span,
        })
    };
    ($found:expr, $span:expr, $t1:expr, $t2:expr, $t3:expr) => {
        return Err($crate::parser::ParseError {
            kind: ParseErrorKind::ExpectedTokens {
                expected: [Some($t1), Some($t2), Some($t3), None],
                found: $found,
            },
            span: $span,
        })
    };
    ($found:expr, $span:expr, $t1:expr, $t2:expr, $t3:expr, $t4:expr) => {
        return Err($crate::parser::ParseError {
            kind: ParseErrorKind::ExpectedTokens {
                expected: [Some($t1), Some($t2), Some($t3), Some($t4)],
                found: $found,
            },
            span: $span,
        })
    };
}
pub struct Parser<'a> {
    pub(crate) lexer: Lexer<'a>,
    pub arena: AstArena<'a>,
    pub source: &'a str,
    errors: Vec<ParseError>,
}
#[derive(Debug, Clone)]
pub enum ParseErrorKind {
    ExpectedToken {
        expected: TokenKind,
        found: TokenKind,
    },
    ExpectedTokens {
        expected: [Option<TokenKind>; 4],
        found: TokenKind,
    },
    NameMismatch {
        expected_span: Span,
        found_span: Span,
    },
    UnexpectedEof,
}