Function Import-FirewallRules {
    <#
    .SYNOPSIS
        Imports Windows Firewall rules from a specified location.
    .DESCRIPTION
        Windows Firewall allows you to create rules that specify how the firewall
        should handle inbound and outbound traffic. This function imports the
        rules from a specified location.
    .PARAMETER Path
        The source directory to import the firewall rules from.
    .EXAMPLE
        Import-FirewallRules -Path "C:\Backups\FirewallRules.wfw"
    .NOTES
        This function wraps the `netsh advfirewall import` command. The rules are imported from a file with the extension `.wfw`.
    .LINK
        Export-FirewallRules
    #>
    #Requires -RunAsAdministrator
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [ValidatePattern('.wfw$')]
        [String]$Path
    )

    Begin {
        $InFile = $Path
    }

    Process {
        Write-Verbose "Importing firewall rules from $InFile"
        # Import the firewall rules from a file in the specified source
        $Cmd = "netsh advfirewall import `"$InFile`""
        Invoke-Expression -Command $Cmd
    }

    End {
        Write-Host "Firewall rules imported from $InFile." -ForegroundColor Green
    }
}
