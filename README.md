# PowerShell Profile

<!-- BADGES:START -->
[![Automate Changelog](https://github.com/jimbrig/psprof/actions/workflows/changelog.yml/badge.svg)](https://github.com/jimbrig/psprof/actions/workflows/changelog.yml)
[![Dependabot Updates](https://github.com/jimbrig/psprof/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/jimbrig/psprof/actions/workflows/dependabot/dependabot-updates)
[![PSScriptAnalyzer](https://github.com/jimbrig/psprof/actions/workflows/psscriptanalyzer.yml/badge.svg)](https://github.com/jimbrig/psprof/actions/workflows/psscriptanalyzer.yml)
<!-- BADGES:END -->

> [!NOTE]
> My customized PowerShell Core profile configuration and scripts.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Directory Structure](#directory-structure)
- [Usage](#usage)
- [Requirements](#requirements)
- [Functions](#functions)
- [Modules](#modules)
- [Profile Variants](#profile-variants)
- [Profile Optimization](#profile-optimization)
- [Documentation](#documentation)
- [Testing](#testing)
- [License](#license)

## Overview

This repository contains my PowerShell profile configuration organized into a highly modular and configurable structure:

- [`Profile.ps1`](Profile.ps1) - Main profile entry point that loads all components
- [`Microsoft.PowerShell_profile.ps1`](Microsoft.PowerShell_profile.ps1) - Host-specific customizations for console
- [`Microsoft.VSCode_profile.ps1`](Microsoft.VSCode_profile.ps1) - VSCode-specific customizations
- [`Profile/`](Profile/) - Core configuration directory:
  - [`Profile.ps1`](Profile/Profile.ps1) - Main profile loader
  - [`Profile.Configuration.psd1`](Profile/Profile.Configuration.psd1) - Central configuration
  - [`Components/`](Profile/Components/) - Implementation scripts
  - [`Config/`](Profile/Config/) - Configuration data files (PSD1)
  - [`Aliases/`](Profile/Aliases/) - Alias definition files
  - [`Completions/`](Profile/Completions/) - Tab completion scripts
  - [`Functions/`](Profile/Functions/) - Function definition files
  - [`Variants/`](Profile/Variants/) - Profile variants for different scenarios

## Key Features

- Modular configuration with separation of configuration and implementation
- Multiple profile variants (Debug, Minimal, Optimized)
- Oh-my-posh theme integration
- Extensive custom functions for system administration, development, and productivity
- Shell completion for numerous popular tools and commands
- Useful aliases and keyboard shortcuts
- Module management and synchronization
- PSReadLine customization with intelligent history and prediction
- Environment-specific configuration (VSCode, Console, etc.)
- Performance optimization with lazy loading
- Custom modules for specialized tasks (PSDefender, PSProfile, etc.)

## Directory Structure

```plaintext
PowerShell/
├── Profile/                      # Core configuration directory
│   ├── Aliases/                  # Alias definition files
│   │   ├── _Imports.ps1          # Alias imports helper
│   │   ├── Development.Aliases.psd1  # Development aliases
│   │   ├── Navigation.Aliases.psd1   # Navigation aliases
│   │   ├── Program.Aliases.psd1      # Program aliases
│   │   └── System.Aliases.psd1       # System aliases
│   ├── Components/               # Component implementation scripts
│   │   ├── Aliases.ps1           # Loads aliases from configuration
│   │   ├── Completions.ps1       # Loads completions
│   │   ├── DefaultParams.ps1     # Sets default parameters
│   │   ├── Extras.ps1            # Loads extra integrations
│   │   ├── Functions.ps1         # Loads functions
│   │   ├── Modules.ps1           # Imports modules
│   │   ├── Prompt.ps1            # Configures prompt
│   │   ├── PSReadLine.ps1        # Configures PSReadLine
│   │   └── Style.ps1             # Configures styling
│   ├── Completions/              # Tab completion scripts
│   │   ├── ai.ps1                # AI tool completions
│   │   ├── aws.ps1               # AWS CLI completions
│   │   ├── docker.ps1            # Docker completions
│   │   ├── git-cliff.ps1         # git-cliff completions
│   │   ├── gh-cli.ps1            # GitHub CLI completions
│   │   └── ... (many more)
│   ├── Config/                   # Configuration data files (PSD1)
│   │   ├── Aliases.psd1          # Alias configuration
│   │   ├── Completions.psd1      # Completions configuration
│   │   ├── DefaultParams.psd1    # Default parameters configuration
│   │   ├── Extras.psd1           # Extra integrations configuration
│   │   ├── Functions.psd1        # Function categories configuration
│   │   ├── Modules.psd1          # Module import configuration
│   │   ├── Prompt.psd1           # Prompt configuration
│   │   ├── PSReadLine.psd1       # PSReadLine configuration
│   │   └── Style.psd1            # Style configuration
│   ├── Functions/                # Function definition files
│   │   ├── AdminTools.ps1        # Admin utility functions
│   │   ├── Apps.ps1              # Application management functions
│   │   ├── DialogTools.ps1       # Dialog and UI functions
│   │   ├── Environment.ps1       # Environment management functions
│   │   ├── FileSystem.ps1        # File system functions
│   │   ├── HashingTools.ps1      # Hashing utility functions
│   │   ├── Navigation.ps1        # Navigation functions
│   │   ├── ProfileTools.ps1      # Profile management functions
│   │   ├── System.ps1            # System utility functions
│   │   ├── Private/              # Private helper functions
│   │   └── Public/               # Public utility functions
│   ├── Variants/                 # Profile variants
│   │   ├── Profile-Debug.ps1     # Debug profile with extra logging
│   │   ├── Profile-Minimal.ps1   # Minimal profile for performance
│   │   └── Profile-Optimized.ps1 # Optimized profile
│   ├── Profile.Aliases.ps1       # Aliases loader
│   ├── Profile.Completions.ps1   # Completions loader
│   ├── Profile.Configuration.psd1 # Main configuration file
│   ├── Profile.DefaultParams.ps1 # Default parameters loader
│   ├── Profile.Extras.ps1        # Extra integrations loader
│   ├── Profile.Functions.ps1     # Functions loader
│   ├── Profile.Modules.ps1       # Modules loader
│   ├── Profile.Prompt.ps1        # Prompt configuration
│   ├── Profile.ps1               # Main profile loader
│   ├── Profile.PSReadLine.ps1    # PSReadLine configuration
│   ├── Profile.Style.ps1         # Style configuration
│   └── README.md                 # Profile documentation
├── Scripts/                      # Standalone utility scripts
│   ├── Add-GodModeShortcut.ps1   # Create God Mode shortcut
│   ├── Add-LogEntry.ps1          # Add log entry utility
│   ├── ConvertTo-Markdown.ps1    # Convert to Markdown
│   ├── Extract-IconFromExe.ps1   # Extract icon from executable
│   ├── Get-GitHubRelease.ps1     # Download GitHub releases
│   ├── Install-NerdFont.ps1      # Install Nerd Fonts
│   ├── PowerShell.Scripts.psd1   # Scripts manifest
│   └── ... (many more)
├── Source/                       # Source code for custom modules
│   ├── Classes/                  # PowerShell classes
│   ├── Completions/              # Completion source files
│   ├── Config/                   # Configuration templates
│   ├── Enums/                    # PowerShell enums
│   ├── Modules/                  # Custom PowerShell modules
│   │   ├── PSDefender/           # Windows Defender management
│   │   ├── PSProfile/            # Profile management utilities
│   │   ├── PSSysInfo/            # System information utilities
│   │   └── ... (more modules)
│   ├── Scripts/                  # Source scripts
│   └── Templates/                # Template files
├── Tests/                        # Test scripts and utilities
│   ├── Helpers/                  # Test helper functions
│   ├── Profile/                  # Profile tests
│   │   └── Optimization/         # Profile optimization tests
│   ├── System/                   # System configuration tests
│   └── Invoke-Tests.ps1          # Test runner
├── Tools/                        # External tools
│   └── ReportUnit/               # Test reporting tool
├── Docs/                         # Documentation
│   ├── Profile/                  # Profile documentation
│   │   └── Optimization/         # Optimization documentation
│   ├── mkdocs.yml                # MkDocs configuration
│   └── requirements.txt          # Documentation dependencies
├── Microsoft.PowerShell_profile.ps1  # Console-specific profile
├── Microsoft.VSCode_profile.ps1      # VSCode-specific profile
├── powershell.config.json            # PowerShell configuration
└── Profile.ps1                       # Main profile entry point
```

## Usage

1. Clone this repository to your PowerShell profile location:

   ```powershell
   git clone https://github.com/jimbrig/psprof.git $HOME\Documents\PowerShell
   ```

2. Reload your PowerShell profile:

   ```powershell
   . $PROFILE
   ```

3. Optionally, select a profile variant:

   ```powershell
   # For minimal profile
   . $PSScriptRoot\Profile\Variants\Profile-Minimal.ps1
   
   # For debug profile
   . $PSScriptRoot\Profile\Variants\Profile-Debug.ps1
   
   # For optimized profile
   . $PSScriptRoot\Profile\Variants\Profile-Optimized.ps1
   ```

## Requirements

- PowerShell 7+
- Windows Terminal (recommended)
- Git for Windows
- oh-my-posh
- Terminal-Icons module
- PSReadLine module
- ZLocation module

## Functions

Key function categories include:

- System utilities and diagnostics
- Network tools and troubleshooting
- Development helpers and environment setup
- Git workflow automation
- PowerShell profile management
- File system operations
- Windows administration
- Application management
- Security and defender management

Functions are organized in the following files:
- [`Profile/Functions/AdminTools.ps1`](Profile/Functions/AdminTools.ps1)
- [`Profile/Functions/Apps.ps1`](Profile/Functions/Apps.ps1)
- [`Profile/Functions/DialogTools.ps1`](Profile/Functions/DialogTools.ps1)
- [`Profile/Functions/Environment.ps1`](Profile/Functions/Environment.ps1)
- [`Profile/Functions/FileSystem.ps1`](Profile/Functions/FileSystem.ps1)
- [`Profile/Functions/HashingTools.ps1`](Profile/Functions/HashingTools.ps1)
- [`Profile/Functions/Navigation.ps1`](Profile/Functions/Navigation.ps1)
- [`Profile/Functions/ProfileTools.ps1`](Profile/Functions/ProfileTools.ps1)
- [`Profile/Functions/System.ps1`](Profile/Functions/System.ps1)

Additionally, specialized functions are available in the `Profile/Functions/Public/` directory.

## Modules

Common modules loaded by this profile:

- posh-git
- Terminal-Icons
- PSReadLine
- ZLocation
- oh-my-posh

Custom modules included in the repository:

- PSDefender - Windows Defender management utilities
- PSProfile - Profile management utilities
- PSSysInfo - System information utilities
- PSModuleManagement - PowerShell module management

Module loading is configured in [`Profile/Config/Modules.psd1`](Profile/Config/Modules.psd1) and implemented in [`Profile/Components/Modules.ps1`](Profile/Components/Modules.ps1).

## Profile Variants

The repository includes multiple profile variants for different scenarios:

- **Debug** ([`Profile/Variants/Profile-Debug.ps1`](Profile/Variants/Profile-Debug.ps1)): Enhanced logging and debugging information
- **Minimal** ([`Profile/Variants/Profile-Minimal.ps1`](Profile/Variants/Profile-Minimal.ps1)): Streamlined profile with only essential components
- **Optimized** ([`Profile/Variants/Profile-Optimized.ps1`](Profile/Variants/Profile-Optimized.ps1)): Performance-focused profile with lazy loading

## Profile Optimization

The profile has been optimized for faster loading and better environment detection:

- **Environment Detection**: Automatically detects and adapts to different PowerShell hosts (VSCode, regular console, ISE)
- **Performance Improvements**: Caches external resources like ModuleFast and zoxide initialization
- **VSCode Integration**: Custom prompt and environment-specific settings for VSCode
- **Conditional Loading**: Only loads components that are needed in the current environment
- **Lazy Loading**: Functions and modules are loaded on-demand to reduce startup time

### Performance Measurement

You can measure the profile loading performance by adding the `-Measure` parameter:

```powershell
. $PROFILE -Measure
```

This will display timing information for each component of the profile.

## Documentation

- **Profile Structure**: See [`Profile/README.md`](Profile/README.md) for detailed information about the profile structure
- **Optimization**: See [`Docs/Profile/Optimization/index.md`](Docs/Profile/Optimization/index.md) for detailed information about profile optimization
- **MkDocs**: Documentation is set up with MkDocs for easy browsing

## Testing

The repository includes comprehensive tests for various components:

- **Profile Tests**: Verify profile loading and functionality
- **Optimization Tests**: Test profile performance and optimization
- **System Tests**: Verify system configuration and dependencies

Run tests using the test runner:

```powershell
.\Tests\Invoke-Tests.ps1
```

## License

This project is licensed under the [Unlicense](LICENSE).
