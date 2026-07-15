// Let's make this shi allocation free

use std::{iter::Peekable, str::Chars};

#[derive(Clone, Debug, PartialEq, Copy)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}
impl Token {
    fn new(kind: TokenKind, span: Span) -> Self {
        Self { kind, span }
    }
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct Span {
    pub start: usize,
    pub end: usize,
}

impl Span {
    fn new(start: usize, end: usize) -> Self {
        Self { start, end }
    }
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
];

pub struct Lexer<'a> {
    source: &'a str,
    chars: Peekable<Chars<'a>>,
    current_pos: usize,
    current_line: usize,
    cached: Option<Token>,
}

impl<'a> Lexer<'a> {
    pub fn new(source: &'a str) -> Self {
        Self {
            source,
            chars: source.chars().peekable(),
            current_pos: 0,
            current_line: 0,
            cached: None,
        }
    }

    fn next_token(&mut self) -> Token {
        self.skip_whitespace_and_comments();

        let start_pos = self.current_pos;

        // Peek at the next character to determine the token type
        if let Some(&ch) = self.chars.peek() {
            match ch {
                'a'..='z' | 'A'..='Z' => self.identifier_or_keyword(start_pos),
                '0'..='9' => self.number(start_pos),
                ':' | '<' | '=' => self.two_char(start_pos),
                ';' | '.' | '(' | ')' | ',' | '+' | '-' => self.single_digit(start_pos),
                '"' => self.string_lit(start_pos),
                '\'' => self.tick_or_char_lit(start_pos),
                x => self.unknown(x),
            }
        } else {
            Token {
                kind: TokenKind::Eof,
                span: Span {
                    start: start_pos,
                    end: start_pos,
                },
            }
        }
    }
    /// Consumes the next character and updates the byte offset
    fn advance(&mut self) -> Option<char> {
        if let Some(ch) = self.chars.next() {
            // ch.len_utf8() ensures we don't panic on multibyte characters
            self.current_pos += ch.len_utf8();
            if ch == '\n' {
                self.current_line += 1;
            }
            Some(ch)
        } else {
            None
        }
    }

    fn skip_whitespace_and_comments(&mut self) {
        loop {
            let remaining = &self.source[self.current_pos..];

            if remaining.starts_with("--") {
                self.skip_line_comment();
                continue; // Loop back around to check for more whitespace/comments
            }

            if remaining.starts_with("/*") {
                self.skip_block_comment();
                continue;
            }

            if let Some(&ch) = self.chars.peek() {
                if ch.is_whitespace() {
                    self.advance();
                    continue;
                }
            }

            break;
        }
    }

    /// Skips characters until a newline is found
    fn skip_line_comment(&mut self) {
        while let Some(&ch) = self.chars.peek() {
            if ch == '\n' {
                break; // Leave the newline to be eaten by the whitespace checker
            }
            self.advance();
        }
    }

    /// Skips characters until "*/" is found (Optional for VHDL-2019 support)
    fn skip_block_comment(&mut self) {
        // Eat the initial "/*" so we don't immediately trigger on it
        self.advance();
        self.advance();

        while let Some(_) = self.chars.peek() {
            let remaining = &self.source[self.current_pos..];
            if remaining.starts_with("*/") {
                self.advance();
                self.advance();
                break;
            }
            self.advance();
        }
    }

    fn identifier_or_keyword(&mut self, start_pos: usize) -> Token {
        let mut one_more = self.chars.clone();
        // Disallows __
        one_more.next();
        while let Some(c) = self.chars.peek() {
            match c {
                'a'..='z' | 'A'..='Z' | '_' | '0'..='9' => {
                    let Some(a) = one_more.next() else {
                        return self.error(start_pos);
                    };
                    if a == '_' && c == &'_' {
                        return self.error(start_pos);
                    }
                    if a == '"' && (c == &'b' || c == &'x' || c == &'B' || c == &'X') {
                        return self.bitstring_lit(start_pos);
                    }
                    self.advance();
                }
                _ => break,
            }
        }

        let s = &self.source[start_pos..self.current_pos];

        let a = KEYWORDS
            .iter()
            .find(|(k, _)| k.eq_ignore_ascii_case(&s))
            .map(|(_, tk)| tk.clone())
            .unwrap_or(TokenKind::Identifier);

        Token {
            kind: a,
            span: Span::new(start_pos, self.current_pos),
        }
    }

    fn two_char(&mut self, start_pos: usize) -> Token {
        let t;
        let iter_clone = self.chars.clone().skip(1).next();

        let Some(first_c) = self.chars.peek() else {
            return self.error(start_pos);
        };

        let Some(second_c) = iter_clone else {
            return self.error(start_pos);
        };
        // dbg!(first_c,second_c);

        t = match second_c {
            '=' => match first_c {
                '<' => TokenKind::OpSignalAssignOrLEq,
                ':' => TokenKind::OpAssign,
                '/' => TokenKind::OpNeq,
                '>' => TokenKind::OpGeq,
                _ => unreachable!(),
            },
            '>' => match first_c {
                '=' => TokenKind::OpArrow,
                '<' => TokenKind::OpBox,
                _ => unreachable!(),
            },
            _ => return self.single_digit(start_pos),
        };
        self.advance();
        self.advance();
        Token::new(t, Span::new(start_pos, self.current_pos))
    }

    fn error(&self, start_pos: usize) -> Token {
        Token::new(TokenKind::Error, Span::new(start_pos, self.current_pos))
    }

    fn unknown(&self, c: char) -> Token {
        panic!("unknown character '{}' at line {}", c, self.current_line);
    }

    fn single_digit(&mut self, start_pos: usize) -> Token {
        let mut t = TokenKind::Error;
        if let Some(c) = self.advance() {
            t = match c {
                '.' => TokenKind::Dot,
                ',' => TokenKind::Comma,
                ';' => TokenKind::Semicolon,
                '(' => TokenKind::LParen,
                ')' => TokenKind::RParen,
                '<' => TokenKind::OpLt,
                '>' => TokenKind::OpGt,
                '=' => TokenKind::OpEq,
                ':' => TokenKind::Colon,
                '+' => TokenKind::OpPlus,
                '-' => TokenKind::OpMinus,
                _ => unreachable!(),
            }
        }
        Token::new(t, Span::new(start_pos, self.current_pos))
    }

    fn tick_or_char_lit(&mut self, start_pos: usize) -> Token {
        let Some(cloned_char) = self.chars.clone().skip(2).next() else {
            return self.error(start_pos);
        };
        match cloned_char {
            '\'' => {
                self.advance();
                self.advance();
                self.advance();
                Token::new(TokenKind::CharLit, Span::new(start_pos, self.current_pos))
            }
            _ => {
                self.advance();
                Token::new(TokenKind::Tick, Span::new(start_pos, self.current_pos))
            }
        }
    }

    fn consume_decimal_digits(&mut self) {
        while let Some(&ch) = self.chars.peek() {
            if ch.is_ascii_digit() || ch == '_' {
                self.advance();
            } else {
                break;
            }
        }
    }

    /// Consumes hex digits (0-9, A-F, a-f) and underscores for based numbers
    fn consume_hex_digits(&mut self) {
        while let Some(&ch) = self.chars.peek() {
            if ch.is_ascii_hexdigit() || ch == '_' {
                self.advance();
            } else {
                break;
            }
        }
    }

    fn number(&mut self, start_pos: usize) -> Token {
        self.consume_decimal_digits();

        // based number (16#FF#)
        if let Some(&'#') = self.chars.peek() {
            self.advance();
            self.consume_hex_digits();

            if let Some(&'#') = self.chars.peek() {
                self.advance();
            }
        }
        // real number
        else if let Some(&'.') = self.chars.peek() {
            let mut lookahead = self.chars.clone();
            lookahead.next();

            if let Some(next_ch) = lookahead.next() {
                if next_ch.is_ascii_digit() {
                    self.advance();
                    self.consume_decimal_digits();
                }
            }
        }
        if let Some(&ch) = self.chars.peek() {
            if ch == 'e' || ch == 'E' {
                let mut lookahead = self.chars.clone();
                lookahead.next();

                let next_ch = lookahead.next();

                let is_valid_exp = match next_ch {
                    Some('+') | Some('-') => lookahead.next().map_or(false, |c| c.is_ascii_digit()),
                    Some(c) if c.is_ascii_digit() => true,
                    _ => false,
                };

                if is_valid_exp {
                    self.advance();

                    if let Some(&sign) = self.chars.peek() {
                        if sign == '+' || sign == '-' {
                            self.advance();
                        }
                    }

                    self.consume_decimal_digits();
                }
            }
        }

        Token {
            kind: TokenKind::Number,
            span: Span {
                start: start_pos,
                end: self.current_pos,
            },
        }
    }

    fn string_lit(&mut self, start_pos: usize) -> Token {
        let mut t: TokenKind = TokenKind::Error;
        self.advance();
        while let Some(x) = self.chars.peek() {
            if x == &'"' {
                t = TokenKind::StringLit;
                self.advance();
                break;
            }
            self.advance();
        }

        Token::new(t, Span::new(start_pos, self.current_pos))
    }

    fn bitstring_lit(&mut self, start_pos: usize) -> Token {
        let mut t: TokenKind = TokenKind::Error;
        self.advance();
        self.advance();
        while let Some(x) = self.chars.peek() {
            if x == &'"' {
                t = TokenKind::BitStringLit;
                self.advance();
                break;
            }
            self.advance();
        }

        Token::new(t, Span::new(start_pos, self.current_pos))
    }

    pub fn peek(&mut self) -> Token {
        if let Some(token) = self.cached {
            return token;
        }

        let token = self.next_token();
        self.cached = Some(token);
        token
    }
    pub fn next(&mut self) -> Token{
        if let Some(token) = self.cached.take(){
            return token;
        }
        self.next_token()
    }
}
