# Function to check if a specific exclusion exists
Function Test-DefenderExclusionExists {
    <#
    .SYNOPSIS
        Checks if a specific Windows Defender exclusion exists.

    .DESCRIPTION
        Determines whether a specific path, process, extension, or IP address exclusion is already configured in Windows Defender.

    .PARAMETER ExclusionType
        Type of exclusion: Path, Process, Extension, or IpAddress

    .PARAMETER Value
        The value to check

    .EXAMPLE
        Test-DefenderExclusionExists -ExclusionType Path -Value "C:\MyApp\Data"

    .OUTPUTS
        Boolean indicating whether the exclusion exists
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
        Write-Error "Administrative privileges required to view Defender exclusions."
        return $false
    }

    # Handle extension format
    if ($ExclusionType -eq "Extension" -and -not $Value.StartsWith(".")) {
        $Value = ".$Value"
    }

    $currentExclusions = Get-DefenderExclusionsByType -ExclusionType $ExclusionType

    if ($null -eq $currentExclusions) {
        return $false
    }

    return $currentExclusions -contains $Value
}
