<#
    .SYNOPSIS
        PowerShell Profile - Extras Loader
    .DESCRIPTION
        Loads extra integrations and settings from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableExtras
)

Begin {
    Write-Verbose "[BEGIN]: Extras.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Extras.psd1"
    if (Test-Path $configPath) {
        $extrasConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded extras configuration from $configPath"
    } else {
        Write-Warning "Extras configuration not found: $configPath"
        return
    }

    # Check if extras are disabled
    if ($DisableExtras) {
        Write-Verbose "Extras are disabled. Skipping extras loading."
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: Extras.ps1"

    # Scoop Fast Search Integration
    if ($extrasConfig.ScoopFastSearch.Enabled) {
        if (Get-Command scoop-search -Type Application -ErrorAction SilentlyContinue) {
            try {
                Write-Verbose "Configuring Scoop Fast Search integration"
                Invoke-Expression (&scoop-search --hook)
                Write-Verbose "Scoop Fast Search integration configured"
            } catch {
                Write-Warning "Failed to configure Scoop Fast Search integration: $_"
            }
        } else {
            Write-Verbose "Scoop Fast Search is not installed. Skipping integration."
        }
    }

    # Force TLS 1.2 for Desktop Edition
    if ($extrasConfig.ForceTLS12.Enabled) {
        if ($PSEdition -eq 'Desktop') {
            try {
                Write-Verbose "Forcing TLS 1.2 for Desktop Edition"
                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                Write-Verbose "TLS 1.2 forced for Desktop Edition"
            } catch {
                Write-Warning "Failed to force TLS 1.2 for Desktop Edition: $_"
            }
        }
    }

    # Concise ErrorView (PowerShell 7+)
    if ($extrasConfig.ConciseErrorView.Enabled) {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            try {
                Write-Verbose "Setting Concise ErrorView for PowerShell 7+"
                $ErrorView = 'ConciseView'
                Write-Verbose "Concise ErrorView set for PowerShell 7+"
            } catch {
                Write-Warning "Failed to set Concise ErrorView for PowerShell 7+: $_"
            }
        }
    }

    # AzPredictor Integration
    if ($extrasConfig.AzPredictor.Enabled) {
        if ((Get-Module PSReadLine)[0].Version -gt 2.1.99 -and (Get-Command 'Enable-AzPredictor' -ErrorAction SilentlyContinue)) {
            try {
                Write-Verbose "Enabling AzPredictor integration"
                Enable-AzPredictor
                Write-Verbose "AzPredictor integration enabled"
            } catch {
                Write-Warning "Failed to enable AzPredictor integration: $_"
            }
        } else {
            Write-Verbose "AzPredictor is not available. Skipping integration."
        }
    }
}

End {
    Write-Verbose "[END]: Extras.ps1"
}
