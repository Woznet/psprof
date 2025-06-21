#Requires -Module Pester

<#
    .SYNOPSIS
        Pester Tests
#>

$PesterConfig = New-PesterConfiguration
$PesterConfig.TestResult.OutputFormat = "NUnitXml"
$PesterConfig.TestResult.OutputPath = "$PSScriptRoot\Results.xml"
$PesterConfig.TestResult.Enabled = $True

Invoke-Pester -Configuration $PesterConfig

# Copy the results to the ReportUnit folder
Copy-Item -Path "$PSScriptRoot\Results.xml" -Destination "$PSScriptRoot\..\Tools\ReportUnit\Results.xml" -Force
Write-Host "Results.xml copied to ReportUnit folder"

# Generate ReportUnit HTML Report
$ResultsPath = "$PSScriptRoot\results.xml"
$ReportPath = "$PSScriptRoot\report.html"

$ReportUnitExe = "$PSScriptRoot\..\Tools\ReportUnit\ReportUnit.exe"
if (Test-Path $ReportUnitExe) {
    Write-Host "Generating HTML report..."
    & $ReportUnitExe "$ResultsPath" "$ReportPath"
} else {
    Write-Warning "ReportUnit.exe not found at $ReportUnitExe"
}

# Open the HTML report
if (Test-Path $ReportPath) {
    Write-Host "Opening HTML report..."
    Start-Process $ReportPath
} else {
    Write-Warning "HTML report not found at $ReportPath"
}
