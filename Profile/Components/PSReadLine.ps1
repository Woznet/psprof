<#
    .SYNOPSIS
        PowerShell Profile - PSReadLine Configuration
    .DESCRIPTION
        Configures PSReadLine settings and key bindings.
    .PARAMETER DisablePSReadLine
        Disables PSReadLine configuration.
#>
[CmdletBinding()]
Param(
    [Switch]$DisablePSReadLine
)

Begin {
    Write-Verbose "[BEGIN]: PSReadLine.ps1"
    if ($DisablePSReadLine) {
        Write-Verbose "PSReadLine configuration is disabled. Skipping PSReadLine configuration."
        return
    }

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\PSReadLine.psd1"
    if (Test-Path $configPath) {
        $psReadLineConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded PSReadLine configuration from $configPath"
    } else {
        Write-Warning "PSReadLine configuration not found: $configPath"
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: PSReadLine.ps1"

    # Check if PSReadLine is already loaded
    $psrlModule = Get-Module -Name PSReadLine
    if (-not $psrlModule) {
        Write-Warning "PSReadLine module is not loaded. Skipping PSReadLine configuration."
        return
    }

    # Set Default Params for Set-PSReadLineOption and Set-PSReadLineKeyHandler
    $PSDefaultParameterValues = @{
        "Set-PSReadLineOption:WarningAction"     = 'SilentlyContinue'
        "Set-PSReadLineOption:ErrorAction"       = 'SilentlyContinue'
        "Set-PSReadLineKeyHandler:WarningAction" = 'SilentlyContinue'
        "Set-PSReadLineKeyHandler:ErrorAction"   = 'SilentlyContinue'
    }

    try {
        # --------------------------------------------------------------------
        # PSReadLine Options
        # --------------------------------------------------------------------

        # Edit Mode
        if ($psReadLineConfig.EditMode) {
            Set-PSReadLineOption -EditMode $psReadLineConfig.EditMode
        }

        # History No Duplicates
        if ($psReadLineConfig.HistoryNoDuplicates) {
            Set-PSReadLineOption -HistoryNoDuplicates:$psReadLineConfig.HistoryNoDuplicates
        }

        # History Search Cursor Moves To End
        if ($psReadLineConfig.HistorySearchCursorMovesToEnd) {
            Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$psReadLineConfig.HistorySearchCursorMovesToEnd
        }

        # Prediction Source
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin

        # Prediction View Style
        Set-PSReadLineOption -PredictionViewStyle ListView

        # Colors
        if ($psReadLineConfig.Colors) {
            Set-PSReadLineOption -Colors $psReadLineConfig.Colors
        }

        # --------------------------------------------------------------------
        # PSReadLine Key Bindings
        # --------------------------------------------------------------------

        # History search with arrow keys
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

        # Accept next suggestion word with Alt+RightArrow
        Set-PSReadLineKeyHandler -Key 'Alt+RightArrow' -Function 'AcceptNextSuggestionWord'

        # Capture Screen (Interactive Selection from Terminal via "Chord")
        Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen

        # Edit current directory with Visual Studio Code
        Set-PSReadLineKeyHandler -Description 'Edit current directory with Visual Studio Code' -Chord Ctrl+Shift+e -ScriptBlock {
            if (Get-Command code-insiders -ErrorAction SilentlyContinue) { code-insiders . } else {
                code .
            }
        }
    } catch {
        Write-Error "Failed to configure PSReadLine: $_"
    }
}

End {
    Write-Verbose "[END]: PSReadLine.ps1"
}
