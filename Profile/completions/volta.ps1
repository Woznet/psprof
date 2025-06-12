# ----------------------------------------------------------------------------
# Volta CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        Volta CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers Volta CLI shell completions for PowerShell.
        It runs the `volta completions powershell` command to set up the necessary completions.
        This script is designed to run immediately, not lazily, because volta generates
        a direct Register-ArgumentCompleter call that doesn't fit the lazy loading pattern.
    .LINK
        https://docs.volta.sh/guide/completions
#>

# Check if volta command is available and register completion immediately
if (Get-Command volta -ErrorAction SilentlyContinue) {
    try {
        Write-Verbose "Registering Volta shell completion for powershell..."
        volta completions powershell | Invoke-Expression
        Write-Verbose 'Volta shell completion registered successfully for powershell.'
    } catch {
        Write-Warning "Failed to register Volta shell completion for powershell: $_"
    }
} else {
    Write-Verbose "Volta command not found. Skipping volta completion registration."
}
