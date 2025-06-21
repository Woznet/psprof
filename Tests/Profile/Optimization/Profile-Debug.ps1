# --------------------------------------------------------------
# PowerShell Core $PROFILE (Current User, All Hosts) - DEBUG VERSION
# --------------------------------------------------------------

using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Diagnostics.CodeAnalysis

<#
    .SYNOPSIS
        Debug version of PowerShell Profile with timing information
    .DESCRIPTION
        This script measures the execution time of each component of the profile
#>
#Requires -Version 7
[CmdletBinding()]
[SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Justification = 'PS7 Polyfill')]
[SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Profile Script')]
Param(
  [Parameter()]
  [Switch]$Vanilla,
  [Parameter()]
  [Switch]$NoImports
)

# Start the main stopwatch
$mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Starting profile load..." -ForegroundColor Cyan

# Create a function to measure execution time
function Measure-ScriptBlock {
    param(
        [string]$Name,
        [scriptblock]$ScriptBlock
    )

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    Write-Host "  Loading $Name..." -ForegroundColor Yellow -NoNewline

    try {
        & $ScriptBlock
        $sw.Stop()
        Write-Host " Done in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
    }
    catch {
        $sw.Stop()
        Write-Host " Error in $($sw.Elapsed.TotalSeconds) seconds" -ForegroundColor Red
        Write-Host "    $_" -ForegroundColor Red
    }

    return $sw.Elapsed
}

# --------------------------------------------------------------------
# Profile Variables
# --------------------------------------------------------------------

Measure-ScriptBlock -Name "Profile Variables" -ScriptBlock {
    # Profile Paths
    $ProfileRootPath = Split-Path -Path $PROFILE -Parent
    $ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

    # System Information
    if ($PSEdition -eq 'Desktop') {
      $Global:isWindows = $true
      $Global:isLinux = $false
      $Global:isMacOS = $false
    }
}

# --------------------------------------------------------------------
# Profile Environment
# --------------------------------------------------------------------

Measure-ScriptBlock -Name "Profile Environment" -ScriptBlock {
    # Set editor to VSCode
    if (Get-Command code -Type Application -ErrorAction SilentlyContinue) {
      $ENV:EDITOR = 'code'
    }
}

if ($Host.Name -eq 'ConsoleHost') {
    Measure-ScriptBlock -Name "PSReadLine Setup" -ScriptBlock {
        Write-Verbose "Detected Host: 'ConsoleHost'. Loading 'PSReadLine' Setup..."
        . "$ProfileSourcePath/Profile.PSReadLine.ps1"
    }
}

if (-not $NoImports) {
    $Imports = @(
        'Profile.Functions.ps1'
        'Profile.Aliases.ps1'
        'Profile.Completions.ps1'
        'Profile.Extras.ps1'
        'Profile.Prompt.ps1'
        'Profile.Modules.ps1'
        'Profile.DefaultParams.ps1'
    )

    ForEach ($Import in $Imports) {
        Measure-ScriptBlock -Name $Import -ScriptBlock {
            Write-Verbose "Importing: $Import"
            try {
                . "$ProfileSourcePath/$Import"
            } catch {
                Write-Warning "Failed to import: $Import"
            }
        }
    }
}

# setup zoxide
Measure-ScriptBlock -Name "zoxide initialization" -ScriptBlock {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    }
}

# Stop the main stopwatch
$mainStopwatch.Stop()
Write-Host "Profile loaded in $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
