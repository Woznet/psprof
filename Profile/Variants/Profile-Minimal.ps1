# Profile-Minimal.ps1
# A minimal version of the profile for testing

[CmdletBinding()]
param(
    [switch]$Measure
)

# Import utility functions
$loggingFunctionsPath = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "Profile/Functions/Private/Logging-Functions.ps1"
if (Test-Path -Path $loggingFunctionsPath) {
    . $loggingFunctionsPath
    Write-Verbose "Imported logging functions from $loggingFunctionsPath"
} else {
    Write-Warning "Logging functions file not found: $loggingFunctionsPath"
    # Define minimal logging function as fallback
    function Log-Debug { param([string]$Message) Write-Verbose $Message }
}

# Start timing if measurement is enabled
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}
}

# Basic environment detection
Measure-ProfileBlock -Name "Environment Detection" -Timings $timings -ScriptBlock {
    $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
    $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
    $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

    Write-Verbose "Environment detection: VSCode=$isVSCode, RegularPowerShell=$isRegularPowerShell, ISE=$isISE"
}

# Essential path setup
Measure-ProfileBlock -Name "Path Setup" -Timings $timings -ScriptBlock {
    $Global:ProfileRootPath = Split-Path -Parent $PSScriptRoot
    $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'
}

# Only load PSReadLine (essential)
Measure-ProfileBlock -Name "PSReadLine" -Timings $timings -ScriptBlock {
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Import-Module PSReadLine -ErrorAction SilentlyContinue

        # Basic PSReadLine configuration
        Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue
    }
}

# Only load Terminal-Icons (essential for directory listing)
Measure-ProfileBlock -Name "Terminal-Icons" -Timings $timings -ScriptBlock {
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }
}

# Load only essential aliases
Measure-ProfileBlock -Name "Aliases" -Timings $timings -ScriptBlock {
    $aliasesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Aliases.ps1"
    if (Test-Path -Path $aliasesPath) {
        . $aliasesPath
    }
}

# Display timing information if measurement is enabled
if ($Measure) {
    $mainStopwatch.Stop()

    Write-Host "`nProfile Component Load Times:" -ForegroundColor Cyan
    $timings.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value.TotalSeconds) seconds" -ForegroundColor White
    }

    Write-Host "`nMinimal profile load time: $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
}
