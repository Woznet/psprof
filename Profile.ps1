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
# Start timing if measurement is enabled
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}

    function Measure-Block {
        param(
            [string]$Name,
            [scriptblock]$ScriptBlock
        )

        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $ScriptBlock
        $sw.Stop()
        $timings[$Name] = $sw.Elapsed

        Write-Host "  $Name completed in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
    }
} else {
    function Measure-Block {
        param(
            [string]$Name,
            [scriptblock]$ScriptBlock
        )

        & $ScriptBlock
    }
}

# Debug logging
if ($DebugLogging) {
    $debugLog = @()
    $debugLogPath = Join-Path -Path $PSScriptRoot -ChildPath "profile-debug.log"
    "" | Out-File -FilePath $debugLogPath -Force

    function Log-Debug {
        param([string]$Message)
        $timestamp = Get-Date -Format "HH:mm:ss.fff"
        $entry = "$timestamp - $Message"
        $global:debugLog += $entry
        $entry | Out-File -FilePath $debugLogPath -Append
        Write-Verbose $entry
    }

    Log-Debug "Starting profile with debugging"
} else {
    function Log-Debug {
        param([string]$Message)
        Write-Verbose $Message
    }
}

# Skip everything if Vanilla mode is enabled
if ($Vanilla) {
    Write-Host "Running in vanilla mode. Skipping profile customizations." -ForegroundColor Yellow
    return
}

# Environment detection
Measure-Block -Name "Environment Detection" -ScriptBlock {
    $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
    $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
    $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

    Log-Debug "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE"
}

# Path setup
Measure-Block -Name "Path Setup" -ScriptBlock {
    $Global:ProfileRootPath = $PSScriptRoot
    $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

    Log-Debug "ProfileRootPath: $ProfileRootPath"
    Log-Debug "ProfileSourcePath: $ProfileSourcePath"
}

# Essential modules
Measure-Block -Name "Essential Modules" -ScriptBlock {
    # PSReadLine (essential)
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Log-Debug "Loading PSReadLine"
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
        Log-Debug "Loading Terminal-Icons"
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }
}

# Import core profile components
if (-not $NoImports) {
    Measure-Block -Name "Core Components" -ScriptBlock {
        $CoreImports = @(
            @{ Name = 'Functions'; Path = 'Profile.Functions.ps1' }
            @{ Name = 'Aliases'; Path = 'Profile.Aliases.ps1' }
            @{ Name = 'DefaultParams'; Path = 'Profile.DefaultParams.ps1' }
        )

        foreach ($Import in $CoreImports) {
            Log-Debug "Loading $($Import.Name)"
            $importPath = Join-Path -Path $ProfileSourcePath -ChildPath $Import.Path
            if (Test-Path -Path $importPath) {
                try {
                    . $importPath
                } catch {
                    Write-Warning "Failed to import $($Import.Name): $_"
                    Log-Debug "Error loading $($Import.Name): $_"
                }
            } else {
                Write-Warning "Import file not found: $importPath"
                Log-Debug "Import file not found: $importPath"
            }
        }
    }

    # Prompt (only if oh-my-posh is installed and not in VSCode)
    Measure-Block -Name "Prompt" -ScriptBlock {
        if (-not $isVSCode -and (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
            Log-Debug "Loading oh-my-posh prompt"
            $promptPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Prompt.ps1'
            if (Test-Path -Path $promptPath) {
                try {
                    . $promptPath
                } catch {
                    Write-Warning "Failed to configure prompt: $_"
                    Log-Debug "Error loading prompt: $_"
                }
            }
        } else {
            if ($isVSCode) {
                Log-Debug "Skipping oh-my-posh in VSCode"
            } else {
                Log-Debug "oh-my-posh not found"
            }
        }
    }

    # Load completions
    Measure-Block -Name "Completions Setup" -ScriptBlock {
        $completionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Completions.ps1"
        if (Test-Path -Path $completionsPath) {
            try {
                . $completionsPath
                Log-Debug "Loaded completions from $completionsPath"
            } catch {
                Write-Warning "Failed to load completions: $_"
                Log-Debug "Error loading completions: $_"
            }
        } else {
            Write-Warning "Completions file not found: $completionsPath"
            Log-Debug "Completions file not found: $completionsPath"
        }
    }

    # Load non-essential modules sequentially
    Measure-Block -Name "Optional Modules" -ScriptBlock {
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
                Log-Debug "Loading optional module: $module"
                Import-Module $module -ErrorAction SilentlyContinue
            }
        }
    }

    # Load extras last
    Measure-Block -Name "Extras" -ScriptBlock {
        $extrasPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Extras.ps1'
        if (Test-Path -Path $extrasPath) {
            Log-Debug "Loading extras"
            try {
                . $extrasPath
            } catch {
                Write-Warning "Failed to load extras: $_"
                Log-Debug "Error loading extras: $_"
            }
        }
    }
}

# Setup zoxide (simplified approach)
Measure-Block -Name "zoxide" -ScriptBlock {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Log-Debug "Initializing zoxide"
        try {
            Invoke-Expression (& { (zoxide init powershell | Out-String) })
        } catch {
            Write-Warning "Failed to initialize zoxide: $_"
            Log-Debug "Error initializing zoxide: $_"
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
