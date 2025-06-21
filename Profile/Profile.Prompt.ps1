<#
    .SYNOPSIS
        PowerShell Profile - Prompt Configuration
    .DESCRIPTION
        Configures the PowerShell prompt using Oh-My-Posh.
    .PARAMETER DisablePrompt
        Disables custom prompt configuration.
#>
Param(
    [Switch]$DisablePrompt
)

Begin {
    Write-Verbose "[BEGIN]: Profile.Prompt.ps1"
    if ($DisablePrompt) {
        Write-Verbose "Prompt customization is disabled. Skipping prompt configuration."
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: Profile.Prompt.ps1"

    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        try {
            Write-Verbose "Configuring Oh-My-Posh prompt"
            $ohMyPoshConfigPath = Join-Path "$Env:POSH_THEMES_PATH" 'wopian.omp.json'
            if (Test-Path -Path $ohMyPoshConfigPath) {
                $Expression = (& oh-my-posh init pwsh --config=$ohMyPoshConfigPath --print) -join "`n"
                $Expression | Invoke-Expression
            } else {
                Write-Error "Oh-My-Posh configuration path is not valid: $ohMyPoshConfigPath"
            }
            Remove-Variable -Name ohMyPoshConfigPath -ErrorAction SilentlyContinue
            Remove-Variable -Name Expression -ErrorAction SilentlyContinue
        } catch {
            Write-Error "Failed to configure Oh-My-Posh prompt: $_"
        }
    } else {
        Write-Warning "Oh-My-Posh is not installed. Skipping prompt customization."
    }
}

End {
    Write-Verbose "[END]: Profile.Prompt.ps1"
}

