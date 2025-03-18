# Profile-Optimized.ps1
# An optimized version of the profile

[CmdletBinding()]
param(
    [switch]$Vanilla,
    [switch]$NoImports,
    [switch]$Measure,
    [switch]$Debug
)

# Import utility functions
$loggingFunctionsPath = Join-Path -Path (Split-Path -Parent $PSScriptRoot) -ChildPath "Profile/Functions/Private/Logging-Functions.ps1"
if (Test-Path -Path $loggingFunctionsPath) {
    . $loggingFunctionsPath
    Write-Verbose "Imported logging functions from $loggingFunctionsPath"
} else {
    Write-Warning "Logging functions file not found: $loggingFunctionsPath"
    # Define minimal logging function as fallback
    function Log-Debug { param([string]$Message) Write-Verbose $Message }
}

# Start timing if measurement is enabled
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}
}

# Initialize debug logging if enabled
if ($Debug) {
    $debugLogPath = "$PSScriptRoot\profile-optimized-debug.log"
    Initialize-DebugLog -LogPath $debugLogPath
    Log-Debug -Message "Starting profile with debugging" -LogPath $debugLogPath
}

# Skip everything if Vanilla mode is enabled
if ($Vanilla) {
    Write-Host "Running in vanilla mode. Skipping profile customizations." -ForegroundColor Yellow
    return
}

# Environment detection
Measure-ProfileBlock -Name "Environment Detection" -Timings $timings -ScriptBlock {
    $Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
    $Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
    $Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

    Log-Debug "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE"
}

# Path setup
Measure-ProfileBlock -Name "Path Setup" -Timings $timings -ScriptBlock {
    $Global:ProfileRootPath = Split-Path -Parent $PSScriptRoot
    $Global:ProfileSourcePath = Join-Path -Path $ProfileRootPath -ChildPath 'Profile'

    Log-Debug "ProfileRootPath: $ProfileRootPath"
    Log-Debug "ProfileSourcePath: $ProfileSourcePath"
}

# Essential modules
Measure-ProfileBlock -Name "Essential Modules" -Timings $timings -ScriptBlock {
    # PSReadLine (essential)
    if (Get-Module -ListAvailable -Name PSReadLine) {
        Log-Debug "Loading PSReadLine"
        Import-Module PSReadLine -ErrorAction SilentlyContinue

        # Basic PSReadLine configuration
        Set-PSReadLineOption -EditMode Windows -ErrorAction SilentlyContinue

        # Check PSReadLine version before setting prediction options
        $psrlVersion = (Get-Module PSReadLine).Version
        if ($psrlVersion -ge [Version]"2.2.0") {
            Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction SilentlyContinue
            Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
        }

        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward -ErrorAction SilentlyContinue
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward -ErrorAction SilentlyContinue
    }

    # Terminal-Icons (essential for directory listing)
    if (Get-Module -ListAvailable -Name Terminal-Icons) {
        Log-Debug "Loading Terminal-Icons"
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }
}

# Import core profile components
if (-not $NoImports) {
    Measure-ProfileBlock -Name "Core Components" -Timings $timings -ScriptBlock {
        $CoreImports = @(
            @{ Name = 'Functions'; Path = 'Profile.Functions.ps1' }
            @{ Name = 'Aliases'; Path = 'Profile.Aliases.ps1' }
            @{ Name = 'DefaultParams'; Path = 'Profile.DefaultParams.ps1' }
        )

        foreach ($Import in $CoreImports) {
            Log-Debug "Loading $($Import.Name)"
            $importPath = Join-Path -Path $ProfileSourcePath -ChildPath $Import.Path
            if (Test-Path -Path $importPath) {
                try {
                    . $importPath
                } catch {
                    Write-Warning "Failed to import $($Import.Name): $_"
                    Log-Debug "Error loading $($Import.Name): $_"
                }
            } else {
                Write-Warning "Import file not found: $importPath"
                Log-Debug "Import file not found: $importPath"
            }
        }
    }

    # Prompt (only if oh-my-posh is installed and not in VSCode)
    Measure-ProfileBlock -Name "Prompt" -Timings $timings -ScriptBlock {
        if (-not $isVSCode -and (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
            Log-Debug "Loading oh-my-posh prompt"
            $promptPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Prompt.ps1'
            if (Test-Path -Path $promptPath) {
                try {
                    . $promptPath
                } catch {
                    Write-Warning "Failed to configure prompt: $_"
                    Log-Debug "Error loading prompt: $_"
                }
            }
        } else {
            if ($isVSCode) {
                Log-Debug "Skipping oh-my-posh in VSCode"
            } else {
                Log-Debug "oh-my-posh not found"
            }
        }
    }

    # Load completions
    Measure-ProfileBlock -Name "Completions Setup" -Timings $timings -ScriptBlock {
        $completionsPath = Join-Path -Path $ProfileSourcePath -ChildPath "Profile.Completions.ps1"
        if (Test-Path -Path $completionsPath) {
            try {
                . $completionsPath
                Log-Debug "Loaded completions from $completionsPath"
            } catch {
                Write-Warning "Failed to load completions: $_"
                Log-Debug "Error loading completions: $_"
            }
        } else {
            Write-Warning "Completions file not found: $completionsPath"
            Log-Debug "Completions file not found: $completionsPath"
        }
    }

    # Load non-essential modules in the background
    Measure-ProfileBlock -Name "Background Module Loading" -Timings $timings -ScriptBlock {
        $OptionalModules = @(
            'posh-git'
            'CompletionPredictor'
            'Microsoft.PowerShell.ConsoleGuiTools'
            'F7History'
            'PoshCodex'
        )

        # Start a background job to load optional modules
        $job = $null
        try {
            # Try to use Start-ThreadJob if available
            if (Get-Command Start-ThreadJob -ErrorAction SilentlyContinue) {
                $job = Start-ThreadJob -ScriptBlock {
                    param($modules)
                    foreach ($module in $modules) {
                        if (Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue) {
                            Import-Module $module -ErrorAction SilentlyContinue
                        }
                    }
                } -ArgumentList @($OptionalModules) -ErrorAction SilentlyContinue
            } else {
                # Fall back to Start-Job
                $job = Start-Job -ScriptBlock {
                    param($modules)
                    foreach ($module in $modules) {
                        if (Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue) {
                            Import-Module $module -ErrorAction SilentlyContinue
                        }
                    }
                } -ArgumentList @($OptionalModules) -ErrorAction SilentlyContinue
            }
        } catch {
            Log-Debug "Error starting background job: $_"
            $job = $null
        }

        if ($job) {
            Log-Debug "Started background job for optional modules: Job ID $($job.Id)"
        } else {
            Log-Debug "Failed to start background job for optional modules"
            # Fall back to sequential loading if background job fails
            foreach ($module in $OptionalModules) {
                if (Get-Module -ListAvailable -Name $module -ErrorAction SilentlyContinue) {
                    Import-Module $module -ErrorAction SilentlyContinue
                }
            }
        }
    }

    # Load extras last
    Measure-ProfileBlock -Name "Extras" -Timings $timings -ScriptBlock {
        $extrasPath = Join-Path -Path $ProfileSourcePath -ChildPath 'Profile.Extras.ps1'
        if (Test-Path -Path $extrasPath) {
            Log-Debug "Loading extras"
            try {
                . $extrasPath
            } catch {
                Write-Warning "Failed to load extras: $_"
                Log-Debug "Error loading extras: $_"
            }
        }
    }
}

# Setup zoxide (simplified approach)
Measure-ProfileBlock -Name "zoxide" -Timings $timings -ScriptBlock {
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Log-Debug "Initializing zoxide"
        try {
            # Direct initialization without caching
            Invoke-Expression (& { (zoxide init powershell --hook prompt) })
        } catch {
            Write-Warning "Failed to initialize zoxide: $_"
            Log-Debug "Error initializing zoxide: $_"
        }
    }
}

# Display timing information if measurement is enabled
if ($Measure) {
    $mainStopwatch.Stop()

    Write-Host "`nProfile Load Times:" -ForegroundColor Cyan
    $timings.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value.TotalSeconds) seconds" -ForegroundColor White
    }

    Write-Host "`nTotal profile load time: $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
}

if ($Debug) {
    Write-Host "`nDebug log has been written to $debugLogPath" -ForegroundColor Cyan
}
