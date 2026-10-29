import pandas as pd

# Load raw benchmark CSV
df = pd.read_csv("raw_benchmark_timings.csv")

# Force InternalMicros to numeric
df["InternalMicros"] = pd.to_numeric(df["InternalMicros"], errors="coerce")

# Filter out cold-start iterations (1-100)
filtered_df = df[df["Iteration"] > 100]

# Compute mean and standard deviation exclusively for InternalMicros
stats = filtered_df.groupby("Entity")["InternalMicros"].agg(["mean", "std"]).round(1)

# Rename columns
stats.columns = ["InternalMicros_Mean", "InternalMicros_StdDev"]

# Display and export
print(stats)
stats.to_csv("filtered_internal_micros_stats.csv")