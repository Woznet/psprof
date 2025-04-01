<#
    .SYNOPSIS
        PowerShell Profile - Modules Loader
    .DESCRIPTION
        Loads modules from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableModules
)

Begin {
    Write-Verbose "[BEGIN]: Modules.ps1"
    if ($DisableModules) {
        Write-Verbose "Modules are disabled. Skipping module loading."
        return
    }

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Modules.psd1"
    if (Test-Path $configPath) {
        $modulesConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded modules configuration from $configPath"
    } else {
        Write-Warning "Modules configuration not found: $configPath"
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: Modules.ps1"

    # Add custom module paths
    if ($modulesConfig.Paths) {
        foreach ($pathConfig in $modulesConfig.Paths) {
            if ($pathConfig.Enabled) {
                # Check platform if specified
                if ($pathConfig.Platform -and $pathConfig.Platform -ne 'Windows' -and -not $isWindows) {
                    continue
                }

                $modulePath = $ExecutionContext.InvokeCommand.ExpandString($pathConfig.Path)

                if (-not (Test-Path -Path $modulePath)) {
                    New-Item -Path $modulePath -ItemType Directory -Force | Out-Null
                    Write-Verbose "Created module path: $modulePath"
                }

                # Add to PSModulePath if not already included
                if (-not $env:PSModulePath.Contains($modulePath)) {
                    $env:PSModulePath = $modulePath + [IO.Path]::PathSeparator + $env:PSModulePath
                    Write-Verbose "Added module path to PSModulePath: $modulePath"
                }
            }
        }
    }

    # Import essential modules
    if ($modulesConfig.Essential) {
        foreach ($module in $modulesConfig.Essential) {
            # Skip PSReadLine as it's handled separately
            if ($module -eq 'PSReadLine') {
                Write-Verbose "Skipping PSReadLine module (handled separately)"
                continue
            }

            try {
                Write-Verbose "Importing essential module: $module"
                Import-Module $module -ErrorAction Stop
                Write-Verbose "Successfully imported module: $module"
            } catch {
                Write-Warning "Failed to import essential module: $module"

                # Try to install the module if it's not available
                try {
                    if (Get-Command Install-PSResource -ErrorAction SilentlyContinue) {
                        Write-Verbose "Attempting to install module using Install-PSResource: $module"
                        Install-PSResource $module -Scope CurrentUser -Force -ErrorAction Stop
                    } else {
                        Write-Verbose "Attempting to install module using Install-Module: $module"
                        Install-Module $module -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
                    }

                    # Try importing again
                    Import-Module $module -ErrorAction SilentlyContinue
                } catch {
                    Write-Error "Failed to install module: $module"
                }
            }
        }
    }

    # Import optional modules
    if ($modulesConfig.Optional) {
        foreach ($moduleConfig in $modulesConfig.Optional) {
            $module = $moduleConfig.Name

            try {
                Write-Verbose "Importing optional module: $module"
                Import-Module $module -ErrorAction Stop
                Write-Verbose "Successfully imported module: $module"
            } catch {
                Write-Verbose "Failed to import optional module: $module"

                # Try to install the module if AutoInstall is enabled
                if ($moduleConfig.AutoInstall) {
                    try {
                        if (Get-Command Install-PSResource -ErrorAction SilentlyContinue) {
                            Write-Verbose "Attempting to install module using Install-PSResource: $module"
                            Install-PSResource $module -Scope CurrentUser -Force -ErrorAction Stop
                        } else {
                            Write-Verbose "Attempting to install module using Install-Module: $module"
                            Install-Module $module -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
                        }

                        # Try importing again
                        Import-Module $module -ErrorAction SilentlyContinue
                    } catch {
                        Write-Warning "Failed to install optional module: $module"
                    }
                }
            }
        }
    }
}

End {
    Write-Verbose "[END]: Modules.ps1"
}
