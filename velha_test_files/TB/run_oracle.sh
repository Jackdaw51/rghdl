#!/usr/bin/env bash
# Runs GHDL over the corpus and writes an oracle file recording, for every
# test case, the expected exit status and the diagnostic GHDL produced.
#
# Use this two ways:
#   1. As an acceptance oracle for your Rust parser/elaborator: your tool
#      should agree with GHDL on accept/reject for every file.
#   2. As a regression baseline: commit oracle.txt and diff against it.
#
# Positive cases are analysed cumulatively into one library, because later
# files depend on earlier ones. Negative cases are analysed in isolation
# into a scratch library so that one failure does not poison the next.

set -u
cd "$(dirname "$0")"

STD="${STD:-93c}"
LIB=work_oracle
OUT=oracle_${STD}.txt

rm -rf "$LIB" && mkdir -p "$LIB"
: > "$OUT"

POSITIVE=(
    01_smoke/nand2.vhd
    01_smoke/primitives.vhd
    02_structural/adders.vhd
    03_behavioral/alu.vhd
    03_behavioral/dataflow.vhd
    04_fsm/fsm.vhd
    05_names/ambiguity.vhd
    06_aggregates/aggregates.vhd
    07_declarative/decls.vhd
)

echo "### positive cases (expect exit 0), --std=$STD" >> "$OUT"
for f in "${POSITIVE[@]}"; do
    msg=$(ghdl -a --workdir="$LIB" --std="$STD" "$f" 2>&1)
    rc=$?
    printf '%-40s expect=accept got=%s\n' "$f" \
        "$([ $rc -eq 0 ] && echo accept || echo reject)" >> "$OUT"
    [ -n "$msg" ] && printf '    %s\n' "$msg" >> "$OUT"
done

echo "" >> "$OUT"
echo "### negative cases (expect nonzero), --std=$STD" >> "$OUT"
for f in 09_negative/*.vhd; do
    scratch=$(mktemp -d)
    msg=$(ghdl -a --workdir="$scratch" --std="$STD" "$f" 2>&1)
    rc=$?
    printf '%-40s expect=reject got=%s\n' "$f" \
        "$([ $rc -eq 0 ] && echo ACCEPT-UNEXPECTED || echo reject)" >> "$OUT"
    [ -n "$msg" ] && printf '    %s\n' "$msg" | head -4 >> "$OUT"
    rm -rf "$scratch"
done

echo "" >> "$OUT"
echo "### VHDL-2008 case (expect accept under 08, reject under 93)" >> "$OUT"
for s in 93c 08; do
    scratch=$(mktemp -d)
    ghdl -a --workdir="$scratch" --std="$s" 08_vhdl2008/vhdl2008.vhd >/dev/null 2>&1
    printf '%-40s --std=%-4s got=%s\n' 08_vhdl2008/vhdl2008.vhd "$s" \
        "$([ $? -eq 0 ] && echo accept || echo reject)" >> "$OUT"
    rm -rf "$scratch"
done

cat "$OUT"
