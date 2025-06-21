<#
    .SYNOPSIS
        PowerShell Profile - Custom Functions Loader
    .DESCRIPTION
        Loads custom functions from the Profile/functions directory.
    .PARAMETER DisableFunctions
        Disables loading of custom functions.
#>
[CmdletBinding()]
Param(
    [Switch]$DisableFunctions
)

Begin {
    Write-Verbose "[BEGIN]: Profile.Functions.ps1"
    if ($DisableFunctions) {
        Write-Verbose "Functions are disabled. Skipping function loading."
        return
    }

    # Define function categories and their files
    $FunctionCategories = @(
        'Environment',
        'Navigation',
        'System',
        'FileSystem',
        'AdminTools',
        'HashingTools',
        'ProfileTools',
        'DialogTools',
        'Apps'
    )

    $functionPath = Join-Path $PSScriptRoot "Functions"
    if (-not (Test-Path $functionPath)) {
        New-Item -Path $functionPath -ItemType Directory -Force
    }
}

Process {
    Write-Verbose "[PROCESS]: Profile.Functions.ps1"

    foreach ($category in $FunctionCategories) {
        $categoryFile = Join-Path $functionPath "$category.ps1"
        Write-Progress -Activity "Loading function categories" -Status $category

        if (Test-Path $categoryFile) {
            try {
                . $categoryFile
                Write-Verbose "Loaded functions from: $category.ps1"
            } catch {
                Write-Error "Failed to load functions from $category.ps1: $_"
            }
        } else {
            Write-Warning "Function category file not found: $categoryFile"
        }
    }

    Write-Progress -Activity "Loading function categories" -Completed
}

End {
    Write-Verbose "[END]: Profile.Functions.ps1"
    . $functionPath\Public\Start-GitKraken.ps1
}
