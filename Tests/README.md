# Tests

> [!NOTE]
> This directory contains various tests for the PowerShell `$PROFILE` setup and additional system-level tests to verify the configuration and functionality of the system.

## Contents

- [Overview](#overview)
- [End-to-End Tests](#end-to-end-tests)
- [Integration Tests](#integration-tests)
- [Unit Tests](#unit-tests)
- [System Tests](#system-tests)
- [Profile Tests](#profile-tests)
- [Usage](#usage)
- [Results](#results)
- [Additional Information](#additional-information)
- [Conclusion](#conclusion)
- [Appendix](#appendix)

## Overview

![results](results.png)

## End-to-End Tests

> [!NOTE]
> This directory contains *end-to-end* tests to verify the overall functionality of the system.

`#TODO`

## Integration Tests

> [!NOTE]
> This directory contains *integration* tests to verify the interaction between different components of the system.

`#TODO`

## Unit Tests

> [!NOTE]
> This directory contains *unit* tests to verify the functionality of individual components of the system.

`#TODO`

## System Tests

> [!NOTE]
> This directory contains *system-level integration* tests to verify the overall functionality of the system.

- [Defender Tests](./Windows/Defender.Tests.ps1): Verifies Windows Defender settings, including exclusions, real-time protection, and firewall configuration.
- [Explorer Tests](./Windows/Explorer.Tests.ps1): Checks the configuration of Windows File Explorer and its settings.
- [Git Tests](./Windows/Git.Tests.ps1): Ensures the proper configuration of the Git version control system.
- [Installed Software Tests](./Windows/InstalledApps.Tests.ps1): Verifies the installation and configuration of various software packages.
- [Installed PowerShell Modules Tests](./Windows/InstalledModules.Tests.ps1): Checks the installation and configuration of PowerShell modules.
- [Network Tests](./Windows/Network.Tests.ps1): Verifies network settings and options.
- [PowerShell Tests](./Windows/PowerShell.Tests.ps1): Ensures the proper configuration of the PowerShell environment.
- [Registry Tests](./Windows/Registry.Tests.ps1): Ensures the proper configuration of the Windows Registry.
- [SSH Tests](./Windows/SSH.Tests.ps1): Verifies the configuration of the SSH client and server.
- [Visual Studio Code Tests](./Windows/VSCode.Tests.ps1): Verifies the configuration of Visual Studio Code and its settings.
- [Windows Terminal Tests](./Windows/Terminal.Tests.ps1): Checks the configuration of the Windows Terminal program.
- [Windows Subsystem for Linux (WSL) Tests](./Windows/WSL.Tests.ps1): Ensures the proper installation and configuration of WSL.

## Profile Tests

The `Profile/` directory contains tests specifically for the PowerShell profile setup:

- **Test-ProfileSetup.ps1** - Comprehensive verification of the entire profile setup
- **Test-CompletionFinal.ps1** - Tests for CLI completion functionality
- **Test-CompletionSystem.ps1** - Tests for the completion system architecture
- **Test-VoltaCompletion.ps1** - Specific tests for Volta CLI completions
- **Test-VSCodeProfile.ps1** - Tests for VSCode-specific profile features
- **Profile.Tests.ps1** - Unit tests for profile components
- **Optimization/** - Performance and optimization tests

### Running Profile Tests

```powershell
# Run comprehensive profile setup verification
pwsh -NoProfile -File ".\Tests\Profile\Test-ProfileSetup.ps1"

# Run specific completion tests
pwsh -NoProfile -File ".\Tests\Profile\Test-VoltaCompletion.ps1"

# Run all profile tests
Get-ChildItem ".\Tests\Profile\Test-*.ps1" | ForEach-Object {
    Write-Host "Running $($_.Name)..." -ForegroundColor Yellow
    pwsh -NoProfile -File $_.FullName
}
```

## Usage

To run all tests, run the [`Pester.ps1`](./Pester.ps1) script which will:

1. Run `Invoke-Pester` for each test file in the this directory.
2. Display the results in the console.
3. Generate a summary report using [ReportUnit](https://www.nuget.org/packages/ReportUnit/1.5.0-beta1) (see the [`Tools/ReportUnit`](../Tools/ReportUnit/) directory).

- `Pester.ps1`:

```powershell
#Requires -Module Pester

<#
    .SYNOPSIS
        Pester Tests
#>

$PesterConfig = New-PesterConfiguration
$PesterConfig.TestResult.OutputFormat = "NUnitXml"
$PesterConfig.TestResult.OutputPath = "$PSScriptRoot\Results.xml"
$PesterConfig.TestResult.Enabled = $True

Invoke-Pester -Configuration $PesterConfig

# Copy the results to the ReportUnit folder
Copy-Item -Path "$PSScriptRoot\Results.xml" -Destination "$PSScriptRoot\..\Tools\ReportUnit\Results.xml" -Force
Write-Host "Results.xml copied to ReportUnit folder"

# Generate ReportUnit HTML Report
$ResultsPath = "$PSScriptRoot\results.xml"
$ReportPath = "$PSScriptRoot\report.html"

$ReportUnitExe = "$PSScriptRoot\..\Tools\ReportUnit\ReportUnit.exe"
if (Test-Path $ReportUnitExe) {
    Write-Host "Generating HTML report..."
    & $ReportUnitExe "$ResultsPath" "$ReportPath"
} else {
    Write-Warning "ReportUnit.exe not found at $ReportUnitExe"
}

# Open the HTML report
if (Test-Path $ReportPath) {
    Write-Host "Opening HTML report..."
    Start-Process $ReportPath
} else {
    Write-Warning "HTML report not found at $ReportPath"
}
```

## Results

Test results will be displayed in the console, showing the status of each test and any failures. If tests fail, the output will indicate which tests failed and provide additional information about the failure. If all tests pass, the output will confirm successful completion.

Future updates will include an option to generate detailed test reports.

## Additional Information

## Conclusion

***

## Appendix

### Future Planned Additions

For Windows:

- Winget Tests (`Winget.Tests.ps1`): Checks the installation and configuration of the Windows Package Manager (winget).
- Windows Update Tests (`WindowsUpdate.Tests.ps1`): Verifies the configuration of the Windows Update service.
- Windows Firewall Tests (`Firewall.Tests.ps1`): Checks the configuration of the Windows Firewall.
- Windows Security Tests (`Security.Tests.ps1`): Verifies the configuration of Windows Security.
- Windows Settings Tests (`Settings.Tests.ps1`): Checks various Windows settings and options.
- Windows Services Tests (`Services.Tests.ps1`): Verifies the configuration of various Windows services.
- Windows Optional Features Tests (`OptionalFeatures.Tests.ps1`): Checks the installation and configuration of Windows optional features.
- Windows Scheduled Tasks Tests (`ScheduledTasks.Tests.ps1`): Verifies the configuration of Windows scheduled tasks.
