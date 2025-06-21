# Test-ProfileEnvironments.ps1
# Script to test the optimized profile in different environments

[CmdletBinding()]
param()

Write-Host "PowerShell Profile Environment Testing" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Test in regular PowerShell
Write-Host "`nTesting in Regular PowerShell:" -ForegroundColor Yellow
Write-Host "1. Open a new PowerShell window (not in VSCode)"
Write-Host "2. Run the following command to test with timing information:"
Write-Host "   . `$PROFILE -Measure" -ForegroundColor Green
Write-Host "3. Verify that oh-my-posh prompt is loaded correctly"
Write-Host "4. Verify that all modules and completions load without errors"

# Test in VSCode
Write-Host "`nTesting in VSCode PowerShell Terminal:" -ForegroundColor Yellow
Write-Host "1. Open a new PowerShell terminal in VSCode"
Write-Host "2. Run the following command to test with timing information:"
Write-Host "   . `$PROFILE -Measure" -ForegroundColor Green
Write-Host "3. Verify that the custom VSCode prompt is used (not oh-my-posh)"
Write-Host "4. Verify that all modules and completions load without errors"
Write-Host "5. Verify that the environment detection shows VSCode=True"

# Verify environment detection
Write-Host "`nVerifying Environment Detection:" -ForegroundColor Yellow
Write-Host "Run this command in both environments to verify detection:"
Write-Host "   Write-Host `"Environment: VSCode=`$isVSCode, RegularPS=`$isRegularPowerShell`"" -ForegroundColor Green

# Troubleshooting
Write-Host "`nTroubleshooting:" -ForegroundColor Yellow
Write-Host "If you encounter any issues:"
Write-Host "1. Check the verbose output with:"
Write-Host "   . `$PROFILE -Measure -Verbose" -ForegroundColor Green
Write-Host "2. Restore the original profile if needed (backup was created automatically)"
Write-Host "3. Review the Profile-Optimization-README.md file for detailed information"

Write-Host "`nSummary of Changes:" -ForegroundColor Cyan
Write-Host "1. Added environment detection to handle different PowerShell hosts"
Write-Host "2. Optimized profile loading with caching and conditional loading"
Write-Host "3. Fixed path detection issues in VSCode"
Write-Host "4. Added custom prompt for VSCode"
Write-Host "5. Added performance measurement with -Measure parameter"

Write-Host "`nThe optimized profile should now load faster and work correctly in both environments." -ForegroundColor Green
