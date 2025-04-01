# --------------------------------------------------------------
# PowerShell Core $PROFILE (Current User, All Hosts)
# --------------------------------------------------------------

using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Diagnostics.CodeAnalysis

<#
    .SYNOPSIS
        PowerShell Profile with performance improvements and environment detection
    .DESCRIPTION
        This script is executed when a new PowerShell session is created for the current user, on any host.
        It includes performance improvements and environment detection to handle different PowerShell hosts.
    .PARAMETER Vanilla
        Runs a "vanilla" session, without any configurations, variables, customizations, modules or scripts pre-loaded.
    .PARAMETER NoImports
        Skips importing modules and scripts.
    .PARAMETER Measure
        Enables performance measurement of each profile component.
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
#>
#Requires -Version 7
[SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Justification = 'PS7 Polyfill')]
[SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Profile Script')]
[CmdletBinding()]
Param(
    [Parameter()]
    [switch]$Vanilla,
    [Parameter()]
    [switch]$NoImports,
    [Parameter()]
    [switch]$Measure,
    [Parameter()]
    [switch]$DebugLogging
)

if ($env:TERM_PROGRAM -eq "vscode") { . "$(code --locate-shell-integration-path pwsh)" }

# Import utility functions
$loggingFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath "Profile/Functions/Private/Logging-Functions.ps1"
if (Test-Path -Path $loggingFunctionsPath) {
    . $loggingFunctionsPath
    Write-Verbose "Imported logging functions from $loggingFunctionsPath"
} else {
    Write-Warning "Logging functions file not found: $loggingFunctionsPath"
    # Define minimal logging function as fallback
    function Write-ProfileLog { param([string]$Message) Write-Verbose $Message }
}
# Import Update-WinGet function
$updateWinGetPath = Join-Path -Path $PSScriptRoot -ChildPath "Profile/Functions/Public/Update-WinGet.ps1"
if (Test-Path -Path $updateWinGetPath) {
    . $updateWinGetPath
    Write-Verbose "Imported Update-WinGet function from $updateWinGetPath"
} else {
    Write-Warning "Update-WinGet function file not found: $updateWinGetPath"
}
# Import Apps.ps1 functions
$appsFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath "Profile/Functions/Apps.ps1"
if (Test-Path -Path $appsFunctionsPath) {
    . $appsFunctionsPath
    Write-Verbose "Imported Apps functions from $appsFunctionsPath"
} else {
    Write-Warning "Apps functions file not found: $appsFunctionsPath"
}

# Start timing if measurement is enabled
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}
}

# Initialize debug logging if enabled
if ($DebugLogging) {
    $debugLogPath = Join-Path -Path $PSScriptRoot -ChildPath "profile-debug.log"
    Initialize-DebugLog -LogPath $debugLogPath
    Write-ProfileLog -Message "Starting profile with debugging" -LogPath $debugLogPath
}

# Skip everything if Vanilla mode is enabled
if ($Vanilla) {
    Write-Host "Running in vanilla mode. Skipping profile customizations." -ForegroundColor Yellow
    return
}

# Environment detection
Measure-ProfileBlock -Name "Environment Detection" -Timings $timings -ScriptBlock {
    $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
    $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
    $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

    Write-ProfileLog "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE"
}

# Path setup
Measure-ProfileBlock -Name "Path Setup" -Timings $timings -ScriptBlock {
    $Global:ProfileRootPath = $PSScriptRoot
    $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

    Write-ProfileLog "ProfileRootPath: $ProfileRootPath"
    Write-ProfileLog "ProfileSourcePath: $ProfileSourcePath"
}

# Essential modules
Measure-ProfileBlock -Name "Essential Modules" -Timings $timings -ScriptBlock {
    # PSReadLine (essential)
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Write-ProfileLog "Loading PSReadLine"
        Import-Module PSReadLine -ErrorAction SilentlyContinue

        # Basic PSReadLine configuration
        Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue

        # Check PSReadLine version before setting prediction options
        $psrlVersion = (Get-Module PSReadLine).Version
        if ($psrlVersion -ge [Version]"2.2.0") {
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
            Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
        }

        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue
    }

    # Terminal-Icons (essential for directory listing)
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        Write-ProfileLog "Loading Terminal-Icons"
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }

    # Import Chocolatey Module Profile
    Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
}

# Import core profile components
if (-not $NoImports) {
    Measure-ProfileBlock -Name "Core Components" -Timings $timings -ScriptBlock {
        $CoreImports = @(
            @{ Name = 'Functions'; Path = 'Profile.Functions.ps1' }
            @{ Name = 'Aliases'; Path = 'Profile.Aliases.ps1' }
            @{ Name = 'DefaultParams'; Path = 'Profile.DefaultParams.ps1' }
        )

        foreach ($Import in $CoreImports) {
            Write-ProfileLog "Loading $($Import.Name)"
            $importPath = Join-Path -Path $ProfileSourcePath -ChildPath $Import.Path
            if (Test-Path -Path $importPath) {
                try {
                    . $importPath
                } catch {
                    Write-Warning "Failed to import $($Import.Name): $_"
                    Write-ProfileLog "Error loading $($Import.Name): $_"
                }
            } else {
                Write-Warning "Import file not found: $importPath"
                Write-ProfileLog "Import file not found: $importPath"
            }
        }
    }

    # Prompt (only if oh-my-posh is installed and not in VSCode)
    Measure-ProfileBlock -Name "Prompt" -Timings $timings -ScriptBlock {
        if (-not $isVSCode -and (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
            Write-ProfileLog "Loading oh-my-posh prompt"
            $promptPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Prompt.ps1'
            if (Test-Path -Path $promptPath) {
                try {
                    . $promptPath
                } catch {
                    Write-Warning "Failed to configure prompt: $_"
                    Write-ProfileLog "Error loading prompt: $_"
                }
            }
        } else {
            if ($isVSCode) {
                Write-ProfileLog "Skipping oh-my-posh in VSCode"
            } else {
                Write-ProfileLog "oh-my-posh not found"
            }
        }
    }

    # Load completions
    Measure-ProfileBlock -Name "Completions Setup" -Timings $timings -ScriptBlock {
        $completionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Completions.ps1"
        if (Test-Path -Path $completionsPath) {
            try {
                . $completionsPath
                Write-ProfileLog "Loaded completions from $completionsPath"
            } catch {
                Write-Warning "Failed to load completions: $_"
                Write-ProfileLog "Error loading completions: $_"
            }
        } else {
            Write-Warning "Completions file not found: $completionsPath"
            Write-ProfileLog "Completions file not found: $completionsPath"
        }
    }

    # Load non-essential modules sequentially
    Measure-ProfileBlock -Name "Optional Modules" -Timings $timings -ScriptBlock {
        $OptionalModules = @(
            'posh-git'
            'CompletionPredictor'
            'Microsoft.PowerShell.ConsoleGuiTools'
            'F7History'
            'PoshCodex'
        )

        # Load optional modules sequentially
        foreach ($module in $OptionalModules) {
            if (Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue) {
                Write-ProfileLog "Loading optional module: $module"
                Import-Module $module -ErrorAction SilentlyContinue
            }
        }
    }

    # Load extras last
    Measure-ProfileBlock -Name "Extras" -Timings $timings -ScriptBlock {
        $extrasPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Extras.ps1'
        if (Test-Path -Path $extrasPath) {
            Write-ProfileLog "Loading extras"
            try {
                . $extrasPath
            } catch {
                Write-Warning "Failed to load extras: $_"
                Write-ProfileLog "Error loading extras: $_"
            }
        }
    }
}

# Setup zoxide (simplified approach)
Measure-ProfileBlock -Name "zoxide" -Timings $timings -ScriptBlock {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Write-ProfileLog "Initializing zoxide"
        try {
            Invoke-Expression (& { (zoxide init powershell | Out-String) })
        } catch {
            Write-Warning "Failed to initialize zoxide: $_"
            Write-ProfileLog "Error initializing zoxide: $_"
        }
    }
}

# Display timing information if measurement is enabled
if ($Measure) {
    $mainStopwatch.Stop()

    Write-Host "`nProfile Load Times:" -ForegroundColor Cyan
    $timings.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value.TotalSeconds) seconds" -ForegroundColor White
    }

    Write-Host "`nTotal profile load time: $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
}

if ($DebugLogging) {
    Write-Host "`nDebug log has been written to $debugLogPath" -ForegroundColor Cyan
}
