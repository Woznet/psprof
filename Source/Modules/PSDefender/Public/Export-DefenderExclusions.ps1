# Function to export exclusions to a file
Function Export-DefenderExclusions {
    <#
    .SYNOPSIS
        Exports all Windows Defender exclusions to a JSON file.

    .DESCRIPTION
        Creates a JSON file containing all current Windows Defender exclusions for backup or deployment.

    .PARAMETER FilePath
        Path where the JSON file will be saved. If not specified, a default name with timestamp will be used.

    .EXAMPLE
        Export-DefenderExclusions -FilePath "C:\Temp\DefenderExclusions.json"

    .EXAMPLE
        Export-DefenderExclusions
        # Uses default filename: DefenderExclusions_yyyyMMdd_HHmmss.json

    .OUTPUTS
        None. Status messages are written to the host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$FilePath
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to view Defender exclusions."
        return
    }

    if ([string]::IsNullOrEmpty($FilePath)) {
        $FilePath = "DefenderExclusions_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
        Write-Host "No file path specified. Using default: $FilePath"
    }

    try {
        $exclusions = Get-DefenderExclusions
        $exclusions | ConvertTo-Json -Depth 5 | Out-File -FilePath $FilePath -Force
        Write-Host "Exclusions exported to: $FilePath" -ForegroundColor Green
    } catch {
        Write-Error "Failed to export exclusions: $_"
    }
}
