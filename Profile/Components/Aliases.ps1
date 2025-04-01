<#
    .SYNOPSIS
        PowerShell Profile - Aliases Loader
    .DESCRIPTION
        Loads aliases from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableAliases
)

Begin {
    Write-Verbose "[BEGIN]: Aliases.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Aliases.psd1"
    if (Test-Path $configPath) {
        $aliasesConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded aliases configuration from $configPath"
    } else {
        Write-Warning "Aliases configuration not found: $configPath"
        return
    }

    # Check if aliases are disabled
    if ($DisableAliases -or $aliasesConfig.Settings.DisableAliases) {
        Write-Verbose "Aliases are disabled. Skipping aliases loading."
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: Aliases.ps1"

    # Set path aliases
    if ($aliasesConfig.PathAliases) {
        foreach ($alias in $aliasesConfig.PathAliases.Keys) {
            $value = $aliasesConfig.PathAliases[$alias]
            try {
                Set-Alias -Name $alias -Value $value -Scope Global -ErrorAction Stop
                Write-Verbose "Set path alias: $alias -> $value"
            } catch {
                Write-Warning ("Failed to set path alias {0} -> {1}: {2}" -f $alias, $value, $_.Exception.Message)
            }
        }
    }

    # Set command aliases
    if ($aliasesConfig.CommandAliases) {
        foreach ($alias in $aliasesConfig.CommandAliases.Keys) {
            $value = $aliasesConfig.CommandAliases[$alias]
            try {
                Set-Alias -Name $alias -Value $value -Scope Global -ErrorAction Stop
                Write-Verbose "Set command alias: $alias -> $value"
            } catch {
                Write-Warning ("Failed to set command alias {0} -> {1}: {2}" -f $alias, $value, $_.Exception.Message)
            }
        }
    }

    # Load aliases from files
    if ($aliasesConfig.Settings.LoadFromFiles) {
        $aliasesPath = Join-Path -Path $ProfileRootPath -ChildPath "Profile/Aliases"
        $aliasFiles = Get-ChildItem -Path $aliasesPath -Filter "*.ps1" -ErrorAction SilentlyContinue

        foreach ($file in $aliasFiles) {
            try {
                . $file.FullName
                Write-Verbose "Loaded aliases from file: $($file.Name)"
            } catch {
                Write-Warning ("Failed to load aliases from file {0}: {1}" -f $file.Name, $_.Exception.Message)
            }
        }
    }
}

End {
    Write-Verbose "[END]: Aliases.ps1"
}
