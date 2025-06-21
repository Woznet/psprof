<#
  .SYNOPSIS
    bat CLI Completion Script
#>
If (Get-Command bat -ErrorAction SilentlyContinue) {
    Invoke-Expression -Command $(bat --completion ps1 | Out-String)
}
