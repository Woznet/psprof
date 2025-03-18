# Function to remove an exclusion
Function Remove-DefenderExclusion {
    <#
    .SYNOPSIS
        Removes an exclusion from Windows Defender.

    .DESCRIPTION
        Removes a path, process, extension, or IP address exclusion from Windows Defender.

    .PARAMETER ExclusionType
        Type of exclusion: Path, Process, Extension, or IpAddress

    .PARAMETER Value
        The value to remove from exclusions

    .EXAMPLE
        Remove-DefenderExclusion -ExclusionType Path -Value "C:\MyApp\Data"

    .EXAMPLE
        Remove-DefenderExclusion -ExclusionType Process -Value "MyApp.exe"

    .OUTPUTS
        None. Status messages are written to the host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Path", "Process", "Extension", "IpAddress")]
        [string]$ExclusionType,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to modify Defender exclusions."
        return
    }

    if ([string]::IsNullOrEmpty($Value)) {
        Write-Error "No value specified for removal."
        return
    }

    try {
        switch ($ExclusionType) {
            "Path" {
                Remove-MpPreference -ExclusionPath $Value
                Write-Host "Removed path exclusion: $Value" -ForegroundColor Green
            }
            "Process" {
                Remove-MpPreference -ExclusionProcess $Value
                Write-Host "Removed process exclusion: $Value" -ForegroundColor Green
            }
            "Extension" {
                if (-not $Value.StartsWith(".")) {
                    $Value = ".$Value"
                }
                Remove-MpPreference -ExclusionExtension $Value
                Write-Host "Removed extension exclusion: $Value" -ForegroundColor Green
            }
            "IpAddress" {
                Remove-MpPreference -ExclusionIpAddress $Value
                Write-Host "Removed IP address exclusion: $Value" -ForegroundColor Green
            }
        }
    } catch {
        Write-Error "Failed to remove exclusion: $_"
    }
}

