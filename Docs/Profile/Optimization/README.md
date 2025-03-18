# PowerShell Profile Optimization

This document explains the optimizations made to improve the loading time of your PowerShell profile and fix environment detection issues.

## Identified Issues

After analyzing your PowerShell profile, the following issues were identified:

### Performance Bottlenecks

1. **ModuleFast Download**: The `iwr bit.ly/modulefast | iex` command downloads and executes a script from the internet every time the profile loads, which takes significant time.

2. **PSReadLine Configuration Error**: There was an error in the PSReadLine configuration related to the PredictionSource parameter, which might be causing delays.

3. **Completions Path Issue**: There was a path issue with the completions directory, which was looking for completions in the wrong location.

4. **Style Script Error**: There was a syntax error in the Style script.

5. **PowerShell Version Requirement**: ModuleFast requires PowerShell 7.2 or higher, which might not be available in all environments.

### Environment Detection Issues

6. **VSCode Path Detection**: When running in VSCode, the profile couldn't detect various paths (like oh-my-posh) correctly.

7. **Profile Loading in VSCode**: Both the AllHosts profile (Profile.ps1) and the VSCode-specific profile (Microsoft.VSCode_profile.ps1) were loading in VSCode, causing conflicts.

## Optimizations Applied

The following optimizations were applied to improve the loading time:

### 1. ModuleFast Caching

Instead of downloading ModuleFast every time, we now cache it locally and only refresh it once a week:

```powershell
# Check for cached ModuleFast script
$moduleFastCache = Join-Path -Path $env:TEMP -ChildPath "modulefast_cache.ps1"

# Only download if cache doesn't exist or is older than 7 days
if (-not (Test-Path -Path $moduleFastCache) -or
    ((Get-Item -Path $moduleFastCache).LastWriteTime -lt (Get-Date).AddDays(-7))) {
    # Cache doesn't exist or is older than 7 days, download and cache
    try {
        $moduleFastContent = Invoke-WebRequest -Uri "bit.ly/modulefast" -UseBasicParsing
        $moduleFastContent.Content | Out-File -FilePath $moduleFastCache -Encoding utf8
    } catch {
        Write-Warning "Failed to download and cache ModuleFast: $_"
    }
}

# Execute from cache if it exists and PowerShell version is compatible
if ((Test-Path -Path $moduleFastCache) -and ($PSVersionTable.PSVersion.Major -ge 7 -and $PSVersionTable.PSVersion.Minor -ge 2)) {
    . $moduleFastCache
}
```

### 2. PSReadLine Version Check

Added version checking before using PSReadLine features that might not be available in older versions:

```powershell
# Check PSReadLine version before setting prediction options
$psrlVersion = (Get-Module PSReadLine).Version
if ($psrlVersion -ge [Version]"2.2.0") {
    # Predictive Intellisense (only for PSReadLine 2.2.0+)
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    
    # ListView (only for PSReadLine 2.2.0+)
    Set-PSReadLineOption -PredictionViewStyle ListView
}
```

### 3. Fixed Completions Path

Corrected the path for loading completion scripts:

```powershell
$completionPath = Join-Path -Path $ProfileSourcePath -ChildPath "Completions"
if (Test-Path -Path $completionPath) {
    $completionFiles = Get-ChildItem -Path $completionPath -Filter "*.ps1" -ErrorAction SilentlyContinue
    
    if ($completionFiles -and $completionFiles.Count -gt 0) {
        foreach ($file in $completionFiles) {
            try {
                . $file.FullName
            } catch {
                Write-Warning "Failed to load completion script $($file.Name): $_"
            }
        }
    }
}
```

### 4. Optimized Module Loading

Separated modules into essential and optional categories, only loading optional modules if they're already installed:

```powershell
# Define essential modules to import
$EssentialModules = @(
    'PSReadLine'
    'Terminal-Icons'
)

# Define optional modules that can be loaded on demand
$OptionalModules = @(
    'posh-git'
    'CompletionPredictor'
    'Microsoft.PowerShell.ConsoleGuiTools'
    'F7History'
    'PoshCodex'
)

# Import essential modules
foreach ($Mod in $EssentialModules) {
    Import-Module $Mod -ErrorAction SilentlyContinue
}

# Import optional modules only if they're already installed
foreach ($Mod in $OptionalModules) {
    if (Get-Module -ListAvailable -Name $Mod -ErrorAction SilentlyContinue) {
        Import-Module $Mod -ErrorAction SilentlyContinue
    }
}
```

### 5. Zoxide Caching

Added caching for zoxide initialization to avoid running the command every time:

```powershell
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    # Cache zoxide init output
    $zoxideCachePath = Join-Path -Path $env:TEMP -ChildPath "zoxide_init_cache.ps1"
    
    # Only regenerate if cache doesn't exist or is older than 7 days
    if (-not (Test-Path -Path $zoxideCachePath) -or
        ((Get-Item -Path $zoxideCachePath).LastWriteTime -lt (Get-Date).AddDays(-7))) {
        (zoxide init powershell | Out-String) | Out-File -FilePath $zoxideCachePath -Encoding utf8
    }
    
    # Execute from cache if it exists
    if (Test-Path -Path $zoxideCachePath) {
        . $zoxideCachePath
    }
}
```

### 6. Conditional Loading

Added conditional loading for components that might not be needed in every session:

- Only load the prompt customization if oh-my-posh is installed
- Only load completions if the directory exists
- Only load optional modules if they're already installed

### 7. Environment Detection

Added environment detection to handle different PowerShell hosts (VSCode, regular console):

```powershell
# Detect PowerShell environment
$Global:isVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $host.Name -eq 'Visual Studio Code Host'
$Global:isRegularPowerShell = $host.Name -eq 'ConsoleHost' -and -not $isVSCode
$Global:isISE = $host.Name -eq 'Windows PowerShell ISE Host'

Write-Verbose "Environment detection: VSCode=$isVSCode, RegularPowerShell=$isRegularPowerShell, ISE=$isISE"
```

This allows conditional loading of components based on the environment:

```powershell
# Skip oh-my-posh in VSCode as it often has path detection issues
if (-not $isVSCode -and (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    # Load oh-my-posh only in regular PowerShell
}
```

### 8. VSCode-Specific Profile

Enhanced the VSCode-specific profile with a custom prompt and environment detection:

```powershell
# Set VSCode-specific environment variable to help with detection
$env:TERM_PROGRAM = 'vscode'

# VSCode-specific settings
if (-not (Get-Variable -Name isVSCode -ErrorAction SilentlyContinue)) {
  $Global:isVSCode = $true
  $Global:isRegularPowerShell = $false
  $Global:isISE = $false
}

# VSCode-specific prompt (simpler than oh-my-posh)
function prompt {
  # Custom prompt code that works well in VSCode
}
```

### 9. Performance Measurement

Added a `-Measure` parameter to track the loading time of each component:

```powershell
if ($Measure) {
    $mainStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timings = @{}
    
    # ... (code to measure each block)
    
    # Display timing information
    $mainStopwatch.Stop()
    Write-Host "`nProfile Load Times:" -ForegroundColor Cyan
    $timings.GetEnumerator() | Sort-Object -Property Value -Descending | ForEach-Object {
        Write-Host "  $($_.Key): $($_.Value.TotalSeconds) seconds" -ForegroundColor White
    }
    Write-Host "`nTotal profile load time: $($mainStopwatch.Elapsed.TotalSeconds) seconds" -ForegroundColor Cyan
}
```

## How to Use the Optimized Profile

The optimized profile setup consists of two main files:

1. **Profile.ps1** - The main profile with optimizations and environment detection
2. **Microsoft.VSCode_profile.ps1** - VSCode-specific profile with custom prompt

### Installation

1. The main Profile.ps1 has been updated with all optimizations:
   ```powershell
   # No additional action needed - Profile.ps1 now includes all optimizations
   ```

2. Test the optimized profile with the -Measure parameter to see detailed timing information:
   ```powershell
   pwsh -NoLogo -NoExit -Command '. $PROFILE -Measure'
   ```

3. To test in VSCode, restart your VSCode PowerShell terminal or run:
   ```powershell
   . $PROFILE
   ```

4. If you encounter any issues, you can restore the original profile from the backup that was automatically created.

### How It Works

- When you start PowerShell in a regular console, `Profile.ps1` loads with environment detection and applies regular PowerShell settings
- When you start PowerShell in VSCode, both `Profile.ps1` and `Microsoft.VSCode_profile.ps1` load, but the environment detection ensures that VSCode-specific settings are applied and problematic components (like oh-my-posh) are skipped

## Diagnostic Tools

Several diagnostic tools were created to help identify and fix the performance issues:

1. **Measure-ProfileLoadTime.ps1**: Measures the execution time of each component of the profile.
2. **Test-ModuleFast.ps1**: Tests the download and execution time of ModuleFast.
3. **Profile-Debug.ps1**: A debug version of the profile with timing information.
4. **Test-ProfilePerformance.ps1**: Compares the performance of the original and optimized profiles.

## Additional Recommendations

1. Consider using PowerShell's built-in module auto-loading instead of explicit imports.
2. Use conditional loading for heavy modules that aren't needed in every session.
3. Consider using a startup timer to identify slow-loading modules in the future.
4. Use Import-Module with the -ErrorAction SilentlyContinue parameter instead of try/catch blocks.
