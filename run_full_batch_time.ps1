# run_batch_metrics.ps1

# Mute compiler warnings during build
$env:RUSTFLAGS="-A warnings"

$Iterations = 1000
$RawOutputFile = "raw_benchmark_timings.csv"
$SummaryOutputFile = "summary_benchmark_timings.csv"

Write-Host "Building rghdl (Release mode)..." -ForegroundColor Yellow
cargo build --release -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Exiting." -ForegroundColor Red
    exit 1
}

$exePath = Resolve-Path ".\target\release\rghdl.exe"

$tests = @(
    @{ Files = @("01_nand2");                 Entity = "nand2" },
    @{ Files = @("02_primitives");              Entity = "inv" },
    @{ Files = @("02_primitives");              Entity = "and2" },
    @{ Files = @("02_primitives");              Entity = "or2" },
    @{ Files = @("02_primitives");              Entity = "xor2" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "full_adder" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "ripple_adder" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "ripple_adder_top" }
)

$summaryResults = @()
$rawResults = [System.Collections.Generic.List[PSCustomObject]]::new()

Write-Host "`nRunning benchmarks ($Iterations iterations per test)..." -ForegroundColor Cyan
Write-Host "==============================================================================================" -ForegroundColor Cyan
Write-Host ("{0,-20} | {1,-14} | {2,-14} | {3,-14} | {4,-14}" -f "Entity", "Avg Internal", "Min Internal", "Max Internal", "Avg Process") -ForegroundColor Cyan
Write-Host "==============================================================================================" -ForegroundColor Cyan

foreach ($test in $tests) {
    $argList = @()
    foreach ($f in $test.Files) { $argList += $f }
    $argList += "--top"
    $argList += $test.Entity
    $argumentsString = $argList -join " "

    $internalMicrosList = [System.Collections.Generic.List[double]]::new()
    $wallMsList = [System.Collections.Generic.List[double]]::new()

    # Pre-configure ProcessStartInfo to minimize runtime overhead
    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $exePath
    $psi.Arguments = $argumentsString
    $psi.UseShellExecute = $false
    $psi.RedirectStandardError = $true
    $psi.RedirectStandardOutput = $true
    $psi.CreateNoWindow = $true

    for ($i = 1; $i -le $Iterations; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $proc = [System.Diagnostics.Process]::Start($psi)
        
        # Read stderr to parse [RGH_TIMING] output
        $stderr = $proc.StandardError.ReadToEnd()
        $proc.WaitForExit()
        $sw.Stop()

        $wallMs = $sw.Elapsed.TotalMilliseconds
        $wallMsList.Add($wallMs)

        # Parse internal microsecond output: [RGH_TIMING] <entity>,<micros>
        $internalMicros = $null
        if ($stderr -match '\[RGH_TIMING\]\s*[^,]+,\s*(\d+)') {
            $internalMicros = [double]$Matches[1]
            $internalMicrosList.Add($internalMicros)
        }

        # Store individual run metric
        $rawResults.Add([PSCustomObject]@{
            Iteration      = $i
            Entity         = $test.Entity
            InternalMicros = $internalMicros
            ProcessWallMs  = [math]::Round($wallMs, 3)
        })
    }

    # Aggregated metrics for current test
    $avgWallMs = [math]::Round(($wallMsList | Measure-Object -Average).Average, 3)
    
    if ($internalMicrosList.Count -gt 0) {
        $stats = $internalMicrosList | Measure-Object -Average -Minimum -Maximum
        $avgInternalUs = [math]::Round($stats.Average, 2)
        $minInternalUs = $stats.Minimum
        $maxInternalUs = $stats.Maximum
    } else {
        $avgInternalUs = "N/A"
        $minInternalUs = "N/A"
        $maxInternalUs = "N/A"
    }

    Write-Host ("{0,-20} | {1,12} us | {2,12} us | {3,12} us | {4,11} ms" -f $test.Entity, $avgInternalUs, $minInternalUs, $maxInternalUs, $avgWallMs)

    $summaryResults += [PSCustomObject]@{
        Entity          = $test.Entity
        AvgInternalUs   = $avgInternalUs
        MinInternalUs   = $minInternalUs
        MaxInternalUs   = $maxInternalUs
        AvgProcessWallMs = $avgWallMs
    }
}

Write-Host "==============================================================================================" -ForegroundColor Cyan

# Export data
$rawResults | Export-Csv -Path $RawOutputFile -NoTypeInformation
$summaryResults | Export-Csv -Path $SummaryOutputFile -NoTypeInformation

Write-Host "`nBenchmark complete! Saved outputs to:" -ForegroundColor Green
Write-Host "  - $RawOutputFile (contains all 8,000 individual runs)"
Write-Host "  - $SummaryOutputFile (aggregated min/max/average statistics)"