# ----------------------------------------------------------------------------
# `docker` CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        `docker` CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers `docker` CLI shell completions for PowerShell using the
        module DockerCompletion
    .LINK
        https://github.com/matt9ucci/DockerCompletion
#>

Begin {

    Write-Verbose "[BEGIN]: docker completion"

    $has = Get-InstalledPSResource -Name DockerCompletion -ErrorAction SilentlyContinue

    if (-not $has) {
        Write-Error "Module `DockerCompletion` not found for docker shell completion. Please install and try again."
    } else {
        Write-Information "Module `DockerCompletion` found."
    }

}

Process {

    Write-Verbose "[PROCESS]: docker completion"

    try {
        Write-Information "Importing Module: DockerCompletion"
        Import-Module DockerCompletion -ErrorAction Stop
    } catch {
        Write-Error "Failed to import DockerCompletion module."
    }

}

End {

    Write-Verbose "[END]: docker completion"

}
