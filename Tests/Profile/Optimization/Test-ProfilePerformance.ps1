# Test-ProfilePerformance.ps1
# Script to compare the performance of the original and optimized PowerShell profiles

[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$VerbosePreference = 'Continue'

# Define the profile paths
$OriginalProfile = Join-Path -Path $PSScriptRoot -ChildPath "Profile.ps1"
$OptimizedProfile = Join-Path -Path $PSScriptRoot -ChildPath "Profile-Optimized.ps1"

# Function to test profile load time
function Test-ProfileLoadTime {
    param(
        [string]$ProfilePath,
        [string]$Name,
        [int]$Iterations = 3
    )

    Write-Host "Testing $Name profile load time ($Iterations iterations)..." -ForegroundColor Cyan

    $times = @()

    for ($i = 1; $i -le $Iterations; $i++) {
        Write-Host "  Iteration $i of $Iterations..." -ForegroundColor Yellow

        # Start a new PowerShell process and measure the time it takes to load the profile
        $startTime = Get-Date

        # Use Start-Process to run PowerShell with the specified profile
        $process = Start-Process -FilePath "pwsh" -ArgumentList "-NoLogo", "-NoExit", "-Command", "& { Write-Host 'Profile loaded'; exit }" -PassThru

        # Wait for the process to exit
        $process.WaitForExit()

        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        $times += $duration

        Write-Host "    Completed in $duration seconds" -ForegroundColor Green
    }

    # Calculate average time
    $averageTime = ($times | Measure-Object -Average).Average

    Write-Host "  Average load time: $averageTime seconds" -ForegroundColor Cyan

    return $averageTime
}

# Test the original profile
$originalTime = Test-ProfileLoadTime -ProfilePath $OriginalProfile -Name "Original"

# Test the optimized profile
$optimizedTime = Test-ProfileLoadTime -ProfilePath $OptimizedProfile -Name "Optimized" -Iterations 3

# Compare results
$improvement = (($originalTime - $optimizedTime) / $originalTime) * 100

Write-Host "`nPerformance Comparison:" -ForegroundColor Cyan
Write-Host "  Original Profile: $originalTime seconds" -ForegroundColor White
Write-Host "  Optimized Profile: $optimizedTime seconds" -ForegroundColor White
Write-Host "  Improvement: $([math]::Round($improvement, 2))%" -ForegroundColor Green

# Recommendations
Write-Host "`nRecommendations:" -ForegroundColor Cyan
Write-Host "1. Replace your current Profile.ps1 with the optimized version:" -ForegroundColor White
Write-Host "   Copy-Item -Path '$OptimizedProfile' -Destination '$OriginalProfile' -Backup" -ForegroundColor Gray
Write-Host "2. Test the optimized profile with the -Measure parameter to see detailed timing information:" -ForegroundColor White
Write-Host "   pwsh -NoLogo -NoExit -Command '. $OptimizedProfile -Measure'" -ForegroundColor Gray
Write-Host "3. If you encounter any issues, you can restore the original profile from the backup." -ForegroundColor White
