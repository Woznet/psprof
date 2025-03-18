# Profile-Minimal.ps1
# A minimal version of the profile for testing

[CmdletBinding()]
param(
    [switch]$Measure
)

# Start timing if measurement is enabled
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}
}

# Basic environment detection
$Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
$Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
$Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

Write-Verbose "Environment detection: VSCode=$isVSCode, RegularPowerShell=$isRegularPowerShell, ISE=$isISE"

# Essential path setup
$Global:ProfileRootPath = $PSScriptRoot
$Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

# Only load PSReadLine (essential)
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue

    # Basic PSReadLine configuration
    Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue
}

# Only load Terminal-Icons (essential for directory listing)
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
}

# Load only essential aliases
$aliasesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Aliases.ps1"
if (Test-Path -Path $aliasesPath) {
    . $aliasesPath
}

# Display timing information if measurement is enabled
if ($Measure) {
    $mainStopwatch.Stop()
    Write-Host "`nMinimal profile load time: $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
}
