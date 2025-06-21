# Test script to validate VSCode/VSCode Insiders profile detection

Write-Host "Testing VSCode Profile Detection" -ForegroundColor Green

# Test with regular VSCode environment
Write-Host "`nTesting Regular VSCode Detection:" -ForegroundColor Yellow
$env:TERM_PROGRAM = 'vscode'
$Host.Name = 'Visual Studio Code Host'

# Source the VSCode profile to test detection
. "$PSScriptRoot\Microsoft.VSCode_profile.ps1"

Write-Host "  TERM_PROGRAM: $env:TERM_PROGRAM"
Write-Host "  VSCODE_EDITION: $env:VSCODE_EDITION"
Write-Host "  isVSCode: $Global:isVSCode"
Write-Host "  isVSCodeInsiders: $Global:isVSCodeInsiders"
Write-Host "  isRegularVSCode: $Global:isRegularVSCode"

# Test with VSCode Insiders environment
Write-Host "`nTesting VSCode Insiders Detection:" -ForegroundColor Yellow
$env:TERM_PROGRAM = 'vscode-insiders'
$Host.Name = 'Visual Studio Code Insiders Host'

# Clear previous variables
Remove-Variable -Name isVSCode -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name isVSCodeInsiders -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name isRegularVSCode -Scope Global -ErrorAction SilentlyContinue

# Source the VSCode profile to test detection
. "$PSScriptRoot\Microsoft.VSCode_profile.ps1"

Write-Host "  TERM_PROGRAM: $env:TERM_PROGRAM"
Write-Host "  VSCODE_EDITION: $env:VSCODE_EDITION"
Write-Host "  isVSCode: $Global:isVSCode"
Write-Host "  isVSCodeInsiders: $Global:isVSCodeInsiders"
Write-Host "  isRegularVSCode: $Global:isRegularVSCode"

Write-Host "`nProfile detection test completed!" -ForegroundColor Green
