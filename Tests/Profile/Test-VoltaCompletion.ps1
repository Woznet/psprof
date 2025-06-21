#!/usr/bin/env pwsh

# Test script for volta completion
Write-Host "Loading profile..." -ForegroundColor Blue
. "$PSScriptRoot\Profile.ps1"

Write-Host "Profile loaded. Testing volta completion..." -ForegroundColor Green

# Test volta completion
$result = [System.Management.Automation.CommandCompletion]::CompleteInput('volta ', 6, $null)
Write-Host "Completion result count: $($result.CompletionMatches.Count)" -ForegroundColor Yellow

if ($result.CompletionMatches.Count -gt 0) {
    Write-Host "First 5 completions:" -ForegroundColor Cyan
    $result.CompletionMatches | Select-Object -First 5 CompletionText | Format-Table -AutoSize

    # Check if we got volta-specific completions (not filesystem)
    $voltaSpecific = $result.CompletionMatches | Where-Object { $_.CompletionText -in @('install', 'list', 'pin', 'fetch', 'uninstall') }
    if ($voltaSpecific) {
        Write-Host "SUCCESS: Got volta-specific completions!" -ForegroundColor Green
    } else {
        Write-Host "WARNING: Got completions but they appear to be filesystem completions" -ForegroundColor Yellow
    }
} else {
    Write-Host "No completions found" -ForegroundColor Red
}
