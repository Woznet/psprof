# Check for admin rights
Function Test-DefenderAdminRights {
    <#
    .SYNOPSIS
        Checks if the current PowerShell session has administrative privileges.

    .DESCRIPTION
        Verifies whether the current user has sufficient rights to modify Windows Defender settings.

    .EXAMPLE
        if (-not (Test-DefenderAdminRights)) {
            Write-Error "This script requires administrative privileges."
            return
        }

    .OUTPUTS
        Boolean indicating whether the current session has admin rights
    #>
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
