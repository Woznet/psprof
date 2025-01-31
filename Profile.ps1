# --------------------------------------------------------------
# PowerShell Core $PROFILE (Current User, All Hosts)
# --------------------------------------------------------------

using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Diagnostics.CodeAnalysis

<#
    .SYNOPSIS
        Current User, All Hosts PowerShell `$PROFILE`: `Profile.ps1`
    .DESCRIPTION
        This script is executed when a new PowerShell session is created for the current user, on any host.
    .PARAMETER Vanilla
        Runs a "vanilla" session, without any configurations, variables, customizations, modules or scripts pre-loaded.
    .PARAMETER NoImports
        Skips importing modules and scripts.
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
#>
#Requires -Version 7
[SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Justification = 'PS7 Polyfill')]
[SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'Profile Script')]
Param(
  [Parameter()]
  [Switch]$Vanilla,
  [Parameter()]
  [Switch]$NoImports
)

# --------------------------------------------------------------------
# Profile Variables
# --------------------------------------------------------------------

# Profile Paths
$ProfileRootPath = Split-Path -Path $PROFILE -Parent
$ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

# System Information
if ($PSEdition -eq 'Desktop') {
  $Global:isWindows = $true
  $Global:isLinux = $false
  $Global:isMacOS = $false
}

# --------------------------------------------------------------------
# Profile Environment
# --------------------------------------------------------------------

# Set editor to VSCode
if (Get-Command code -Type Application -ErrorAction SilentlyContinue) {
  $ENV:EDITOR = 'code'
}

if ($Host.Name -eq 'ConsoleHost') {
  Write-Verbose "Detected Host: 'ConsoleHost'. Loading 'PSReadLine' Setup..."
  . "$ProfileSourcePath/Profile.PSReadLine.ps1"
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
    Write-Verbose "Importing: $Import"
    try {
      . "$ProfileSourcePath/$Import"
    } catch {
      Write-Warning "Failed to import: $Import"
    }
  }
}
