<#
    .SYNOPSIS
        PowerShell Profile - Aliases
    .DESCRIPTION
        Defines aliases for commonly used commands and locations.
#>
[CmdletBinding()]
Param()

Begin {
    Write-Verbose "[BEGIN]: Aliases.ps1"

    # Dot source import function
    . $PSScriptRoot\Functions\Private\Import-Aliases.ps1
}

Process {
    Write-Verbose "[PROCESS]: Aliases.ps1"

    $AliasPath = Join-Path -Path $PSScriptRoot -ChildPath "Aliases"

    Import-AliasFile -AliasFile "$AliasPath\Development.Aliases.psd1" -ErrorAction SilentlyContinue
    Import-AliasFile -AliasFile "$AliasPath\Navigation.Aliases.psd1" -ErrorAction SilentlyContinue
    Import-AliasFile -AliasFile "$AliasPath\Program.Aliases.psd1" -ErrorAction SilentlyContinue
    Import-AliasFile -AliasFile "$AliasPath\System.Aliases.psd1" -ErrorAction SilentlyContinue

    if (-not $Global:AliasesImports) {
        Write-Warning "Global Variable for Alias Imports (`$Global:AliasesImports`) is not initialized."
    }
}

End {
    Write-Verbose "[END]: Aliases.ps1"
}
