# ----------------------------------------------------------------------------
# `{{name}}` CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        `{{name}}` CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers `{{name}}` CLI shell completions for PowerShell.
    .LINK
        {{url}}
#>

Begin {

    Write-Verbose "[BEGIN]: {{name}} completion"

    $has = Get-Command {{$cmd}} -ErrorAction SilentlyContinue

    if (-not $has) {
        Write-Error "`{{name}}` not found or is not installed. Please install and try again."
    }

    $cmd = "{{completionCmd}}"

}

Process {

    Write-Verbose "[PROCESS]: {{name}} completion"

    try {
        Write-Information "Running command: $cmd"
        Invoke-Expression -Command $($cmd | Out-String)
    } catch {
        Write-Error "Failed to register {{name}} shell completion for powershell."
    }

}

End {

    Write-Verbose "[END]: {{name}} completion"

}
