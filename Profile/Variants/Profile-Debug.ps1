# Profile-Debug.ps1
# A debugging version of the profile with detailed timing

[CmdletBinding()]
param()

# Start main timer
$mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$debugLog = @()

function Log-Debug {
    param(
        [string]$Message,
        [string]$Component = "General"
    )

    $timestamp = Get-Date -Format "HH:mm:ss.fff"
    $elapsed = $mainStopwatch.Elapsed.TotalSeconds
    $entry = "$timestamp [$Component] ($elapsed s): $Message"

    $debugLog += $entry
    Write-Verbose $entry

    # Also write to a file in case the process hangs
    $entry | Out-File -FilePath "$PSScriptRoot\profile-debug.log" -Append
}

# Clear previous log
"" | Out-File -FilePath "$PSScriptRoot\profile-debug.log" -Force

# Log system info
Log-Debug "Starting profile debugging" "System"
Log-Debug "PowerShell Version: $($PSVersionTable.PSVersion)" "System"
Log-Debug "OS: $([System.Environment]::OSVersion.VersionString)" "System"
Log-Debug "Host: $($Host.Name)" "System"

# Test each component individually
try {
    Log-Debug "Testing environment detection" "Environment"
    $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
    $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
    $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'
    Log-Debug "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE" "Environment"

    Log-Debug "Testing path setup" "Paths"
    $Global:ProfileRootPath = Split-Path -Parent $PSScriptRoot
    $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'
    Log-Debug "ProfileRootPath: $ProfileRootPath" "Paths"
    Log-Debug "ProfileSourcePath: $ProfileSourcePath" "Paths"

    Log-Debug "Testing PSReadLine" "Modules"
    if (Get-Module -ListAvailable -Name PSReadLine) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Import-Module PSReadLine -ErrorAction SilentlyContinue
        $sw.Stop()
        Log-Debug "PSReadLine import took $($sw.Elapsed.TotalSeconds) seconds" "Modules"
    }

    Log-Debug "Testing Terminal-Icons" "Modules"
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
        $sw.Stop()
        Log-Debug "Terminal-Icons import took $($sw.Elapsed.TotalSeconds) seconds" "Modules"
    }

    Log-Debug "Testing Functions" "Functions"
    $functionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Functions.ps1"
    if (Test-Path -Path $functionsPath) {
        Log-Debug "Testing functions file: $functionsPath" "Functions"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        # Don't actually load it, just check if it exists
        $sw.Stop()
        Log-Debug "Functions check took $($sw.Elapsed.TotalSeconds) seconds" "Functions"
    }

    Log-Debug "Testing Completions" "Completions"
    $completionPath = Join-Path -Path $ProfileSourcePath -ChildPath "Completions"
    if (Test-Path -Path $completionPath) {
        $completionFiles = Get-ChildItem -Path $completionPath -Filter "*.ps1" -ErrorAction SilentlyContinue
        Log-Debug "Found $($completionFiles.Count) completion files" "Completions"

        # Test loading a single completion file to see if it hangs
        if ($completionFiles.Count -gt 0) {
            $testFile = $completionFiles[0]
            Log-Debug "Testing completion file: $($testFile.Name)" "Completions"
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            # . $testFile.FullName  # Commented out to avoid actually loading it
            $sw.Stop()
            Log-Debug "Loading $($testFile.Name) took $($sw.Elapsed.TotalSeconds) seconds" "Completions"
        }
    }

    Log-Debug "Testing oh-my-posh" "Prompt"
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        Log-Debug "oh-my-posh is available" "Prompt"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $promptPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Prompt.ps1'
        if (Test-Path -Path $promptPath) {
            Log-Debug "Testing prompt file: $promptPath" "Prompt"
            # Don't actually load it, just check if it exists
        }
        $sw.Stop()
        Log-Debug "Prompt check took $($sw.Elapsed.TotalSeconds) seconds" "Prompt"
    }

    Log-Debug "Testing zoxide" "Zoxide"
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Log-Debug "zoxide is available" "Zoxide"
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        # Just check if it's available, don't initialize
        $sw.Stop()
        Log-Debug "zoxide check took $($sw.Elapsed.TotalSeconds) seconds" "Zoxide"
    }

    # Now test loading each component one by one
    Log-Debug "Testing Profile.Aliases.ps1" "Components"
    $aliasesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Aliases.ps1"
    if (Test-Path -Path $aliasesPath) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        . $aliasesPath
        $sw.Stop()
        Log-Debug "Loading Profile.Aliases.ps1 took $($sw.Elapsed.TotalSeconds) seconds" "Components"
    }

    Log-Debug "Testing Profile.DefaultParams.ps1" "Components"
    $defaultParamsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.DefaultParams.ps1"
    if (Test-Path -Path $defaultParamsPath) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        . $defaultParamsPath
        $sw.Stop()
        Log-Debug "Loading Profile.DefaultParams.ps1 took $($sw.Elapsed.TotalSeconds) seconds" "Components"
    }

    Log-Debug "Testing Profile.Extras.ps1" "Components"
    $extrasPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Extras.ps1"
    if (Test-Path -Path $extrasPath) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        . $extrasPath
        $sw.Stop()
        Log-Debug "Loading Profile.Extras.ps1 took $($sw.Elapsed.TotalSeconds) seconds" "Components"
    }

    # Test loading completions
    Log-Debug "Testing Profile.Completions.ps1" "Components"
    $completionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Completions.ps1"
    if (Test-Path -Path $completionsPath) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        . $completionsPath
        $sw.Stop()
        Log-Debug "Loading Profile.Completions.ps1 took $($sw.Elapsed.TotalSeconds) seconds" "Components"
    }

    # Test loading modules
    Log-Debug "Testing Profile.Modules.ps1" "Components"
    $modulesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Modules.ps1"
    if (Test-Path -Path $modulesPath) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        # . $modulesPath  # Commented out to avoid actually loading it
        $sw.Stop()
        Log-Debug "Loading Profile.Modules.ps1 took $($sw.Elapsed.TotalSeconds) seconds" "Components"
    }
} catch {
    Log-Debug "Error: $_" "Error"
    Log-Debug "Stack Trace: $($_.ScriptStackTrace)" "Error"
}

# Finish timing
$mainStopwatch.Stop()
Log-Debug "Debug profile completed in $($mainStopwatch.Elapsed.TotalSeconds) seconds" "System"

# Display results
Write-Host "Debug profile completed in $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
Write-Host "Debug log has been written to $PSScriptRoot\profile-debug.log" -ForegroundColor Cyan
