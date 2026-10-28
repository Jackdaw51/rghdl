#!/usr/bin/env bash

set -e
export RUSTFLAGS="-A warnings"

echo "Building rghdl (Release mode)..."
cargo build --release -q

EXE_PATH="./target/release/rghdl"

if [ ! -f "$EXE_PATH" ]; then
    echo "Error: Binary not found at $EXE_PATH"
    exit 1
fi

TESTS=(
    "01_nand2|nand2"
    "02_primitives|inv"
    "02_primitives|and2"
    "02_primitives|or2"
    "02_primitives|xor2"
    "02_primitives 03_adders|full_adder"
    "02_primitives 03_adders|ripple_adder"
    "02_primitives 03_adders|ripple_adder_top"
)

printf "\n%-20s | %-8s | %-15s | %-18s\n" "Entity" "Status" "Wall Time" "Tree Peak RAM"
printf "==========================================================================================\n"

PASSED_COUNT=0
TOTAL_COUNT=${#TESTS[@]}
TOTAL_TIME_MS=0
MAX_PEAK_KB=0
SUM_PEAK_KB=0

for ENTRY in "${TESTS[@]}"; do
    IFS="|" read -r FILES TOP_ENTITY <<< "$ENTRY"

    # Python runner launches target in a new PGID and polls total tree RSS from /proc
    RESULT=$(python3 -c '
import sys, os, time, subprocess

cmd = [sys.argv[1]] + sys.argv[2].split() + ["--top", sys.argv[3]]
page_size_kb = os.sysconf("SC_PAGE_SIZE") // 1024

def sample_pgid_rss(target_pgid):
    total = 0
    try:
        for p in os.listdir("/proc"):
            if not p.isdigit(): continue
            try:
                with open(f"/proc/{p}/stat", "r") as f:
                    content = f.read()
                after_comm = content.rpartition(")")[2].split()
                if int(after_comm[2]) == target_pgid:
                    total += int(after_comm[21]) * page_size_kb
            except Exception:
                continue
    except Exception:
        pass
    return total

start_time = time.perf_counter()
proc = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
target_pgid = proc.pid
max_rss_kb = 0

while True:
    current_rss = sample_pgid_rss(target_pgid)
    if current_rss > max_rss_kb:
        max_rss_kb = current_rss
    if proc.poll() is not None:
        break
    time.sleep(0.001)

elapsed_ms = int((time.perf_counter() - start_time) * 1000)
print(f"{proc.returncode} {elapsed_ms} {max_rss_kb}")
' "$EXE_PATH" "$FILES" "$TOP_ENTITY")

    read -r EXIT_CODE ELAPSED_MS PEAK_KB <<< "$RESULT"

    PEAK_MB=$(awk "BEGIN {printf \"%.2f\", $PEAK_KB / 1024}")
    TOTAL_TIME_MS=$(( TOTAL_TIME_MS + ELAPSED_MS ))

    if [ "$PEAK_KB" -gt "$MAX_PEAK_KB" ]; then
        MAX_PEAK_KB=$PEAK_KB
    fi
    SUM_PEAK_KB=$(( SUM_PEAK_KB + PEAK_KB ))

    if [ "$EXIT_CODE" -eq 0 ]; then
        STATUS="PASS"
        STATUS_COLOR="\033[32m"
        PASSED_COUNT=$(( PASSED_COUNT + 1 ))
    else
        STATUS="FAIL"
        STATUS_COLOR="\033[31m"
    fi
    RESET_COLOR="\033[0m"

    printf "%-20s | ${STATUS_COLOR}%-8s${RESET_COLOR} | %12d ms | %10d KB (%s MB)\n" \
        "$TOP_ENTITY" "$STATUS" "$ELAPSED_MS" "$PEAK_KB" "$PEAK_MB"
done

printf "==========================================================================================\n"

AVG_PEAK_KB=$(( SUM_PEAK_KB / TOTAL_COUNT ))

echo -e "\n--- BENCHMARK SUMMARY ---"
echo "Passed:             $PASSED_COUNT / $TOTAL_COUNT"
echo "Total Suite Time:    ${TOTAL_TIME_MS} ms"
echo "Max Single Peak RAM: ${MAX_PEAK_KB} KB"
echo "Average Peak RAM:    ${AVG_PEAK_KB} KB"