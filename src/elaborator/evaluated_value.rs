use std::fmt;

use crate::elaborator::EvaluatedValue;

impl fmt::Display for EvaluatedValue {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            EvaluatedValue::Integer(val) => write!(f, "{val}"),
            EvaluatedValue::Boolean(val) => {
                write!(f, "{}", if *val { "TRUE" } else { "FALSE" })
            }
            EvaluatedValue::EnumLiteral(sym) => write!(f, "sym#{}", sym.0),
            EvaluatedValue::Vector(vals) => {
                write!(f, "(")?;
                for (i, val) in vals.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{val}")?;
                }
                write!(f, ")")
            }
        }
    }
}

impl EvaluatedValue {
    /// Formats the evaluated value into VHDL syntax using the interner to resolve `SymbolId`.
    pub fn to_vhdl_string(&self, interner: &crate::analyzer::SymbolInterner) -> String {
        match self {
            EvaluatedValue::Integer(val) => val.to_string(),
            EvaluatedValue::Boolean(val) => if *val { "true".to_string() } else { "false".to_string() },
            EvaluatedValue::EnumLiteral(sym) => {
                interner.get(*sym).to_string()
            }
            EvaluatedValue::Vector(vals) => {
                // If vector contains single-character enum literals (like std_logic '0'/'1'),
                // render as string literal "1010", otherwise render as aggregate string
                let is_bit_vector = vals.iter().all(|v| matches!(v, EvaluatedValue::EnumLiteral(_)));
                if is_bit_vector {
                    let bits: String = vals
                        .iter()
                        .map(|v| v.to_vhdl_string(interner))
                        .collect();
                    format!("\"{bits}\"")
                } else {
                    let elems: Vec<String> = vals
                        .iter()
                        .map(|v| v.to_vhdl_string(interner))
                        .collect();
                    format!("({})", elems.join(", "))
                }
            }
        }
    }
}