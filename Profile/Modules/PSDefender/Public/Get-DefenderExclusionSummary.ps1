# Function to get a summarized report of exclusions
Function Get-DefenderExclusionsSummary {
    <#
    .SYNOPSIS
        Provides a summary of Windows Defender exclusions.

    .DESCRIPTION
        Returns a summary object with counts and lists of all Windows Defender exclusions.

    .EXAMPLE
        $summary = Get-DefenderExclusionsSummary
        Write-Host "Total exclusions: $($summary.TotalCount)"

    .OUTPUTS
        PSCustomObject with summary information
    #>

    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to view Defender exclusions."
        return $null
    }

    $exclusions = Get-DefenderExclusions

    $pathCount = if ($null -eq $exclusions.Paths) { 0 } else { $exclusions.Paths.Count }
    $processCount = if ($null -eq $exclusions.Processes) { 0 } else { $exclusions.Processes.Count }
    $extensionCount = if ($null -eq $exclusions.Extensions) { 0 } else { $exclusions.Extensions.Count }
    $ipCount = if ($null -eq $exclusions.IpAddresses) { 0 } else { $exclusions.IpAddresses.Count }

    $totalCount = $pathCount + $processCount + $extensionCount + $ipCount

    $summary = [PSCustomObject]@{
        TotalCount     = $totalCount
        PathCount      = $pathCount
        ProcessCount   = $processCount
        ExtensionCount = $extensionCount
        IpAddressCount = $ipCount
        Paths          = $exclusions.Paths
        Processes      = $exclusions.Processes
        Extensions     = $exclusions.Extensions
        IpAddresses    = $exclusions.IpAddresses
    }

    return $summary
}
