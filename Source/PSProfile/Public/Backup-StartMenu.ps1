Function Backup-StartMenu {
    <#
    .SYNOPSIS
        Backs up the start menu 'start2.bin' file to a specified location.
    .DESCRIPTION
        The 'start2.bin' file is used by the Windows Start Menu Experience Host
        to store the layout of the start menu. This function backs up the file to
        a specified location.
    .PARAMETER Destination
        The destination directory to back up the 'start2.bin' file to.
    .PARAMETER Force
        Overwrite the backup if it already exists.
    .EXAMPLE
        Backup-StartMenu -Destination 'C:\Backups'
    .EXAMPLE
        Backup-StartMenu -Destination 'C:\Backups' -Force
    .NOTES
        For more details on the start menu 'start2.bin' file, see:
        https://www.tenforums.com/tutorials/106855-backup-restore-start-layout-windows-10-a.html
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [String]$Destination,

        [Switch]$Force
    )

    Begin {
        $Source = "$Env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_*\LocalState\start2.bin"
        $Dest = Join-Path -Path $Destination -ChildPath 'StartMenu' -AdditionalChildPath 'start2.bin'
    }

    Process {
        if ((Test-Path -Path $Dest) -and (-not($Force))) {
            Write-Warning "Backup already exists at $Dest. Use -Force to overwrite."
            return
        }

        Copy-Item -Path $Source -Destination $Dest -Force
    }

    End {
        Write-Host "Start menu 'start2.bin' backed up to $Dest." -ForegroundColor Green
    }
}
