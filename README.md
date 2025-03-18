# PowerShell Profile

My customized PowerShell Core profile configuration and scripts.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Directory Structure](#directory-structure)
- [Usage](#usage)
- [Requirements](#requirements)
- [Functions](#functions)
- [Modules](#modules)
- [Profile Optimization](#profile-optimization)
- [License](#license)

## Overview

This repository contains my PowerShell profile configuration organized into modular components:

- [`profile.ps1`](profile.ps1) - Main profile that loads all components
- [`Microsoft.PowerShell_profile.ps1`](Microsoft.PowerShell_profile.ps1) - Host-specific customizations
- [`Profile/`](Profile/) - Core configuration modules:
  - [`options.ps1`](Profile/options.ps1) - PSReadLine and general options
  - [`prompt.ps1`](Profile/prompt.ps1) - oh-my-posh theme and prompt customization  
  - [`functions.ps1`](Profile/functions.ps1) - Custom utility functions
  - [`aliases.ps1`](Profile/aliases.ps1) - Command aliases
  - [`completion.ps1`](Profile/completion.ps1) - Tab completion configuration
  - [`modules.ps1`](Profile/modules.ps1) - PowerShell module management

## Key Features

- Oh-my-posh theme integration
- Custom functions for common tasks
- Shell completion for popular tools
- Useful aliases and keyboard shortcuts
- Module management and synchronization

## Directory Structure

```
PowerShell/
├── Profile/                    # Core configuration files
│   ├── aliases/               # Alias definitions
│   │   ├── git.ps1           # Git-related aliases
│   │   ├── system.ps1        # System command aliases
│   │   └── tools.ps1         # Development tool aliases
│   ├── completions/           # Tab completion scripts
│   │   ├── git.ps1           # Git command completion
│   │   ├── docker.ps1        # Docker command completion
│   │   └── tools.ps1         # Tool-specific completions
│   ├── functions/            # Utility functions
│   │   ├── common.ps1        # General utility functions
│   │   ├── git.ps1          # Git helper functions
│   │   ├── network.ps1      # Network utility functions
│   │   └── profile.ps1      # Profile management functions
│   ├── options.ps1          # PSReadLine and shell options
│   ├── prompt.ps1           # Prompt theme configuration
│   ├── aliases.ps1          # Main aliases loader
│   ├── completion.ps1       # Completion configuration
│   ├── functions.ps1        # Functions loader
│   └── modules.ps1          # Module management
├── Scripts/                  # Standalone scripts
│   ├── backup.ps1           # Backup utilities
│   ├── install.ps1          # Profile installation
│   └── update.ps1           # Profile update script
├── Microsoft.PowerShell_profile.ps1  # Host-specific settings
└── profile.ps1              # Main profile entry point
```

## Usage

1. Clone this repository to your PowerShell profile location:

   ```powershell
   git clone https://github.com/username/powershell-profile.git $HOME\Documents\PowerShell
   ```

2. Reload your PowerShell profile:

   ```powershell
   . $PROFILE
   ```

## Requirements

- PowerShell 7+
- Windows Terminal (recommended)
- Git for Windows
- oh-my-posh

## Functions

Key function categories include:

- System utilities and diagnostics
- Network tools
- Development helpers
- Git workflow automation
- PowerShell profile management

See [`Profile/functions.ps1`](Profile/functions.ps1) for the complete list.

## Modules

Common modules loaded by this profile:

- posh-git
- Terminal-Icons
- PSReadLine
- ZLocation
- oh-my-posh

Additional modules can be managed via the module sync functions.

## Profile Optimization

The profile has been optimized for faster loading and better environment detection:

- **Environment Detection**: Automatically detects and adapts to different PowerShell hosts (VSCode, regular console, ISE)
- **Performance Improvements**: Caches external resources like ModuleFast and zoxide initialization
- **VSCode Integration**: Custom prompt and environment-specific settings for VSCode
- **Conditional Loading**: Only loads components that are needed in the current environment

### Documentation and Testing

- **Documentation**: See [Docs/Profile/Optimization](Docs/Profile/Optimization/index.md) for detailed information
- **Tests**: Run `Tests/Profile/Optimization/Test-ProfileOptimization.ps1` to verify the optimization

### Performance Measurement

You can measure the profile loading performance by adding the `-Measure` parameter:

```powershell
. $PROFILE -Measure
```

This will display timing information for each component of the profile.

## License

MIT License - See LICENSE file for details
