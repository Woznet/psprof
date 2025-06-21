# Test-ProfileOptimization.ps1
# Script to test the PowerShell profile optimization

[CmdletBinding()]
param(
    [switch]$RunAllTests
)

# Import Pester if available
if (Get-Module -ListAvailable -Name Pester) {
    Import-Module Pester
} else {
    Write-Warning "Pester module not found. Some tests may not run properly."
}

# Define paths
$ProfileRoot = Split-Path -Path $PROFILE -Parent
$MainProfilePath = Join-Path -Path $ProfileRoot -ChildPath "Profile.ps1"
$VSCodeProfilePath = Join-Path -Path $ProfileRoot -ChildPath "Microsoft.VSCode_profile.ps1"

# Define tests
Describe "PowerShell Profile Optimization Tests" {
    Context "File Structure" {
        It "Main profile exists" {
            Test-Path -Path $MainProfilePath | Should -Be $true
        }

        It "VSCode profile exists" {
            Test-Path -Path $VSCodeProfilePath | Should -Be $true
        }
    }

    Context "Profile Content" {
        It "Main profile has environment detection" {
            $mainProfileContent = Get-Content -Path $MainProfilePath -Raw
            $mainProfileContent | Should -Match "isVSCode"
            $mainProfileContent | Should -Match "isRegularPowerShell"
        }

        It "VSCode profile sets environment variable" {
            $vscodeProfileContent = Get-Content -Path $VSCodeProfilePath -Raw
            $vscodeProfileContent | Should -Match "TERM_PROGRAM = 'vscode'"
        }
    }

    Context "Environment Detection" {
        It "Detects current environment" {
            # Source the profile to get environment variables
            . $MainProfilePath

            # At least one environment should be true
            ($isVSCode -or $isRegularPowerShell -or $isISE) | Should -Be $true
        }
    }

    Context "Performance" {
        It "ModuleFast cache exists after profile load" {
            . $MainProfilePath
            $moduleFastCache = Join-Path -Path $env:TEMP -ChildPath "modulefast_cache.ps1"
            Test-Path -Path $moduleFastCache | Should -Be $true
        }
    }
}

# Run manual tests if requested
if ($RunAllTests) {
    Write-Host "Running manual tests..." -ForegroundColor Cyan

    # Test in current environment
    Write-Host "`nTesting in current environment:" -ForegroundColor Yellow
    . $MainProfilePath -Measure

    # Show environment detection
    Write-Host "`nEnvironment Detection:" -ForegroundColor Yellow
    Write-Host "VSCode: $isVSCode"
    Write-Host "Regular PowerShell: $isRegularPowerShell"
    Write-Host "ISE: $isISE"
}

# Show instructions
Write-Host "`nTo run all tests including manual profile loading:" -ForegroundColor Cyan
Write-Host "   ./Test-ProfileOptimization.ps1 -RunAllTests" -ForegroundColor Green

Write-Host "`nTo test in different environments:" -ForegroundColor Cyan
Write-Host "1. Regular PowerShell: Open a new PowerShell window and run:"
Write-Host "   . `$PROFILE -Measure" -ForegroundColor Green
Write-Host "2. VSCode: Open a new VSCode terminal and run:"
Write-Host "   . `$PROFILE -Measure" -ForegroundColor Green

Write-Host "`nTo verify environment detection, run in both environments:"
Write-Host "   Write-Host `"Environment: VSCode=`$isVSCode, RegularPS=`$isRegularPowerShell`"" -ForegroundColor Green
