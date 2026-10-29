import glob
import pandas as pd
import numpy as np

# Gather all CSV results
file_list = glob.glob("results/res_*.csv")
data = []

for file in file_list:
    try:
        df_row = pd.read_csv(file, header=None, names=["Entity", "Iteration", "TimeUs", "ExitCode"])
        data.append(df_row)
    except Exception:
        pass

df = pd.concat(data, ignore_index=True)

# Filter for successful executions
df_passed = df[df["ExitCode"] == 0].copy()

# Convert microseconds to milliseconds
df_passed["TimeMs"] = df_passed["TimeUs"] / 1000.0

# Compute statistical metrics per target entity
stats = df_passed.groupby("Entity").agg(
    Runs=("Iteration", "count"),
    Mean_Ms=("TimeMs", "mean"),
    StdDev_Ms=("TimeMs", "std"),
    Median_Ms=("TimeMs", "median"),
    P95_Ms=("TimeMs", lambda x: np.percentile(x, 95)),
    Min_Ms=("TimeMs", "min"),
    Max_Ms=("TimeMs", "max")
).reset_index()

stats = stats.round(3)

print("\n=== RGHDL FRONTEND PERFORMANCE (1,000 RUNS PER TARGET) ===")
print(stats.to_string(index=False))

# Generate LaTeX Table
latex_table = stats.to_latex(
    index=False,
    columns=["Entity", "Runs", "Mean_Ms", "StdDev_Ms", "Median_Ms", "P95_Ms"],
    header=["Entity Target", "$N$", "Mean (ms)", "Std Dev (ms)", "Median (ms)", "$p_{95}$ (ms)"],
    caption="Compilation and elaboration latency of the \\texttt{rghdl} Rust frontend across 1,000 independent runs per benchmark target.",
    label="tab:rghdl_frontend_benchmarks"
)

with open("rghdl_benchmark_results.tex", "w") as f:
    f.write(latex_table)

print("\nSaved LaTeX table to 'rghdl_benchmark_results.tex'")