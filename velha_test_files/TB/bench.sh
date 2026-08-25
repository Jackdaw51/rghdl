#!/usr/bin/env bash
#
# Differential round-trip bench.
#
#   ./bench.sh <regenerated-dir>
#
# Compares GHDL's behaviour on the reference corpus against GHDL's behaviour
# on whatever your parser emitted, at three independent levels:
#
#   L1  ANALYSIS     does GHDL accept the regenerated file at all, and does
#                    it produce the same accept/reject verdict per file
#   L2  STRUCTURE    AST diff, via GHDL's own --file-to-xml dump, after
#                    stripping node ids and source coordinates
#   L3  BEHAVIOUR    simulation trace diff, per testbench
#
# L3 is the real oracle. L1 catches gross breakage, L2 localises a
# difference to a construct, L3 tells you whether the difference MATTERS.
# A pretty-printer will routinely change L2 without changing L3; that is
# fine and expected. L3 differing is always a bug.
#
# <regenerated-dir> must mirror the reference layout, i.e. contain
#   01_smoke/nand2.vhd, 01_smoke/primitives.vhd, 02_structural/adders.vhd, ...
# with the same entity, architecture and port names. The testbenches are
# taken from the reference tree in BOTH runs, so they are a fixed probe.

set -u

REF_DIR="$(cd "$(dirname "$0")" && pwd)"
DUT_DIR="${1:-}"
STD="${STD:-93c}"

if [ -z "$DUT_DIR" ]; then
    echo "usage: $0 <regenerated-dir>   (env: STD=93c|08)" >&2
    exit 2
fi
DUT_DIR="$(cd "$DUT_DIR" && pwd)"

# Analysis order is significant: packages before the units that use them,
# and trace_pkg before the testbenches. Do NOT replace this with a glob --
# bench/tb_*.vhd sorts before bench/trace_pkg.vhd and the analysis fails.
DESIGN_FILES="
01_smoke/nand2.vhd
01_smoke/primitives.vhd
02_structural/adders.vhd
03_behavioral/alu.vhd
03_behavioral/dataflow.vhd
04_fsm/fsm.vhd
05_names/ambiguity.vhd
06_aggregates/aggregates.vhd
06_aggregates/agg_target_named.vhd
07_declarative/decls.vhd
"

# agg_target_named.vhd analyses but cannot be simulated: GHDL 4.1.0's mcode
# backend aborts on a named-choice aggregate target. It is checked at L1/L2
# only. See MANIFEST.md.
NO_SIM="06_aggregates/agg_target_named.vhd"

TESTBENCHES="
tb_nand2
tb_primitives
tb_adders
tb_alu
tb_dataflow
tb_fsm
tb_ambiguity
tb_aggregates
tb_decls
"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/ref" "$WORK/dut" "$WORK/out"

fail=0
l1_failed=0
note() { printf '%s\n' "$*"; }

# ---------------------------------------------------------------- L1 -----
note "== L1  analysis =="

analyse_tree() {   # $1=srcdir  $2=libdir  $3=tag
    local src="$1" lib="$2" tag="$3" f rc
    for f in $DESIGN_FILES; do
        if [ ! -f "$src/$f" ]; then
            note "  $tag  $f  MISSING"
            fail=1
            continue
        fi
        ghdl -a --workdir="$lib" --std="$STD" "$src/$f" \
            > "$WORK/out/${tag}_$(echo "$f" | tr / _).log" 2>&1
        rc=$?
        echo "$rc" > "$WORK/out/${tag}_$(echo "$f" | tr / _).rc"
        [ $rc -ne 0 ] && note "  $tag  $f  REJECTED by ghdl -a"
    done
    # Testbenches always come from the reference tree.
    ghdl -a --workdir="$lib" --std="$STD" \
        "$REF_DIR/bench/trace_pkg.vhd" \
        "$REF_DIR/bench/tb_rungs_1_2.vhd" \
        "$REF_DIR/bench/tb_rungs_3_7.vhd" >/dev/null 2>&1 \
        || { note "  $tag  testbench analysis FAILED"; fail=1; }
}

analyse_tree "$REF_DIR" "$WORK/ref" ref
analyse_tree "$DUT_DIR" "$WORK/dut" dut

for f in $DESIGN_FILES; do
    k=$(echo "$f" | tr / _)
    r=$(cat "$WORK/out/ref_$k.rc" 2>/dev/null || echo 99)
    d=$(cat "$WORK/out/dut_$k.rc" 2>/dev/null || echo 99)
    if [ "$r" = "$d" ]; then
        note "  ok      $f  (both $( [ "$r" = 0 ] && echo accept || echo reject ))"
    else
        note "  DIFFER  $f  ref=$r dut=$d"
        sed 's/^/            /' "$WORK/out/dut_$k.log" | head -5
        fail=1
        l1_failed=1
    fi
done

# ---------------------------------------------------------------- L2 -----
note ""
note "== L2  structure (GHDL AST, ids and source coordinates stripped) =="

# --file-to-xml embeds node ids, file names, line and column numbers, all of
# which change under reformatting. Strip them so what remains is the shape
# of the tree and the identifiers in it.
canon_ast() {   # $1=file  -> stdout
    ghdl --file-to-xml --std="$STD" "$1" 2>/dev/null \
      | tr '\n' ' ' \
      | sed -e 's/> */>\n/g' \
      | sed -e 's/ id="[0-9]*"//g' \
            -e 's/ ref="[0-9]*"//g' \
            -e 's/ file="[^"]*"//g' \
            -e 's/ line="[0-9]*"//g' \
            -e 's/ col="[0-9]*"//g' \
            -e 's/ design_unit_source_line="[0-9]*"//g' \
            -e 's/ design_unit_source_col="[0-9]*"//g' \
            -e 's/ analysis_time_stamp="[^"]*"//g' \
            -e 's/ file_checksum="[^"]*"//g' \
            -e 's/ design_file_directory="[^"]*"//g' \
            -e 's/ design_file_filename="[^"]*"//g' \
            -e 's/ library_directory="[^"]*"//g' \
            -e 's/ subprogram_hash="[0-9]*"//g' \
            -e 's/[[:space:]][[:space:]]*/ /g' \
            -e 's/^ //' -e 's/ $//' \
      | grep -v '^$'
}

for f in $DESIGN_FILES; do
    [ -f "$DUT_DIR/$f" ] || continue
    canon_ast "$REF_DIR/$f" > "$WORK/out/ast_ref.txt"
    canon_ast "$DUT_DIR/$f" > "$WORK/out/ast_dut.txt"
    if diff -q "$WORK/out/ast_ref.txt" "$WORK/out/ast_dut.txt" >/dev/null; then
        note "  identical  $f"
    else
        n=$(diff "$WORK/out/ast_ref.txt" "$WORK/out/ast_dut.txt" | grep -c '^[<>]')
        note "  differs    $f  ($n node lines) -- not necessarily a bug, see L3"
        diff "$WORK/out/ast_ref.txt" "$WORK/out/ast_dut.txt" \
            | grep '^[<>]' | head -6 | sed 's/^/            /'
    fi
done

# ---------------------------------------------------------------- L3 -----
note ""
note "== L3  behaviour (simulation traces) =="

for tb in $TESTBENCHES; do
    ok_ref=1; ok_dut=1
    timeout 60 ghdl -r --workdir="$WORK/ref" --std="$STD" "$tb" \
        > "$WORK/out/${tb}_ref.trace" 2>/dev/null || ok_ref=0
    timeout 60 ghdl -r --workdir="$WORK/dut" --std="$STD" "$tb" \
        > "$WORK/out/${tb}_dut.trace" 2>/dev/null || ok_dut=0

    if [ ! -s "$WORK/out/${tb}_ref.trace" ]; then
        note "  SKIP   $tb  (reference produced no trace)"
        fail=1
        continue
    fi
    if [ ! -s "$WORK/out/${tb}_dut.trace" ]; then
        if [ $l1_failed -ne 0 ]; then
            note "  n/a    $tb  (cascade from an L1 rejection -- fix L1 first)"
        else
            note "  FAIL   $tb  (regenerated design produced no trace)"
        fi
        fail=1
        continue
    fi
    if diff -q "$WORK/out/${tb}_ref.trace" "$WORK/out/${tb}_dut.trace" >/dev/null; then
        lines=$(wc -l < "$WORK/out/${tb}_ref.trace")
        note "  MATCH  $tb  ($lines trace lines)"
    else
        note "  FAIL   $tb  -- trace mismatch"
        diff "$WORK/out/${tb}_ref.trace" "$WORK/out/${tb}_dut.trace" \
            | head -10 | sed 's/^/            /'
        fail=1
    fi
done

note ""
if [ $fail -eq 0 ]; then
    note "RESULT: pass"
else
    note "RESULT: FAIL"
fi
exit $fail
