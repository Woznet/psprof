# ----------------------------------------------------------------------------
# GitHub CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        GitHub CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers GitHub CLI shell completions for PowerShell.
        It runs the `gh completion --shell powershell` command to set up the necessary completions.
    .LINK
        https://cli.github.com/manual/gh_completion
#>

# GitHub CLI autocompletion
if (Get-Command gh -ErrorAction SilentlyContinue) {
    try {
        Invoke-Expression -Command $(gh completion --shell powershell | Out-String)
        Write-Verbose 'GitHub CLI shell completion registered successfully.'
    } catch {
        Write-Warning "Failed to register GitHub CLI shell completion: $_"
    }
}
