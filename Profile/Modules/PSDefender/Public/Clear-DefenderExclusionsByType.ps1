# Function to clear all exclusions of a specific type
Function Clear-DefenderExclusionsByType {
    <#
    .SYNOPSIS
        Removes all Windows Defender exclusions of a specific type.

    .DESCRIPTION
        Clears all path, process, extension, or IP address exclusions from Windows Defender.

    .PARAMETER ExclusionType
        Type of exclusion to clear: Path, Process, Extension, or IpAddress

    .EXAMPLE
        Clear-DefenderExclusionsByType -ExclusionType Path

    .OUTPUTS
        None. Status messages are written to the host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Path", "Process", "Extension", "IpAddress")]
        [string]$ExclusionType
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to modify Defender exclusions."
        return
    }

    $currentExclusions = Get-DefenderExclusionsByType -ExclusionType $ExclusionType

    if ($null -eq $currentExclusions -or $currentExclusions.Count -eq 0) {
        Write-Host "No $ExclusionType exclusions to clear." -ForegroundColor Yellow
        return
    }

    foreach ($exclusion in $currentExclusions) {
        Remove-DefenderExclusion -ExclusionType $ExclusionType -Value $exclusion
    }

    Write-Host "All $ExclusionType exclusions have been cleared." -ForegroundColor Green
}
