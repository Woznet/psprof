Function Export-FirewallRules {
    <#
    .SYNOPSIS
        Backs up Windows Firewall rules to a specified location.
    .DESCRIPTION
        Windows Firewall allows you to create rules that specify how the firewall
        should handle inbound and outbound traffic. This function backs up the
        current list of rules to a specified location.
    .PARAMETER Destination
        The destination directory to back up the firewall rules to.
    .EXAMPLE
        Backup-FirewallRules -Destination 'C:\Backups'
    .NOTES
        This function wraps the `netsh advfirewall export` command. The rules are exported to a file with the extension `.wfw`.
    .LINK
        Import-FirewallRules
    #>
    #Requires -RunAsAdministrator
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [String]$Destination
    )

    Begin {
        $OutFile = Join-Path -Path $Destination -ChildPath 'FirewallRules.wfw'
    }

    Process {
        Write-Verbose "Exporting firewall rules to $OutFile"
        # Export the firewall rules to a file in the specified destination
        $Cmd = "netsh advfirewall export `"$OutFile`""
        Invoke-Expression -Command $Cmd
    }

    End {
        Write-Host "Firewall rules backed up to $OutFile." -ForegroundColor Green
    }

}
