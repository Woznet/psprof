# ---------------------------------------------------------------------
# PowerShell Profile - Prompt
# ---------------------------------------------------------------------

# Oh-My-Posh Prompt
# https://ohmyposh.dev/docs/installation
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ohMyPoshConfigPath = Join-Path "$Env:POSH_THEMES_PATH" 'wopian.omp.json'
    if (Test-Path -Path $ohMyPoshConfigPath) {
        try {
            $Expression = (& oh-my-posh init pwsh --config=$ohMyPoshConfigPath --print) -join "`n"
            $Expression | Invoke-Expression
        } catch {
            Write-Error "Failed to configure Oh-My-Posh prompt: $_"
        }
    } else {
        Write-Error "Oh-My-Posh configuration path is not valid: $ohMyPoshConfigPath"
    }
    Remove-Variable -Name ohMyPoshConfigPath -ErrorAction SilentlyContinue
    Remove-Variable -Name Expression -ErrorAction SilentlyContinue
}
