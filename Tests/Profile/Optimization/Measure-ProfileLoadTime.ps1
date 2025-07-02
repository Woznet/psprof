# Measure-ProfileLoadTime.ps1
# Script to measure the execution time of each component of the PowerShell profile

[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$VerbosePreference = 'Continue'

# Store the original profile path
$ProfilePath = "C:\Users\jimmy\Documents\PowerShell\Profile.ps1"
$ProfileRootPath = Split-Path -Path $ProfilePath -Parent
$ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

# Define the profile components to test
$ProfileComponents = @(
    @{ Name = "PSReadLine"; Path = "$ProfileSourcePath/Profile.PSReadLine.ps1" }
    @{ Name = "Functions"; Path = "$ProfileSourcePath/Profile.Functions.ps1" }
    @{ Name = "Aliases"; Path = "$ProfileSourcePath/Profile.Aliases.ps1" }
    @{ Name = "Completions"; Path = "$ProfileSourcePath/Profile.Completions.ps1" }
    @{ Name = "Extras"; Path = "$ProfileSourcePath/Profile.Extras.ps1" }
    @{ Name = "Prompt"; Path = "$ProfileSourcePath/Profile.Prompt.ps1" }
    @{ Name = "Modules"; Path = "$ProfileSourcePath/Profile.Modules.ps1" }
    @{ Name = "DefaultParams"; Path = "$ProfileSourcePath/Profile.DefaultParams.ps1" }
    @{ Name = "Style"; Path = "$ProfileSourcePath/Profile.Style.ps1" }
)

# Create a results table
$Results = @()

# Test each component individually
Write-Host "Testing individual profile components..." -ForegroundColor Cyan
foreach ($component in $ProfileComponents) {
    Write-Host "Testing $($component.Name)..." -ForegroundColor Yellow

    try {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        . $component.Path -Verbose 4>&1 | Out-Null
        $sw.Stop()

        $Results += [PSCustomObject]@{
            Component = $component.Name
            Path = $component.Path
            ExecutionTime = $sw.Elapsed
            Status = "Success"
        }

        Write-Host "  Completed in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
    }
    catch {
        $Results += [PSCustomObject]@{
            Component = $component.Name
            Path = $component.Path
            ExecutionTime = $sw.Elapsed
            Status = "Error: $_"
        }

        Write-Host "  Error: $_" -ForegroundColor Red
    }
}

# Display results sorted by execution time
Write-Host "`nProfile Component Load Times (Sorted by Execution Time):" -ForegroundColor Cyan
$Results | Sort-Object -Property ExecutionTime -Descending | Format-Table -Property Component, ExecutionTime, Status -AutoSize

# Test the ModuleFast download specifically
Write-Host "`nTesting ModuleFast download..." -ForegroundColor Cyan
$sw = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $moduleFastContent = Invoke-WebRequest -Uri "bit.ly/modulefast" -UseBasicParsing
    $sw.Stop()
    Write-Host "  ModuleFast download completed in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
}
catch {
    $sw.Stop()
    Write-Host "  Error downloading ModuleFast: $_" -ForegroundColor Red
}

# Test zoxide initialization
Write-Host "`nTesting zoxide initialization..." -ForegroundColor Cyan
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        $zoxideInit = (zoxide init powershell | Out-String)
        $sw.Stop()
        Write-Host "  zoxide initialization completed in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
    }
    catch {
        $sw.Stop()
        Write-Host "  Error initializing zoxide: $_" -ForegroundColor Red
    }
}
else {
    Write-Host "  zoxide command not found" -ForegroundColor Yellow
}

# Recommendations
Write-Host "`nRecommendations:" -ForegroundColor Cyan
Write-Host "1. Consider caching the ModuleFast download instead of fetching it every time" -ForegroundColor White
Write-Host "2. Use Import-Module with the -ErrorAction SilentlyContinue parameter instead of try/catch blocks" -ForegroundColor White
Write-Host "3. Consider using a startup timer to identify slow-loading modules" -ForegroundColor White
Write-Host "4. Use conditional loading for heavy modules that aren't needed in every session" -ForegroundColor White
Write-Host "5. Consider using PowerShell's built-in module auto-loading instead of explicit imports" -ForegroundColor White
