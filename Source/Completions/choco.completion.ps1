# ----------------------------------------------------------------------------
# Chocolatey Completion
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        Chocolatey CLI PowerShell Tab Completion.
    .DESCRIPTION
        This script registers Chocolatey CLI shell completions for PowerShell.
    .LINK
        https://chocolatey.org/
#>

Begin {

    Write-Verbose "[BEGIN]: Chocolatey Completion"

    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Error "Chocolatey command `choco` not found or is not installed. Please install and try again."
    }

    if ($null -eq $Env:ChocolateyInstall) {
        Write-Error "Chocolatey Environment Variable `ChocolateyInstall` not found. Please install and try again."
    }

    $ChocolateyProfile = "$Env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

    if (!(Test-Path($ChocolateyProfile))) {
        Write-Error "Chocolatey Profile not found: $ChocolateyProfile. Please install and try again."
    }

    $Cmd = "Import-Module '$ChocolateyProfile'"

}

Process {

    Write-Verbose "[PROCESS]: Chocolatey Completion"

    try {
        Write-Information "Running Command: $Cmd"
        Invoke-Expression -Command $($Cmd | Out-String)
    } catch {
        Write-Error "Failed to register Chocolatey shell completion for powershell."
    }

}

End {
    Write-Verbose "[END]: Chocolatey Completion"
}
