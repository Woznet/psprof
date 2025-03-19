# Function to get all current exclusions
Function Get-DefenderExclusions {
    <#
    .SYNOPSIS
        Retrieves all current Windows Defender exclusions.

    .DESCRIPTION
        Gets all path, process, extension, and IP address exclusions currently configured in Windows Defender.

    .EXAMPLE
        $exclusions = Get-DefenderExclusions
        $exclusions.Paths | ForEach-Object { Write-Host $_ }

    .OUTPUTS
        PSCustomObject with Paths, Processes, Extensions, and IpAddresses properties
    #>
    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to view Defender exclusions."
        return $null
    }

    $exclusions = [PSCustomObject]@{
        Paths       = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
        Processes   = Get-MpPreference | Select-Object -ExpandProperty ExclusionProcess
        Extensions  = Get-MpPreference | Select-Object -ExpandProperty ExclusionExtension
        IpAddresses = Get-MpPreference | Select-Object -ExpandProperty ExclusionIpAddress
    }
    return $exclusions
}
