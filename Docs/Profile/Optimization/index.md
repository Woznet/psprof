# PowerShell Profile Optimization

This directory contains documentation and resources related to the PowerShell profile optimization project.

## Overview

The PowerShell profile optimization project addresses performance and environment detection issues in the PowerShell profile. It includes:

1. Performance optimizations to reduce profile loading time
2. Environment detection to handle different PowerShell hosts (VSCode, regular console, ISE)
3. Fixes for path detection issues in VSCode
4. Custom prompt for VSCode

## Documentation

- [README.md](README.md) - Comprehensive documentation of the optimizations and how they work

## Test Files

The test files for this project are located in `Tests/Profile/Optimization/`:

- `Measure-ProfileLoadTime.ps1` - Measures the execution time of each profile component
- `Test-ModuleFast.ps1` - Tests the download and execution time of ModuleFast
- `Test-ProfilePerformance.ps1` - Compares the performance of the original and optimized profiles
- `Test-ProfileEnvironments.ps1` - Tests the profile in different environments
- `Test-ProfileOptimization.ps1` - Automated tests for the profile optimization
- `Profile-Debug.ps1` - Debug version of the profile with timing information

## Implementation Files

The main implementation files are:

- `Profile.ps1` - The main profile with optimizations and environment detection
- `Microsoft.VSCode_profile.ps1` - VSCode-specific profile with custom prompt

## How to Test

Run the automated tests:

```powershell
cd Tests/Profile/Optimization
./Test-ProfileOptimization.ps1 -RunAllTests
```

Test in different environments:

1. Regular PowerShell:
   ```powershell
   . $PROFILE -Measure
   ```

2. VSCode PowerShell Terminal:
   ```powershell
   . $PROFILE -Measure
   ```

## Related Resources

- [PowerShell Profile Documentation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles)
- [VSCode PowerShell Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [Oh-My-Posh Documentation](https://ohmyposh.dev/)
