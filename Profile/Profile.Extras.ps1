using namespace System.Diagnostics.CodeAnalysis

# ---------------------------------------------------------------------
# PowerShell Profile - Integrations
# ---------------------------------------------------------------------
<#
    .SYNOPSIS
        Profile Integrations
#>
[SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification = 'ErrorView')]
Param()

# Scoop Fast Search Integration
if (Get-Command scoop-search -Type Application -ErrorAction SilentlyContinue) {
  Invoke-Expression (&scoop-search --hook)
}

# Force TLS 1.2
if ($PSEdition -eq 'Desktop') {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

# Concise ErrorView (PowerShell 7+)
if ($PSVersionTable.PSVersion.Major -ge 7) {
  $ErrorView = 'ConciseView'
}

# AzPredictor Integration
if ((Get-Module PSReadLine)[0].Version -gt 2.1.99 -and (Get-Command 'Enable-AzPredictor' -ErrorAction SilentlyContinue)) {
  Enable-AzPredictor
}

