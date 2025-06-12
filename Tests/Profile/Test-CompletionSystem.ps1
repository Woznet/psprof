# Test-CompletionSystem.ps1
# Comprehensive test for the completion system

param(
    [switch]$Verbose
)

if ($Verbose) { $VerbosePreference = 'Continue' }

Write-Host "Testing PowerShell Profile Completion System" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

# Test 1: Profile Load
Write-Host "`n1. Testing Profile Load..." -ForegroundColor Yellow
try {
    . "$env:USERPROFILE\Documents\PowerShell\Profile.ps1" -Verbose:$Verbose
    Write-Host "   ✅ Profile loaded successfully" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Profile load failed: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Check if lazy completers are registered
Write-Host "`n2. Testing Lazy Completer Registration..." -ForegroundColor Yellow
$lazyCompleters = Get-ArgumentCompleter | Where-Object {
    $_.CommandName -in @('volta', 'gh', 'winget', 'docker', 'scoop')
}

if ($lazyCompleters.Count -gt 0) {
    Write-Host "   ✅ Found $($lazyCompleters.Count) lazy completers registered" -ForegroundColor Green
    $lazyCompleters | ForEach-Object {
        Write-Host "      - $($_.CommandName)" -ForegroundColor Gray
    }
} else {
    Write-Host "   ⚠️  No lazy completers found (this might be normal for native completers)" -ForegroundColor Yellow
}

# Test 3: Check if volta is available
Write-Host "`n3. Testing Volta Availability..." -ForegroundColor Yellow
if (Get-Command volta -ErrorAction SilentlyContinue) {
    Write-Host "   ✅ Volta command is available" -ForegroundColor Green
    $voltaVersion = volta --version 2>$null
    Write-Host "      Version: $voltaVersion" -ForegroundColor Gray
} else {
    Write-Host "   ❌ Volta command not found" -ForegroundColor Red
}

# Test 4: Test completion using PowerShell's completion system
Write-Host "`n4. Testing Volta Completion..." -ForegroundColor Yellow
try {
    $completionResults = [System.Management.Automation.CommandCompletion]::CompleteInput(
        "volta install",
        "volta install".Length,
        $null
    )

    if ($completionResults.CompletionMatches.Count -gt 0) {
        Write-Host "   ✅ Volta completion working! Found $($completionResults.CompletionMatches.Count) matches" -ForegroundColor Green
        Write-Host "      Sample completions:" -ForegroundColor Gray
        $completionResults.CompletionMatches | Select-Object -First 3 | ForEach-Object {
            Write-Host "        - $($_.CompletionText)" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ⚠️  No completions found for 'volta install'" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Completion test failed: $_" -ForegroundColor Red
}

# Test 5: Test another command for comparison
Write-Host "`n5. Testing Built-in PowerShell Completion..." -ForegroundColor Yellow
try {
    $psCompletionResults = [System.Management.Automation.CommandCompletion]::CompleteInput(
        "Get-Chil",
        "Get-Chil".Length,
        $null
    )

    if ($psCompletionResults.CompletionMatches.Count -gt 0) {
        Write-Host "   ✅ PowerShell completion working! Found $($psCompletionResults.CompletionMatches.Count) matches" -ForegroundColor Green
    } else {
        Write-Host "   ❌ PowerShell completion not working" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ PowerShell completion test failed: $_" -ForegroundColor Red
}

Write-Host "`n" + "=" * 50 -ForegroundColor Cyan
Write-Host "Completion System Test Complete" -ForegroundColor Cyan
