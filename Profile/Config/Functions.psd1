@{
    # Function categories to load
    Categories = @(
        'Environment'
        'Navigation'
        'System'
        'FileSystem'
        'AdminTools'
        'HashingTools'
        'ProfileTools'
        'DialogTools'
        'Apps'
    )

    # Individual functions to load
    Functions = @(
        @{
            Name = 'Start-GitKraken'
            Path = 'Profile/Functions/Public/Start-GitKraken.ps1'
            Enabled = $true
        },
        @{
            Name = 'Get-PCInfo'
            Path = 'Profile/Functions/Public/Get-PCInfo.ps1'
            Enabled = $true
        },
        @{
            Name = 'Get-PCUptime'
            Path = 'Profile/Functions/Public/Get-PCUptime.ps1'
            Enabled = $true
        },
        @{
            Name    = 'Update-WinGet'
            Path    = 'Profile/Functions/Public/Update-WinGet.ps1'
            Enabled = $true
        },
        @{
            Name    = 'Update-PSModules'
            Path    = 'Profile/Functions/Public/Update-PSModules.ps1'
            Enabled = $true
        },
        @{
            Name    = 'Update-AllPSResources'
            Path    = 'Profile/Functions/Public/Update-AllPSResources.ps1'
            Enabled = $true
        }
    )

    # Function settings
    Settings = @{
        # Enable or disable function loading
        DisableFunctions = $false

        # Enable or disable verbose output
        VerboseOutput = $false
    }
}
