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

# Load VSCode shell integration if applicable
if ($env:TERM_PROGRAM -eq "vscode" -or $Host.Name -match 'Visual Studio Code') {
    try {
        . "$(code --locate-shell-integration-path pwsh)"
    } catch {
        Write-Verbose "Failed to load VSCode shell integration: $_"
    }
} elseif ($env:TERM_PROGRAM -eq "vscode-insiders" -or $Host.Name -match 'Visual Studio Code Insiders') {
    try {
        # Try to use the insiders command for shell integration
        . "$(code-insiders --locate-shell-integration-path pwsh)"
    } catch {
        Write-Verbose "Failed to load VSCode Insiders shell integration: $_"
    }
}

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

# Skip everything if Vanilla mode is enabled
if ($Vanilla) {
    Write-Host "Running in vanilla mode. Skipping profile customizations." -ForegroundColor Yellow
    return
}

# Load the new profile structure
$newProfilePath = Join-Path -Path $PSScriptRoot -ChildPath "Profile/Profile.ps1"
if (Test-Path -Path $newProfilePath) {
    try {
        . $newProfilePath -Vanilla:$Vanilla -NoImports:$NoImports -Measure:$Measure -DebugLogging:$DebugLogging
    } catch {
        Write-Warning "Failed to load profile structure: $_"
    }
} else {
    Write-Warning "Profile structure not found: $newProfilePath"
}
