<#
    .SYNOPSIS
        PowerShell Profile - Functions Loader
    .DESCRIPTION
        Loads functions from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableFunctions
)

Begin {
    Write-Verbose "[BEGIN]: Functions.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Functions.psd1"
    if (Test-Path $configPath) {
        $functionsConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded functions configuration from $configPath"
    } else {
        Write-Warning "Functions configuration not found: $configPath"
        return
    }

    # Check if functions are disabled
    if ($DisableFunctions -or $functionsConfig.Settings.DisableFunctions) {
        Write-Verbose "Functions are disabled. Skipping function loading."
        return
    }

    # Set up verbose output
    $verboseOutput = $functionsConfig.Settings.VerboseOutput
}

Process {
    Write-Verbose "[PROCESS]: Functions.ps1"

    # Load function categories
    if ($functionsConfig.Categories) {
        $functionPath = Join-Path -Path $ProfileRootPath -ChildPath "Profile/Functions"

        foreach ($category in $functionsConfig.Categories) {
            $categoryFile = Join-Path $functionPath "$category.ps1"
            Write-Progress -Activity "Loading function categories" -Status $category

            if (Test-Path $categoryFile) {
                try {
                    . $categoryFile
                    if ($verboseOutput) {
                        Write-Host "Loaded functions from: $category.ps1" -ForegroundColor Green
                    } else {
                        Write-Verbose "Loaded functions from: $category.ps1"
                    }
                } catch {
                    Write-Error "Failed to load functions from $category.ps1: $_"
                }
            } else {
                Write-Warning "Function category file not found: $categoryFile"
            }
        }

        Write-Progress -Activity "Loading function categories" -Completed
    }

    # Load individual functions
    if ($functionsConfig.Functions) {
        foreach ($function in $functionsConfig.Functions) {
            if ($function.Enabled) {
                $functionFile = Join-Path -Path $ProfileRootPath -ChildPath $function.Path

                if (Test-Path $functionFile) {
                    try {
                        . $functionFile
                        if ($verboseOutput) {
                            Write-Host "Loaded function: $($function.Name)" -ForegroundColor Green
                        } else {
                            Write-Verbose "Loaded function: $($function.Name)"
                        }
                    } catch {
                        Write-Error "Failed to load function $($function.Name): $_"
                    }
                } else {
                    Write-Warning "Function file not found: $functionFile"
                }
            }
        }
    }
}

End {
    Write-Verbose "[END]: Functions.ps1"
}
