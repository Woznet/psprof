# Function to import exclusions from a file
Function Import-DefenderExclusions {
    <#
    .SYNOPSIS
        Imports Windows Defender exclusions from a JSON file.

    .DESCRIPTION
        Adds all exclusions from a previously exported JSON file to the current Windows Defender configuration.

    .PARAMETER FilePath
        Path to the JSON file containing the exclusions

    .EXAMPLE
        Import-DefenderExclusions -FilePath "C:\Temp\DefenderExclusions.json"

    .OUTPUTS
        None. Status messages are written to the host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to modify Defender exclusions."
        return
    }

    if ([string]::IsNullOrEmpty($FilePath) -or -not (Test-Path $FilePath)) {
        Write-Error "Invalid or missing file path: $FilePath"
        return
    }

    try {
        $exclusions = Get-Content -Path $FilePath -Raw | ConvertFrom-Json

        # Add Path exclusions
        if ($exclusions.Paths) {
            $exclusions.Paths | ForEach-Object {
                Add-MpPreference -ExclusionPath $_
                Write-Host "Added path exclusion: $_" -ForegroundColor Green
            }
        }

        # Add Process exclusions
        if ($exclusions.Processes) {
            $exclusions.Processes | ForEach-Object {
                Add-MpPreference -ExclusionProcess $_
                Write-Host "Added process exclusion: $_" -ForegroundColor Green
            }
        }

        # Add Extension exclusions
        if ($exclusions.Extensions) {
            $exclusions.Extensions | ForEach-Object {
                Add-MpPreference -ExclusionExtension $_
                Write-Host "Added extension exclusion: $_" -ForegroundColor Green
            }
        }

        # Add IP Address exclusions
        if ($exclusions.IpAddresses) {
            $exclusions.IpAddresses | ForEach-Object {
                Add-MpPreference -ExclusionIpAddress $_
                Write-Host "Added IP address exclusion: $_" -ForegroundColor Green
            }
        }

        Write-Host "All exclusions imported successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to import exclusions: $_"
    }
}
