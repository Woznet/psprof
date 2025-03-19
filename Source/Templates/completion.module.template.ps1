# ----------------------------------------------------------------------------
# `{{name}}` CLI Shell Completion for PowerShell
# ----------------------------------------------------------------------------

<#
    .SYNOPSIS
        `{{name}}` CLI Shell Completion for PowerShell
    .DESCRIPTION
        This script registers `{{name}}` CLI shell completions for PowerShell using the
        module {{module}}
    .LINK
        {{url}}
#>

Begin {

    Write-Verbose "[BEGIN]: {{name}} completion"

    $has = Get-InstalledPSResource -Name {{module}} -ErrorAction SilentlyContinue

    if (-not $has) {
        Write-Error "Module `{{module}}` not found for {{name}} shell completion. Please install and try again."
    }

}

Process {

    Write-Verbose "[PROCESS]: {{name}} completion"

    try {
        Write-Information "Importing Module: {{module}}"
        Import-Module {{module}}
    } catch {
        Write-Error "Failed to import {{module}}."
    }

}

End {

    Write-Verbose "[END]: {{name}} completion"

}
