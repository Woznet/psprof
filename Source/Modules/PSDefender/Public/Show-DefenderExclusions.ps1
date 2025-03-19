# Function to display current exclusions
Function Show-DefenderExclusions {
    <#
    .SYNOPSIS
        Displays all current Windows Defender exclusions in a formatted output.

    .DESCRIPTION
        Formats and displays all current Windows Defender exclusions by type.

    .EXAMPLE
        Show-DefenderExclusions

    .OUTPUTS
        None. Information is written to the host.
    #>
    if (-not (Test-DefenderAdminRights)) {
        Write-Error "Administrative privileges required to view Defender exclusions."
        return
    }

    $exclusions = Get-DefenderExclusions

    Write-Host "`nCurrent Windows Defender Exclusions:" -ForegroundColor Cyan

    Write-Host "`nPath Exclusions:" -ForegroundColor Yellow
    if ($exclusions.Paths) {
        $exclusions.Paths | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "  No path exclusions defined."
    }

    Write-Host "`nProcess Exclusions:" -ForegroundColor Yellow
    if ($exclusions.Processes) {
        $exclusions.Processes | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "  No process exclusions defined."
    }

    Write-Host "`nExtension Exclusions:" -ForegroundColor Yellow
    if ($exclusions.Extensions) {
        $exclusions.Extensions | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "  No extension exclusions defined."
    }

    Write-Host "`nIP Address Exclusions:" -ForegroundColor Yellow
    if ($exclusions.IpAddresses) {
        $exclusions.IpAddresses | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "  No IP address exclusions defined."
    }
}
