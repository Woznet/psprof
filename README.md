# PowerShell Profile

My customized PowerShell Core profile configuration and scripts.

## Overview

This repository contains my PowerShell profile configuration organized into modular components:

- `profile.ps1` - Main profile that loads all components
- `Microsoft.PowerShell_profile.ps1` - Host-specific customizations
- `Profile/` - Core configuration modules:
  - `options.ps1` - PSReadLine and general options
  - `prompt.ps1` - oh-my-posh theme and prompt customization  
  - `functions.ps1` - Custom utility functions
  - `aliases.ps1` - Command aliases
  - `completion.ps1` - Tab completion configuration
  - `modules.ps1` - PowerShell module management

## Key Features

- Oh-my-posh theme integration
- Custom functions for common tasks
- Shell completion for popular tools
- Useful aliases and keyboard shortcuts
- Module management and synchronization

## Directory Structure

```
PowerShell/
├── Profile/           # Core configuration files
│   ├── aliases/       # Alias definitions
│   ├── completions/   # Tab completion scripts
│   └── functions/     # Utility functions
├── Scripts/           # Standalone PS scripts
└── profile.ps1        # Main profile entry point
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

See `Profile/functions.ps1` for the complete list.

## Modules

Common modules loaded by this profile:

- posh-git
- Terminal-Icons
- PSReadLine
- ZLocation
- oh-my-posh

Additional modules can be managed via the module sync functions.

## License

MIT License - See LICENSE file for details
