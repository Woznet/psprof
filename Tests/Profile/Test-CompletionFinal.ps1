#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Final comprehensive test of the completion system
.DESCRIPTION
    Tests the completion system to ensure lazy loading and volta completion work properly
#>

Write-Host "Final Completion System Test" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor DarkGray

# Test 1: Profile Load with timing
Write-Host "`n1. Testing Profile Load with Timing..." -ForegroundColor Yellow
$profileStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    . "$PSScriptRoot\Profile.ps1"
    $profileStopwatch.Stop()
    Write-Host "   ✅ Profile loaded successfully in $($profileStopwatch.ElapsedMilliseconds)ms" -ForegroundColor Green
} catch {
    $profileStopwatch.Stop()
    Write-Host "   ❌ Profile failed to load: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Check if volta is available
Write-Host "`n2. Testing Volta Availability..." -ForegroundColor Yellow
$volta = Get-Command volta -ErrorAction SilentlyContinue
if ($volta) {
    $voltaVersion = (volta --version 2>$null).Trim()
    Write-Host "   ✅ Volta command is available" -ForegroundColor Green
    Write-Host "      Version: $voltaVersion" -ForegroundColor Gray
} else {
    Write-Host "   ❌ Volta command not found" -ForegroundColor Red
    exit 1
}

# Test 3: Test volta completion generation
Write-Host "`n3. Testing Volta Completion Generation..." -ForegroundColor Yellow
try {
    $completionScript = volta completions powershell | Out-String
    if ($completionScript -and $completionScript.Contains("Register-ArgumentCompleter")) {
        Write-Host "   ✅ Volta completion script generated successfully" -ForegroundColor Green
        Write-Host "      Script length: $($completionScript.Length) characters" -ForegroundColor Gray
    } else {
        Write-Host "   ❌ Volta completion script invalid or empty" -ForegroundColor Red
    }
} catch {
    Write-Host "   ❌ Failed to generate volta completion script: $_" -ForegroundColor Red
}

# Test 4: Test manual completion registration
Write-Host "`n4. Testing Manual Completion Registration..." -ForegroundColor Yellow
try {
    # Register volta completion manually
    volta completions powershell | Out-String | Invoke-Expression
    Write-Host "   ✅ Volta completion registered manually" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Failed to register volta completion manually: $_" -ForegroundColor Red
}

# Test 5: Test completion with PowerShell API
Write-Host "`n5. Testing Completion API..." -ForegroundColor Yellow
try {
    $results = [System.Management.Automation.CommandCompletion]::CompleteInput("volta ", 6, $null)
    if ($results.CompletionMatches.Count -gt 0) {
        Write-Host "   ✅ Volta completion working! Found $($results.CompletionMatches.Count) matches" -ForegroundColor Green
        $sampleMatches = $results.CompletionMatches | Select-Object -First 5 -ExpandProperty CompletionText
        Write-Host "      Sample matches: $($sampleMatches -join ', ')" -ForegroundColor Gray
    } else {
        Write-Host "   ⚠️  No completions found for 'volta '" -ForegroundColor Yellow
    }
} catch {
    Write-Host "   ❌ Error testing completion API: $_" -ForegroundColor Red
}

# Test 6: Test lazy loading mechanism
Write-Host "`n6. Testing Lazy Loading Mechanism..." -ForegroundColor Yellow
$lazyCompleterPath = "$PSScriptRoot\Profile\functions\Private\LazyLoad-Functions.ps1"
if (Test-Path $lazyCompleterPath) {
    Write-Host "   ✅ Lazy loading functions found" -ForegroundColor Green

    # Check if Register-LazyCompletion function is available
    if (Get-Command Register-LazyCompletion -ErrorAction SilentlyContinue) {
        Write-Host "   ✅ Register-LazyCompletion function is available" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Register-LazyCompletion function not found" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ❌ Lazy loading functions file not found" -ForegroundColor Red
}

# Test 7: Test configuration
Write-Host "`n7. Testing Configuration..." -ForegroundColor Yellow
$configPath = "$PSScriptRoot\Profile\Config\Completions.psd1"
if (Test-Path $configPath) {
    try {
        $config = Import-PowerShellDataFile -Path $configPath
        if ($config.CommonCommands.volta) {
            Write-Host "   ✅ Volta is configured for lazy loading" -ForegroundColor Green
            Write-Host "      Script path: $($config.CommonCommands.volta)" -ForegroundColor Gray
        } else {
            Write-Host "   ⚠️  Volta not found in configuration" -ForegroundColor Yellow
        }

        if ($config.Settings.LazyLoad) {
            Write-Host "   ✅ Lazy loading is enabled" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Lazy loading is disabled" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ❌ Failed to parse configuration: $_" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ Configuration file not found" -ForegroundColor Red
}

Write-Host "`n$("=" * 50)" -ForegroundColor DarkGray
Write-Host "Final Completion System Test Complete" -ForegroundColor Cyan

# Summary
Write-Host "`nSUMMARY:" -ForegroundColor Magenta
Write-Host "- Profile load time: $($profileStopwatch.ElapsedMilliseconds)ms" -ForegroundColor White
Write-Host "- Volta completion should now work with tab completion" -ForegroundColor White
Write-Host "- Run 'volta <TAB>' to test interactive completion" -ForegroundColor White
