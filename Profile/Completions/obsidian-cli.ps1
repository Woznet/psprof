# ----------------------------------------------------------------------------
# `obsidian-cli` (`obs`) CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        `obsidian-cli` (`obs`) CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers `obsidian-cli` (`obs`) CLI shell completions for PowerShell.
    .LINK
        https://github.com/Yakitrak/obsidian-cli
#>

Begin {

    Write-Verbose "[BEGIN]: obsidian-cli completion"

    $clis = @("obs", "obsidian-cli")
    $hasObs = if ($clis | ForEach-Object { Get-Command $_ -ErrorAction SilentlyContinue }) { $true } else { $false }

    if (-not $hasObs) {
        Write-Error "`obsidian-cli` (`obs`) not found or is not installed. Please install via scoop."
    }

}

Process {

    Write-Verbose "[PROCESS]: obsidian-cli completion"

    try {
        Write-Information "Running command: 'obs completion powershell'"
        Invoke-Expression -Command $(obs completion powershell | Out-String)
    } catch {
        Write-Error "Failed to register obsidan-cli shell completion for powershell."
    }

}

End {

    Write-Verbose "[END]: obsidian-cli completion"

}
