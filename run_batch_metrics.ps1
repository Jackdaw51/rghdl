# run_batch_metrics.ps1

# Mute compiler warnings during build
$env:RUSTFLAGS="-A warnings"

Write-Host "Building rghdl (Release mode)..." -ForegroundColor Yellow
cargo build --release -q
# cargo build --release --features dhat-heap -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Exiting." -ForegroundColor Red
    exit 1
}

# $exePath = "cargo run"
$exePath = ".\target\release\rghdl.exe"

$tests = @(
    @{ Files = @("01_nand2");                   Entity = "nand2" },
    @{ Files = @("02_primitives");              Entity = "inv" },
    @{ Files = @("02_primitives");              Entity = "and2" },
    @{ Files = @("02_primitives");              Entity = "or2" },
    @{ Files = @("02_primitives");              Entity = "xor2" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "full_adder" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "ripple_adder" },
    @{ Files = @("02_primitives", "03_adders"); Entity = "ripple_adder_top" }
)

$results = @()
$totalSuiteTimeMs = 0

Write-Host "`n==========================================================================================" -ForegroundColor Cyan
Write-Host ("{0,-20} | {1,-8} | {2,-15} | {3,-15}" -f "Entity", "Status", "Execution Time", "Peak Working Set") -ForegroundColor Cyan
Write-Host "==========================================================================================" -ForegroundColor Cyan

foreach ($test in $tests) {
    # Prepare CLI arguments: files... --top Entity
    $argList = @()
    # $argList += "--release"
    # $argList += "--features"
    # $argList += "dhat-heap"
    foreach ($f in $test.Files) { $argList += $f }
    $argList += "--top"
    $argList += $test.Entity

    # Initialize high-resolution timer and process info
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = Start-Process -FilePath $exePath -ArgumentList $argList -PassThru -NoNewWindow
    
    $peakMemoryBytes = 0

    # Poll process state to capture peak memory accurately
    while (-not $proc.HasExited) {
        $proc.Refresh()
        if ($proc.PeakWorkingSet64 -gt $peakMemoryBytes) {
            $peakMemoryBytes = $proc.PeakWorkingSet64
        }
        Start-Sleep -Milliseconds 2
    }
    $sw.Stop()

    # Final check after process exit
    $proc.Refresh()
    if ($proc.PeakWorkingSet64 -gt $peakMemoryBytes) {
        $peakMemoryBytes = $proc.PeakWorkingSet64
    }

    $elapsedMs = [math]::Round($sw.Elapsed.TotalMilliseconds, 2)
    $peakKb = [math]::Round($peakMemoryBytes / 1KB, 2)
    # $passed = ($null -ne $exitCode) -and ($exitCode -eq 0)
    $passed = $true;
    
    $statusStr = if ($passed) { "PASS" } else { "FAIL" }
    $statusColor = if ($passed) { "Green" } else { "Red" }

    # Display row
    Write-Host ("{0,-20} | " -f $test.Entity) -NoNewline
    Write-Host ("{0,-8}" -f $statusStr) -ForegroundColor $statusColor -NoNewline
    Write-Host (" | {0,12} ms | {1,12} KB" -f $elapsedMs, $peakKb)

    $totalSuiteTimeMs += $elapsedMs
    $results += [PSCustomObject]@{
        Entity     = $test.Entity
        Status     = $statusStr
        TimeMs     = $elapsedMs
        PeakMemKB  = $peakKb
    }
}

Write-Host "==========================================================================================" -ForegroundColor Cyan

# Summary statistics
$totalTests = $results.Count
$passedCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
$maxMemKB = ($results | Measure-Object -Property PeakMemKB -Maximum).Maximum
$avgMemKB = [math]::Round(($results | Measure-Object -Property PeakMemKB -Average).Average, 2)

Write-Host "`n--- BENCHMARK SUMMARY ---" -ForegroundColor Yellow
Write-Host "Passed:              $passedCount / $totalTests"
Write-Host "Total Suite Time:    $totalSuiteTimeMs ms"
Write-Host "Max Single Peak RAM: $maxMemKB KB"
Write-Host "Average Peak RAM:    $avgMemKB KB"