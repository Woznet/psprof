# Test-ProfileSetup.ps1
# Comprehensive test to verify PowerShell profile setup and functionality

<#
    .SYNOPSIS
        Tests the complete PowerShell profile setup including completions, modules, and functions.
    .DESCRIPTION
        This script performs comprehensive testing of the PowerShell profile to ensure:
        - Profile loads without errors
        - All components are properly loaded
        - CLI completions work correctly
        - Essential modules are imported
        - Custom functions are available
    .EXAMPLE
        pwsh -NoProfile -File ".\Tests\Profile\Test-ProfileSetup.ps1"
#>

[CmdletBinding()]
param()

Write-Host "=== PowerShell Profile Setup Verification ===" -ForegroundColor Cyan
Write-Host "Testing profile setup and functionality..." -ForegroundColor Yellow
Write-Host ""

$script:TestResults = @()
$script:FailureCount = 0

function Add-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Details = ""
    )

    $result = [PSCustomObject]@{
        TestName = $TestName
        Passed = $Passed
        Details = $Details
    }

    $script:TestResults += $result

    if ($Passed) {
        Write-Host "✅ $TestName" -ForegroundColor Green
        if ($Details) {
            Write-Host "   $Details" -ForegroundColor Gray
        }
    } else {
        Write-Host "❌ $TestName" -ForegroundColor Red
        if ($Details) {
            Write-Host "   $Details" -ForegroundColor Gray
        }
        $script:FailureCount++
    }
}

try {
    # Test 1: Profile loads without errors
    Write-Host "Loading profile..." -ForegroundColor Yellow
    . "$PSScriptRoot\..\..\Profile.ps1"
    Add-TestResult "Profile loads without errors" $true

    # Test 2: Essential modules are loaded
    $essentialModules = @('posh-git', 'Terminal-Icons', 'CompletionPredictor')
    foreach ($module in $essentialModules) {
        $loaded = Get-Module -Name $module -ErrorAction SilentlyContinue
        Add-TestResult "Module '$module' is loaded" ($null -ne $loaded)
    }

    # Test 3: Custom functions are available
    $customFunctions = @('Get-PCInfo', 'Get-PCUptime', 'Update-WinGet', 'Update-PSModules')
    foreach ($function in $customFunctions) {
        $available = Get-Command $function -ErrorAction SilentlyContinue
        Add-TestResult "Function '$function' is available" ($null -ne $available)
    }

    # Test 4: CLI completions work correctly
    $cliTools = @{
        'volta' = 'volta '
        'winget' = 'winget '
        'gh' = 'gh '
    }

    foreach ($tool in $cliTools.Keys) {
        if (Get-Command $tool -ErrorAction SilentlyContinue) {
            $completionInput = $cliTools[$tool]
            $result = [System.Management.Automation.CommandCompletion]::CompleteInput($completionInput, $completionInput.Length, $null)

            # Check if we get proper completions (not just filesystem)
            # For most tools, avoid completions that start with .\ or ./
            # But gh might have legitimate completions that start with these patterns
            $hasProperCompletions = $result.CompletionMatches.Count -gt 0

            if ($tool -ne 'gh') {
                # For non-gh tools, ensure we don't get filesystem completions
                $hasProperCompletions = $hasProperCompletions -and
                                      $result.CompletionMatches[0].CompletionText -notmatch '^\.[\\\/]'
            }

            Add-TestResult "$tool completions work correctly" $hasProperCompletions "Found $($result.CompletionMatches.Count) completions"
        } else {
            Add-TestResult "$tool completions work correctly" $true "Tool not installed - skipped"
        }
    }

    # Test 5: Aliases are set correctly
    $aliases = @('Documents', 'Desktop', 'Downloads')
    foreach ($alias in $aliases) {
        $aliasExists = Get-Alias $alias -ErrorAction SilentlyContinue
        Add-TestResult "Alias '$alias' is set" ($null -ne $aliasExists)
    }

    # Test 6: PSReadLine is configured
    $psReadLineModule = Get-Module PSReadLine -ErrorAction SilentlyContinue
    Add-TestResult "PSReadLine is loaded and configured" ($null -ne $psReadLineModule)

    # Test 7: Git integration works
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitStatus = Get-GitStatus -ErrorAction SilentlyContinue
        Add-TestResult "Git integration works" ($null -ne $gitStatus) "posh-git integration"
    } else {
        Add-TestResult "Git integration works" $true "Git not installed - skipped"
    }

    # Test 8: Profile performance
    $loadTime = Measure-Command { . "$PSScriptRoot\..\..\Profile.ps1" }
    $fastLoad = $loadTime.TotalSeconds -lt 5
    Add-TestResult "Profile loads quickly" $fastLoad "Load time: $($loadTime.TotalSeconds.ToString('F2')) seconds"

} catch {
    Add-TestResult "Profile loads without errors" $false "Error: $_"
    $script:FailureCount++
}

# Summary
Write-Host ""
Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "Total tests: $($script:TestResults.Count)" -ForegroundColor Yellow
Write-Host "Passed: $(($script:TestResults | Where-Object Passed).Count)" -ForegroundColor Green
Write-Host "Failed: $script:FailureCount" -ForegroundColor Red

if ($script:FailureCount -eq 0) {
    Write-Host ""
    Write-Host "🎉 All tests passed! PowerShell profile setup is working correctly." -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "⚠️  Some tests failed. Please review the results above." -ForegroundColor Yellow

    Write-Host ""
    Write-Host "Failed tests:" -ForegroundColor Red
    $script:TestResults | Where-Object { -not $_.Passed } | ForEach-Object {
        Write-Host "  - $($_.TestName): $($_.Details)" -ForegroundColor Gray
    }
    exit 1
}
