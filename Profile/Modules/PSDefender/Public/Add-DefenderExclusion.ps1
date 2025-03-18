# Function to add an exclusion
Function Add-DefenderExclusion {
    <#
    .SYNOPSIS
        Adds a new exclusion to Windows Defender.

    .DESCRIPTION
        Adds a path, process, extension, or IP address exclusion to Windows Defender.

    .PARAMETER ExclusionType
        Type of exclusion: Path, Process, Extension, or IpAddress

    .PARAMETER Value
        The value to add as an exclusion

    .EXAMPLE
        Add-DefenderExclusion -ExclusionType Path -Value "C:\MyApp\Data"

    .EXAMPLE
        Add-DefenderExclusion -ExclusionType Process -Value "MyApp.exe"

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
        Write-Error "No value specified for the exclusion."
        return
    }

    try {
        switch ($ExclusionType) {
            "Path" {
                Add-MpPreference -ExclusionPath $Value
                Write-Host "Added path exclusion: $Value" -ForegroundColor Green
            }
            "Process" {
                Add-MpPreference -ExclusionProcess $Value
                Write-Host "Added process exclusion: $Value" -ForegroundColor Green
            }
            "Extension" {
                if (-not $Value.StartsWith(".")) {
                    $Value = ".$Value"
                }
                Add-MpPreference -ExclusionExtension $Value
                Write-Host "Added extension exclusion: $Value" -ForegroundColor Green
            }
            "IpAddress" {
                Add-MpPreference -ExclusionIpAddress $Value
                Write-Host "Added IP address exclusion: $Value" -ForegroundColor Green
            }
        }
    } catch {
        Write-Error "Failed to add exclusion: $_"
    }
}
