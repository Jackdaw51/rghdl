# VHDL parser/elaborator test corpus

Every positive file below has been analysed successfully by GHDL 4.1.0
(`--std=93c`, except rung 8 which requires `--std=08`). Every negative file
has been confirmed to produce the diagnostic quoted in `oracle_93c.txt`.
Regenerate the oracle with `./run_oracle.sh` (set `STD=08` for the 2008 pass).

## Positive rungs

| File | What it targets |
|---|---|
| `01_smoke/nand2.vhd` | Context clause, entity with generic + ports, one concurrent assignment, physical literal, `after`. |
| `01_smoke/primitives.vhd` | **Several design units per file.** Three spellings of `end` (bare / keyword / keyword+label). Two architectures of one entity. |
| `02_structural/adders.vhd` | Component declaration vs direct entity instantiation; positional vs named association; `open`; generic maps; `for`/`if` generate incl. a generate with its own declarative part; guarded `block` with a `bus`-kind signal. |
| `03_behavioral/alu.vhd` | Process with sensitivity list and process driven by `wait`; function + procedure in the declarative part; `if/elsif`; `case` with choice lists and choice ranges; `for`/`while`/bare `loop`; labelled `next`/`exit`; assertion; concurrent procedure call. |
| `03_behavioral/dataflow.vhd` | Conditional (`when/else`) and selected (`with/select`) assignment; `transport`; concurrent assertion; `<=` as assignment and as relational operator in one file. |
| `04_fsm/fsm.vhd` | Two-process Moore and one-process Mealy. Enumeration type, attribute declaration + specification (`enum_encoding`), subtype of an enumeration, `'val`/`'pos`, record used as a register bundle, record aggregate, selected names on signals. |
| `05_names/ambiguity.vhd` | **Highest-value file.** The five identical `name(...)` forms and the four meanings of the tick. See below. |
| `06_aggregates/aggregates.vhd` | The three unrelated productions of `=>`; aggregate targets on the LHS; nested/record/multidimensional aggregates; choice lists and ranges inside aggregates. |
| `07_declarative/decls.vhd` | Physical types with secondary units, deferred constant, unconstrained array + constrained subtype, access + incomplete type, file type, subprogram and operator overloading, object and non-object aliases, alias with a signature, attribute specification, **two configuration declarations** incl. `for ... use entity`. |
| `08_vhdl2008/vhdl2008.vhd` | Context declaration, `process(all)`, `?=`/`?/=`, `??`, `case?`, `elsif`/`else generate`, sequential conditional/selected assignment, unconstrained record elements. Accepted under `--std=08`, **rejected** under `--std=93`. |

## The two ambiguities that matter

These cannot be resolved by the parser. Emit a uniform node and defer.

```vhdl
y <= v(3);                        -- indexed name
y <= v(3 downto 0);               -- slice name
y <= f(3);                        -- function call
y <= std_logic_vector(u);         -- type conversion
q := byte_t'(others => '0');      -- qualified expression
```

The tick is ambiguous at the *lexer* level and needs the preceding token:

```vhdl
c <= '0';                         -- character literal
n <= v'length;                    -- attribute name
q := byte_t'("10101010");         -- qualified expression
for i in v'range loop             -- attribute as a discrete range
y <= f(v'length) and '0';         -- tick after ')' is NOT an attribute
```

## Negative cases and the analysis/elaboration boundary

The negative set is deliberately split across three phases. If your Rust
tool reports all of these at the same stage, its phase separation is wrong.

| File | Phase that should reject it |
|---|---|
| `n01_missing_semicolon` | parse |
| `n02_label_mismatch` | parse |
| `n03_signal_in_process_decl` | parse (distinct declarative-part productions) |
| `n10_generate_label_missing` | parse |
| `n05_others_not_last` | parse or early semantic |
| `n04_wait_in_sensitised_process` | semantic |
| `n06_variable_as_signal` | semantic (syntax is well-formed — the parser MUST accept this file) |
| `n08_undeclared_identifier` | name resolution |
| `n11_type_mismatch` | type check |
| `n12_duplicate_declaration` | name resolution |
| `n09_port_mode_violation` | semantic, **revision-dependent** — reading an `out` port is an error under `--std=93` and legal under `--std=08` |
| `n07_unresolved_multiple_drivers` | **elaboration only.** `ghdl -a` accepts it; `ghdl -e` reports "too many drivers". This is the single best test of whether your elaborator is doing real work. |

## Notes and known quirks

- `n09` and `08_vhdl2008` are the two files that force a revision flag.
  Mirror GHDL's `--std=` rather than accepting the union of all revisions.
- Naming a physical unit `ff` produced a "no declaration for `ff` (due to
  conflicts)" homograph error in GHDL 4.1.0 when the unit was made visible
  through a `use` clause; the units here are spelled out instead. I did not
  chase down the second homograph, so treat this as an observation rather
  than a characterised rule.
- Case choices must be **locally** static: a generic is only globally
  static, so `when 4 to width-1` is illegal. `03_behavioral/alu.vhd` was
  written wrong the first time for exactly this reason.
- An architecture's closing label must match the *architecture* simple
  name, not the entity name. Same — got this wrong on the first pass.

## Suggested next additions

- A `for ... use entity` configuration bound to a component with a
  different port name set (association in the binding indication).
- PSL directives, if you care about GHDL compatibility beyond plain VHDL.
- Generic types and generic packages (2008), which change how the
  elaborator instantiates.
- Fuzzing: take the positive files and delete one token at a time; every
  mutant should be rejected, and none should crash the parser.
