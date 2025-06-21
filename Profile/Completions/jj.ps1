# ----------------------------------------------------------------------------
# Jujitsu (JJ) Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        Jujitsu (JJ) Shell Completion for PowerShell
    .DESCRIPTION
        This script registers Jujitsu (JJ) shell completions for PowerShell.
        It runs the `jj util completion power-shell` command to set up the necessary completions.
    .LINK
        https://www.jujitsu.com/docs/cli/completion
#>

if (Get-Command jj -ErrorAction SilentlyContinue) {
    try {
        Invoke-Expression (& { (jj util completion power-shell | Out-String) })
        Write-Verbose 'Jujitsu (JJ) shell completion registered successfully.'
    } catch {
        Write-Warning "Failed to register `jj` shell completion: $_"
    }
}
