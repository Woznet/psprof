# Test-ModuleFast.ps1
# Script to test the ModuleFast download and execution

[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$VerbosePreference = 'Continue'

Write-Host "Testing ModuleFast download and execution..." -ForegroundColor Cyan

# Test direct download
$downloadStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Downloading ModuleFast script..." -ForegroundColor Yellow
try {
    $moduleFastContent = Invoke-WebRequest -Uri "bit.ly/modulefast" -UseBasicParsing
    $downloadStopwatch.Stop()
    Write-Host "  Download completed in $($downloadStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
    Write-Host "  Content length: $($moduleFastContent.Content.Length) bytes" -ForegroundColor Green
}
catch {
    $downloadStopwatch.Stop()
    Write-Host "  Error downloading ModuleFast: $_" -ForegroundColor Red
}

# Test execution (without actually executing)
$parseStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "Parsing ModuleFast script..." -ForegroundColor Yellow
try {
    $scriptBlock = [ScriptBlock]::Create($moduleFastContent.Content)
    $parseStopwatch.Stop()
    Write-Host "  Parsing completed in $($parseStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Green
}
catch {
    $parseStopwatch.Stop()
    Write-Host "  Error parsing ModuleFast script: $_" -ForegroundColor Red
}

# Create a cached version
Write-Host "Creating cached version of ModuleFast..." -ForegroundColor Yellow
$cachePath = Join-Path -Path $env:TEMP -ChildPath "modulefast_cache.ps1"
try {
    $moduleFastContent.Content | Out-File -FilePath $cachePath -Encoding utf8
    Write-Host "  Cached ModuleFast script to: $cachePath" -ForegroundColor Green

    # Test loading from cache
    $cacheStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $cachedContent = Get-Content -Path $cachePath -Raw
    $cacheStopwatch.Stop()
    Write-Host "  Loading from cache completed in $($cacheStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Green

    # Compare times
    Write-Host "`nPerformance Comparison:" -ForegroundColor Cyan
    Write-Host "  Download time: $($downloadStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor White
    Write-Host "  Cache load time: $($cacheStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor White
    Write-Host "  Improvement: $([math]::Round(($downloadStopwatch.Elapsed.TotalSeconds - $cacheStopwatch.Elapsed.TotalSeconds) / $downloadStopwatch.Elapsed.TotalSeconds * 100, 2))%" -ForegroundColor White
}
catch {
    Write-Host "  Error creating cached version: $_" -ForegroundColor Red
}

# Recommendations
Write-Host "`nRecommendations:" -ForegroundColor Cyan
Write-Host "1. Replace 'iwr bit.ly/modulefast | iex' with a cached version:" -ForegroundColor White
Write-Host @"
   # Check for cached ModuleFast script
   `$moduleFastCache = Join-Path -Path `$env:TEMP -ChildPath "modulefast_cache.ps1"
   if (-not (Test-Path -Path `$moduleFastCache) -or
       ((Get-Item -Path `$moduleFastCache).LastWriteTime -lt (Get-Date).AddDays(-7))) {
       # Cache doesn't exist or is older than 7 days, download and cache
       try {
           `$moduleFastContent = Invoke-WebRequest -Uri "bit.ly/modulefast" -UseBasicParsing
           `$moduleFastContent.Content | Out-File -FilePath `$moduleFastCache -Encoding utf8
       } catch {
           Write-Warning "Failed to download and cache ModuleFast: `$_"
       }
   }

   # Execute from cache if it exists
   if (Test-Path -Path `$moduleFastCache) {
       . `$moduleFastCache
   }
"@ -ForegroundColor Gray
