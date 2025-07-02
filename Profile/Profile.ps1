<#
    .SYNOPSIS
        PowerShell Profile - Main Loader
    .DESCRIPTION
        Main loader for PowerShell profile components.
    .PARAMETER Vanilla
        Runs a "vanilla" session, without any configurations, variables, customizations, modules or scripts pre-loaded.
    .PARAMETER NoImports
        Skips importing modules and scripts.
    .PARAMETER Measure
        Enables performance measurement of each profile component.
    .PARAMETER DebugLogging
        Enables debug logging.
#>
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

# Skip everything if Vanilla mode is enabled
if ($Vanilla) {
    Write-Host "Running in vanilla mode. Skipping profile customizations." -ForegroundColor Yellow
    return
}

# Set up global variables
$Global:ProfileRootPath = Split-Path -Parent $PSScriptRoot
$Global:ProfileSourcePath = $PSScriptRoot

# Load configuration
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "Profile.Configuration.psd1"
if (Test-Path $configPath) {
    $Global:ProfileConfig = Import-PowerShellDataFile -Path $configPath
    Write-Verbose "Loaded profile configuration from $configPath"
} else {
    Write-Warning "Profile configuration not found: $configPath"
    return
}

# Environment detection
$Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
$Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
$Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

Write-Verbose "Environment: VSCode=$isVSCode, RegularPS=$isRegularPowerShell, ISE=$isISE"

# Import components
if (-not $NoImports) {
    $componentsPath = Join-Path -Path $PSScriptRoot -ChildPath "Components"

    # Get the import order from configuration
    $importOrder = $ProfileConfig.ImportOrder
    if (-not $importOrder) {
        # Default import order if not specified in config
        $importOrder = @(
            'DefaultParams'
            'Aliases'
            'Functions'
            'Modules'
            'PSReadLine'
            'Style'
            'Completions'
            'Prompt'
        )
    }

    # Import components in the specified order
    foreach ($componentName in $importOrder) {
        $componentPath = Join-Path -Path $componentsPath -ChildPath "$componentName.ps1"

        if (Test-Path -Path $componentPath) {
            try {
                if ($Measure) {
                    $sw = [System.Diagnostics.Stopwatch]::StartNew()
                }

                Write-Verbose "Loading component: $componentName"
                . $componentPath

                if ($Measure) {
                    $sw.Stop()
                    Write-Host "Loaded component $componentName in $($sw.ElapsedMilliseconds)ms" -ForegroundColor Cyan
                } else {
                    Write-Verbose "Successfully loaded component: $componentName"
                }
            } catch {
                Write-Error ("Failed to load component {0}: {1}" -f $componentName, $_.Exception.Message)
            }
        } else {
            Write-Warning "Component file not found: $componentPath"
        }
    }
}
