# run_batch.ps1

$tests = @(
    @{ Files = @("01_nand2");                       Entity = "nand2" },
    @{ Files = @("02_primitives");                  Entity = "inv" },
    @{ Files = @("02_primitives");                  Entity = "and2" },
    @{ Files = @("02_primitives");                  Entity = "or2" },
    @{ Files = @("02_primitives");                  Entity = "xor2" },
    @{ Files = @("02_primitives", "03_adders");     Entity = "full_adder" },
    @{ Files = @("02_primitives", "03_adders");     Entity = "ripple_adder" },
    @{ Files = @("02_primitives", "03_adders");     Entity = "ripple_adder_top" }
)

$env:RUSTFLAGS="-A warnings"

foreach ($test in $tests) {
    Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    Write-Host "Running rghdl on Files: $($test.Files -join ' ') | Entity: $($test.Entity)" -ForegroundColor Cyan
    
    # @($test.Files) expands the array so PowerShell passes each element as a separate CLI argument
    cargo run -q --release -- @($test.Files) --top $test.Entity

    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAILED: $($test.Files -join ' ')" -ForegroundColor Red
    } else {
        Write-Host "PASSED: $($test.Files -join ' ')" -ForegroundColor Green
    }
}