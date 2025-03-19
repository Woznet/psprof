# Function to get exclusions of a specific type
Function Get-DefenderExclusionsByType {
    <#
    .SYNOPSIS
        Gets Windows Defender exclusions of a specific type.

    .DESCRIPTION
        Retrieves all exclusions of the specified type (Path, Process, Extension, or IpAddress).

    .PARAMETER ExclusionType
        Type of exclusion to retrieve: Path, Process, Extension, or IpAddress

    .EXAMPLE
        Get-DefenderExclusionsByType -ExclusionType Path

    .OUTPUTS
        Array of exclusion values or null if none exist
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Path", "Process", "Extension", "IpAddress")]
        [string]$ExclusionType
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to view Defender exclusions."
        return $null
    }

    $exclusions = Get-DefenderExclusions

    switch ($ExclusionType) {
        "Path" { return $exclusions.Paths }
        "Process" { return $exclusions.Processes }
        "Extension" { return $exclusions.Extensions }
        "IpAddress" { return $exclusions.IpAddresses }
    }
}
