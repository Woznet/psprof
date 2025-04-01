@{
    # PowerShell version requirement
    PowerShellVersion = '7.5.0'

    # Import order for components
    ImportOrder       = @(
        'DefaultParams'
        'Aliases'
        'Functions'
        'Modules'
        'PSReadLine'
        'Style'
        'Completions'
        'Prompt'
        'Extras'
    )

    # Feature flags
    Features          = @{
        # Enable or disable debug logging
        DebugLogging       = $true

        # Enable or disable performance measurement
        MeasurePerformance = $true

        # Enable or disable verbose output
        VerboseOutput      = $true
    }

    # Environment-specific settings
    Environments      = @{
        # Visual Studio Code
        VSCode  = @{
            # Enable or disable specific components in VSCode
            DisableComponents = @()
        }

        # PowerShell ISE
        ISE     = @{
            # Enable or disable specific components in ISE
            DisableComponents = @('Prompt')
        }

        # Regular PowerShell console
        Console = @{
            # Enable or disable specific components in console
            DisableComponents = @()
        }
    }
}
