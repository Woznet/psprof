# PowerShell Profile Structure

This directory contains a modular PowerShell profile structure that leverages PSD1 files for configuration and PS1 files for implementation.

## Directory Structure

```plaintext
Profile/
├── Aliases/              # Alias definition files
├── Components/           # Component loaders
│   ├── Aliases.ps1       # Loads aliases from configuration
│   ├── Completions.ps1   # Loads completions
│   ├── DefaultParams.ps1 # Sets default parameters
│   ├── Functions.ps1     # Loads functions
│   ├── Modules.ps1       # Imports modules
│   ├── Prompt.ps1        # Configures prompt
│   ├── PSReadLine.ps1    # Configures PSReadLine
│   ├── Style.ps1         # Configures styling
│   └── Extras.ps1        # Loads extra integrations
├── Completions/          # Completion scripts
├── Config/               # Configuration data files (PSD1)
│   ├── Aliases.psd1      # Alias configuration
│   ├── Completions.psd1  # Completions configuration
│   ├── DefaultParams.psd1 # Default parameters configuration
│   ├── Functions.psd1    # Function categories configuration
│   ├── Modules.psd1      # Module import configuration
│   ├── Prompt.psd1       # Prompt configuration
│   ├── PSReadLine.psd1   # PSReadLine configuration
│   ├── Style.psd1        # Style configuration
│   └── Extras.psd1       # Extra integrations configuration
├── Functions/            # Function definition files
│   ├── Private/          # Private functions
│   └── Public/           # Public functions
├── Variants/             # Profile variants
└── Profile.Configuration.psd1 # Main configuration file
└── Profile.ps1           # Main loader
```

## How It Works

1. The main `Profile.ps1` file in the root directory loads the `Profile/Profile.ps1` file.
2. `Profile/Profile.ps1` loads the `Profile.Configuration.psd1` file to get configuration settings.
3. Based on the configuration, it loads the components in the specified order.
4. Each component loads its corresponding configuration from the `Config/` directory.

## Configuration

The main configuration file is `Profile.Configuration.psd1`, which contains:

- PowerShell version requirements
- Feature flags
- Environment-specific settings
- Component configurations
- Import order

Each component has its own configuration file in the `Config/` directory, which contains settings specific to that component.

## Adding New Components

To add a new component:

1. Create a new PSD1 file in the `Config/` directory.
2. Create a new PS1 file in the `Components/` directory.
3. Add the component to the `ImportOrder` array in `Profile.Configuration.psd1`.

## Variants

The `Variants/` directory contains different profile variants that can be used in different scenarios:

- `Profile-Debug.ps1`: Debug version with additional logging
- `Profile-Minimal.ps1`: Minimal version with only essential components
- `Profile-Optimized.ps1`: Optimized version for performance
