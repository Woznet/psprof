Function Backup-DefenderExclusions {
    <#
    .SYNOPSIS
        Backs up Windows Defender exclusions to a specified location.
    .DESCRIPTION
        Windows Defender allows you to exclude files, folders, file types, and
        processes from being scanned. This function backs up the current list of
        exclusions to a specified location.
    .PARAMETER Destination
        The destination directory to back up the exclusions to.
    .PARAMETER Force
        Overwrite the backup if it already exists.
    .EXAMPLE
        Backup-DefenderExclusions -Destination 'C:\Backups' -Force
    .NOTES
        This function wraps the `Get-MpPreference` cmdlet and writes the output as TXT to a file.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [String]$Destination,

        [Switch]$Force
    )

    Begin {
        $Dest = Join-Path -Path $Destination -ChildPath 'DefenderExclusions.txt'
        $Cmd = "sudo PowerShell.exe -ExecutionPolicy Bypass -Command `"Get-MpPreference | Select-Object -Property ExclusionPath -ExpandProperty ExclusionPath`" > `"$Dest`""
    }

    Process {
        if ((Test-Path -Path $Dest) -and (-not($Force))) {
            Write-Warning "Backup already exists at $Dest. Use -Force to overwrite."
            return
        }

        Invoke-Expression -Command $Cmd
    }

    End {
        Write-Host "Windows Defender exclusions backed up to $Dest." -ForegroundColor Green
    }
}
