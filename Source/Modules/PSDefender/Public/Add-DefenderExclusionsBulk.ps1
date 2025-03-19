# Function to add multiple exclusions of the same type
Function Add-DefenderExclusionsBulk {
    <#
    .SYNOPSIS
        Adds multiple Windows Defender exclusions of the same type.

    .DESCRIPTION
        Adds multiple path, process, extension, or IP address exclusions to Windows Defender in a single operation.

    .PARAMETER ExclusionType
        Type of exclusion: Path, Process, Extension, or IpAddress

    .PARAMETER Values
        Array of values to add as exclusions

    .EXAMPLE
        Add-DefenderExclusionsBulk -ExclusionType Path -Values @("C:\MyApp\Data", "C:\MyApp\Logs")

    .OUTPUTS
        None. Status messages are written to the host.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Path", "Process", "Extension", "IpAddress")]
        [string]$ExclusionType,

        [Parameter(Mandatory = $true)]
        [string[]]$Values
    )

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to modify Defender exclusions."
        return
    }

    foreach ($value in $Values) {
        Add-DefenderExclusion -ExclusionType $ExclusionType -Value $value
    }
}
