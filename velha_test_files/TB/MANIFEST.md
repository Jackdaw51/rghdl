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
| `05_names/ambiguity.vhd` | **Highest-value file.** The five identical `name(...)` forms and the four meanings of the tick. Each form drives its own output port, one driver each — see the note below on why. |
| `06_aggregates/aggregates.vhd` | The three unrelated productions of `=>`; aggregate targets on the LHS; nested/record/multidimensional aggregates; choice lists and ranges inside aggregates. |
| `06_aggregates/agg_target_named.vhd` | **Analysis-only.** Named-choice aggregate target. Legal VHDL; GHDL 4.1.0 analyses it and then crashes in codegen. |
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

## GHDL bugs found while building this

A named-choice aggregate target crashes GHDL 4.1.0's mcode backend during
code generation. It analyses fine. Five-line reproducer:

```vhdl
library ieee; use ieee.std_logic_1164.all;
entity rep is end entity;
architecture a of rep is
  signal s : std_logic_vector(1 downto 0) := "10"; signal p, q : std_logic;
begin
  (0 => p, 1 => q) <= s;
end architecture;
```

```
$ ghdl -a rep.vhd && ghdl -r rep --stop-time=1ns
translate_signal_target_array_aggr: cannot handle IIR_KIND_CHOICE_BY_EXPRESSION
******************** GHDL Bug occurred ***************************
```

The positional form `(p, q) <= s;` works. Worth reporting upstream. It is
also a useful corpus entry precisely because the reference implementation
gets it wrong — it checks that you are not merely cloning GHDL.

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

## The differential bench

`./bench.sh <regenerated-dir>` compares GHDL's behaviour on this corpus
against GHDL's behaviour on whatever your parser emitted, at three levels:

| Level | What it compares | Reacts to reformatting? |
|---|---|---|
| **L1 analysis** | per-file accept/reject verdict from `ghdl -a` | no |
| **L2 structure** | GHDL's own AST via `--file-to-xml`, with node ids, source coordinates, timestamps, checksums and `subprogram_hash` stripped, and attribute line-wrapping normalised | no |
| **L3 behaviour** | simulation trace per testbench | no |

L3 is the real oracle. L2 localises a difference to a construct. L1 catches
gross breakage. A correct pretty-printer passes all three; a *semantically*
correct but structurally different emitter may differ at L2 and still pass
L3, which is fine.

The bench was validated in both directions before shipping:

- against a copy with every comment stripped and all indentation removed —
  **passes all three levels**, so it does not react to formatting;
- against copies carrying five injected mutations (slice direction flipped
  `downto`→`to`, named association silently made positional, a wrong operand
  in `xor2(gate_level)`, a case choice list split, an aggregate `others`
  value changed) — **every one is caught**.

Two things learned from that validation and now baked into the design:

- **`ghdl -e` is a no-op with the mcode backend.** Code generation happens
  at `ghdl -r`. Elaboration-time errors and codegen crashes only surface
  when you actually run. Do not treat a clean `-e` as an elaboration pass.
- **Default binding picks the last architecture.** Corrupting
  `xor2(gate_level)` broke `tb_adders`, because `full_adder`'s component
  instance `u_x1` binds by default rule and lands on `gate_level`, not
  `rtl`. If your elaborator implements default binding as "first
  architecture" this test catches it.

### Testbench design rules

The testbenches (`bench/`) are a fixed probe: they are taken from the
reference tree in both runs, so only the design under test varies.

- Everything is written to **stdout via `std.textio`, never via `report`**.
  GHDL prefixes assertion output with `file:line:col:`, and those line
  numbers change whenever your emitter reformats. The bench captures stdout
  and discards stderr for exactly this reason.
- Stimulus is applied at fixed absolute times; outputs are sampled at an
  offset well past all delta cycles and `after` delays. This makes the
  trace insensitive to concurrent-statement ordering while still catching
  real semantic differences.
- Clocked benches gate the clock on a `run` boolean so the simulation
  terminates without `--stop-time`.
- Time is printed as `now / 1 ns` rather than `time'image`, whose unit
  spelling is implementation-flavoured.
- **Analysis order is significant.** `bench/tb_*.vhd` sorts alphabetically
  *before* `bench/trace_pkg.vhd`, so a naive glob fails. The bench uses an
  explicit ordered file list.

### Why rung 5 has one output port per construct

An earlier draft of `ambiguity.vhd` drove several constructs onto shared
outputs. Because `std_logic` resolution collapses disagreeing drivers to
`'X'` and undriven signals to `'U'`, the trace read `U` regardless of what
the design did — it would have passed even if the elaborator resolved every
name wrongly. The file now gives each name form its own single-driver
output. The same draft also put four drivers on `n`, an *unresolved*
`integer`, which analysed cleanly and then failed elaboration with "too
many drivers"; that case now lives in `09_negative/n07` where it belongs.

## Suggested next additions

- A `for ... use entity` configuration bound to a component with a
  different port name set (association in the binding indication).
- PSL directives, if you care about GHDL compatibility beyond plain VHDL.
- Generic types and generic packages (2008), which change how the
  elaborator instantiates.
- Fuzzing: take the positive files and delete one token at a time; every
  mutant should be rejected, and none should crash the parser.
- Mutation scoring for the bench itself: inject N semantic mutations and
  measure what fraction L3 catches. The five used for validation are a
  starting set, not a complete one.
