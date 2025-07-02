# ----------------------------------------------------------------------------
# Volta CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        Volta CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers Volta CLI shell completions for PowerShell.
        It runs the `volta completions powershell` command to set up the necessary completions.
    .LINK
        https://docs.volta.sh/guide/completions
#>

# Volta CLI autocompletion - follows same pattern as other CLI tools
if (Get-Command volta -ErrorAction SilentlyContinue) {
    try {
        Invoke-Expression -Command $(volta completions powershell | Out-String)
        Write-Verbose 'Volta shell completion registered successfully.'
    } catch {
        Write-Warning "Failed to register Volta shell completion: $_"
    }
}
