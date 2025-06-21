<#
    .SYNOPSIS
        PowerShell Profile - Completions Loader
    .DESCRIPTION
        Loads completions from configuration data
#>
[CmdletBinding()]
Param(
    [Switch]$DisableCompletions
)

Begin {
    Write-Verbose "[BEGIN]: Completions.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Completions.psd1"
    if (Test-Path $configPath) {
        $completionsConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded completions configuration from $configPath"
    } else {
        Write-Warning "Completions configuration not found: $configPath"
        return
    }

    # Check if completions are disabled
    if ($DisableCompletions -or $completionsConfig.Settings.DisableCompletions) {
        Write-Verbose "Completions are disabled. Skipping completions loading."
        return
    }

    # Import LazyLoad functions
    $lazyLoadFunctionsPath = Join-Path -Path $ProfileRootPath -ChildPath "Profile/Functions/Private/LazyLoad-Functions.ps1"
    if (Test-Path -Path $lazyLoadFunctionsPath) {
        . $lazyLoadFunctionsPath
        Write-Verbose "Imported LazyLoad functions from $lazyLoadFunctionsPath"
    } else {
        Write-Warning "LazyLoad functions file not found: $lazyLoadFunctionsPath"
    }

    # Get completion files
    $completionPath = Join-Path -Path $ProfileRootPath -ChildPath "Profile/Completions"
    $completionFiles = Get-ChildItem -Path $completionPath -Filter "*.ps1" -ErrorAction SilentlyContinue
    Write-Verbose "Discovered $($completionFiles.Count) completion scripts in $completionPath"
}

Process {
    Write-Verbose "[PROCESS]: Completions.ps1"

    if (-not $completionsConfig.Settings.LazyLoad) {
        # Load all completions immediately
        $numFiles = $completionFiles.Count
        $i = 0
        ForEach ($file in $completionFiles) {
            $pct = if ($numFiles -ne 0) { ($i / $numFiles) * 100 } else { 0 }
            Write-Progress -Activity "Loading completion scripts" -Status "Loading..." -PercentComplete $pct
            Write-Verbose "Loading completion script: $file"
            try {
                . $file.FullName
                Write-Progress -Activity "Loading completions" -Status "Loaded $($file.Name)"
            } catch {
                Write-Error "Failed to load completion script $($file.Name): $_"
            }
            $i++
        }
        Write-Progress -Activity "Loading completion scripts" -Completed
    } else {
        # Use lazy loading for completions
        Write-Verbose "Setting up lazy loading for completions"

        # Register common completions for lazy loading
        if ($completionsConfig.CommonCommands) {
            foreach ($command in $completionsConfig.CommonCommands.Keys) {
                $scriptPath = $completionsConfig.CommonCommands[$command]
                $fullScriptPath = Join-Path -Path $ProfileRootPath -ChildPath $scriptPath

                if (Test-Path -Path $fullScriptPath) {
                    Write-Verbose "Registering lazy completion for $command"
                    Register-LazyCompletion -CommandName $command -ScriptPath $fullScriptPath
                } else {
                    Write-Warning "Completion script not found: $fullScriptPath"
                }
            }
        }
    }
}

End {
    Write-Verbose "[END]: Completions.ps1"
}
