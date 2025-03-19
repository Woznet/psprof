<#
   .SYNOPSIS
       1Password CLI (op) PowerShell Tab Completion.
#>

If (Get-Command op -ErrorAction SilentlyContinue) {
  op completion powershell | Out-String | Invoke-Expression
}

