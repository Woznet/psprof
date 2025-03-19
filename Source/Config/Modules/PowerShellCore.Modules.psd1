<#
    .SYNOPSIS
        PowerShell (Core) Modules Data Configuration File - System Core Modules
    .DESCRIPTION
        These modules are considered core modules that are used to manage and maintain the system environment.
        By default they are located in the system level module path and are available to all users:
        `$env:ProgramFiles\PowerShell\Modules` or `$env:ProgramFiles\PowerShell\7\Modules`.
    .NOTES
        File Name      : PowerShellCore.Modules.psd1
        Author         : Jimmy Briggs
        Prerequisites  : PowerShell Core Version 7+ and the Microsoft.PowerShell.PSResourceGet Module
#>

@{
    'CimCmdlets'                         = @{}
    'Microsoft.PowerShell.Archive'       = @{}
    'Microsoft.PowerShell.Diagnostics'   = @{}
    'Microsoft.PowerShell.Host'          = @{}
    'Microsoft.PowerShell.Management'    = @{}
    'Microsoft.PowerShell.PSResourceGet' = @{}
    'Microsoft.PowerShell.Security'      = @{}
    'Microsoft.PowerShell.Utility'       = @{}
    'Microsoft.WSMan.Management'         = @{}
    'PackageManagement'                  = @{}
    'PowerShellGet'                      = @{}
    'PSDiagnostics'                      = @{}
    'PSReadLine'                         = @{}
    'ThreadJob'                          = @{}
}
