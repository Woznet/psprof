# Profile-Debug.ps1
# A debugging version of the profile with detailed timing

[CmdletBinding()]
param()

# Import utility functions
$loggingFunctionsPath = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "Profile/Functions/Private/Logging-Functions.ps1"
if (Test-Path -Path $loggingFunctionsPath) {
    . $loggingFunctionsPath
    Write-Verbose "Imported logging functions from $loggingFunctionsPath"
} else {
    Write-Warning "Logging functions file not found: $loggingFunctionsPath"
    # Define minimal logging function as fallback
    function Log-Debug {
        param(
            [string]$Message,
            [string]$Component = "General"
        )
        Write-Verbose "[$Component] $Message"
    }
}

# Initialize debug log
$debugLogPath = "$PSScriptRoot\profile-debug.log"
Initialize-DebugLog -LogPath $debugLogPath

# Log system info
Log-Debug -Message "Starting profile debugging" -Component "System" -LogPath $debugLogPath
Log-Debug -Message "PowerShell Version: $($PSVersionTable.PSVersion)" -Component "System" -LogPath $debugLogPath
Log-Debug -Message "OS: $([System.Environment]::OSVersion.VersionString)" -Component "System" -LogPath $debugLogPath
Log-Debug -Message "Host: $($Host.Name)" -Component "System" -LogPath $debugLogPath

# Create a timings hashtable to store component timings
$timings = @{}

# Test each component individually
try {
    # Environment detection
    Measure-ProfileBlock -Name "Environment Detection" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing environment detection" -Component "Environment" -LogPath $debugLogPath
        $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
        $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
        $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'
        Log-Debug -Message "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE" -Component "Environment" -LogPath $debugLogPath
    }

    # Path setup
    Measure-ProfileBlock -Name "Path Setup" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing path setup" -Component "Paths" -LogPath $debugLogPath
        $Global:ProfileRootPath = Split-Path -Parent $PSScriptRoot
        $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'
        Log-Debug -Message "ProfileRootPath: $ProfileRootPath" -Component "Paths" -LogPath $debugLogPath
        Log-Debug -Message "ProfileSourcePath: $ProfileSourcePath" -Component "Paths" -LogPath $debugLogPath
    }

    # PSReadLine
    Measure-ProfileBlock -Name "PSReadLine" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing PSReadLine" -Component "Modules" -LogPath $debugLogPath
        if (Get-Module -ListAvailable -Name PSReadLine) {
            Import-Module PSReadLine -ErrorAction SilentlyContinue
            Log-Debug -Message "PSReadLine imported" -Component "Modules" -LogPath $debugLogPath
        }
    }

    # Terminal-Icons
    Measure-ProfileBlock -Name "Terminal-Icons" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Terminal-Icons" -Component "Modules" -LogPath $debugLogPath
        if (Get-Module -ListAvailable -Name Terminal-Icons) {
            Import-Module Terminal-Icons -ErrorAction SilentlyContinue
            Log-Debug -Message "Terminal-Icons imported" -Component "Modules" -LogPath $debugLogPath
        }
    }

    # Functions
    Measure-ProfileBlock -Name "Functions" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Functions" -Component "Functions" -LogPath $debugLogPath
        $functionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Functions.ps1"
        if (Test-Path -Path $functionsPath) {
            Log-Debug -Message "Testing functions file: $functionsPath" -Component "Functions" -LogPath $debugLogPath
            # Don't actually load it, just check if it exists
        }
    }

    # Completions
    Measure-ProfileBlock -Name "Completions" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Completions" -Component "Completions" -LogPath $debugLogPath
        $completionPath = Join-Path -Path $ProfileSourcePath -ChildPath "Completions"
        if (Test-Path -Path $completionPath) {
            $completionFiles = Get-ChildItem -Path $completionPath -Filter "*.ps1" -ErrorAction SilentlyContinue
            Log-Debug -Message "Found $($completionFiles.Count) completion files" -Component "Completions" -LogPath $debugLogPath

            # Test loading a single completion file to see if it hangs
            if ($completionFiles.Count -gt 0) {
                $testFile = $completionFiles[0]
                Log-Debug -Message "Testing completion file: $($testFile.Name)" -Component "Completions" -LogPath $debugLogPath
                # . $testFile.FullName  # Commented out to avoid actually loading it
            }
        }
    }

    # Oh-My-Posh
    Measure-ProfileBlock -Name "Oh-My-Posh" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing oh-my-posh" -Component "Prompt" -LogPath $debugLogPath
        if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
            Log-Debug -Message "oh-my-posh is available" -Component "Prompt" -LogPath $debugLogPath
            $promptPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Prompt.ps1'
            if (Test-Path -Path $promptPath) {
                Log-Debug -Message "Testing prompt file: $promptPath" -Component "Prompt" -LogPath $debugLogPath
                # Don't actually load it, just check if it exists
            }
        }
    }

    # Zoxide
    Measure-ProfileBlock -Name "Zoxide" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing zoxide" -Component "Zoxide" -LogPath $debugLogPath
        if (Get-Command zoxide -ErrorAction SilentlyContinue) {
            Log-Debug -Message "zoxide is available" -Component "Zoxide" -LogPath $debugLogPath
            # Just check if it's available, don't initialize
        }
    }

    # Now test loading each component one by one

    # Aliases
    Measure-ProfileBlock -Name "Profile.Aliases" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Profile.Aliases.ps1" -Component "Components" -LogPath $debugLogPath
        $aliasesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Aliases.ps1"
        if (Test-Path -Path $aliasesPath) {
            . $aliasesPath
            Log-Debug -Message "Loaded Profile.Aliases.ps1" -Component "Components" -LogPath $debugLogPath
        }
    }

    # DefaultParams
    Measure-ProfileBlock -Name "Profile.DefaultParams" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Profile.DefaultParams.ps1" -Component "Components" -LogPath $debugLogPath
        $defaultParamsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.DefaultParams.ps1"
        if (Test-Path -Path $defaultParamsPath) {
            . $defaultParamsPath
            Log-Debug -Message "Loaded Profile.DefaultParams.ps1" -Component "Components" -LogPath $debugLogPath
        }
    }

    # Extras
    Measure-ProfileBlock -Name "Profile.Extras" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Profile.Extras.ps1" -Component "Components" -LogPath $debugLogPath
        $extrasPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Extras.ps1"
        if (Test-Path -Path $extrasPath) {
            . $extrasPath
            Log-Debug -Message "Loaded Profile.Extras.ps1" -Component "Components" -LogPath $debugLogPath
        }
    }

    # Completions
    Measure-ProfileBlock -Name "Profile.Completions" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Profile.Completions.ps1" -Component "Components" -LogPath $debugLogPath
        $completionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Completions.ps1"
        if (Test-Path -Path $completionsPath) {
            . $completionsPath
            Log-Debug -Message "Loaded Profile.Completions.ps1" -Component "Components" -LogPath $debugLogPath
        }
    }

    # Modules
    Measure-ProfileBlock -Name "Profile.Modules" -Timings $timings -ScriptBlock {
        Log-Debug -Message "Testing Profile.Modules.ps1" -Component "Components" -LogPath $debugLogPath
        $modulesPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Modules.ps1"
        if (Test-Path -Path $modulesPath) {
            # . $modulesPath  # Commented out to avoid actually loading it
            Log-Debug -Message "Checked Profile.Modules.ps1" -Component "Components" -LogPath $debugLogPath
        }
    }
} catch {
    Log-Debug -Message "Error: $_" -Component "Error" -LogPath $debugLogPath
    Log-Debug -Message "Stack Trace: $($_.ScriptStackTrace)" -Component "Error" -LogPath $debugLogPath
}

# Finish timing
$mainStopwatch.Stop()
Log-Debug -Message "Debug profile completed in $($mainStopwatch.Elapsed.TotalSeconds) seconds" -Component "System" -LogPath $debugLogPath

# Display results
Write-Host "`nProfile Component Load Times:" -ForegroundColor Cyan
$timings.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
    Write-Host "  $($_.Key): $($_.Value.TotalSeconds) seconds" -ForegroundColor White
}

Write-Host "`nTotal debug profile completed in $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
Write-Host "Debug log has been written to $debugLogPath" -ForegroundColor Cyan
