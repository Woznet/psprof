<#
    .SYNOPSIS
        PowerShell Profile - Default Parameters Loader
    .DESCRIPTION
        Loads default parameters from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableDefaultParams
)

Begin {
    Write-Verbose "[BEGIN]: DefaultParams.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\DefaultParams.psd1"
    if (Test-Path $configPath) {
        $defaultParamsConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded default parameters configuration from $configPath"
    } else {
        Write-Warning "Default parameters configuration not found: $configPath"
        return
    }

    # Check if default parameters are disabled
    if ($DisableDefaultParams) {
        Write-Verbose "Default parameters are disabled. Skipping default parameters loading."
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: DefaultParams.ps1"

    # Set default parameters
    if ($defaultParamsConfig) {
        # Create a new hashtable for $PSDefaultParameterValues if it doesn't exist
        if (-not (Get-Variable -Name PSDefaultParameterValues -ErrorAction SilentlyContinue)) {
            $global:PSDefaultParameterValues = @{}
        }

        # Add each parameter from the configuration
        foreach ($key in $defaultParamsConfig.Keys) {
            $value = $defaultParamsConfig[$key]
            try {
                $global:PSDefaultParameterValues[$key] = $value
                Write-Verbose ("Set default parameter: {0} = {1}" -f $key, $value)
            } catch {
                Write-Warning ("Failed to set default parameter {0} = {1}: {2}" -f $key, $value, $_.Exception.Message)
            }
        }
    }
}

End {
    Write-Verbose "[END]: DefaultParams.ps1"
}
