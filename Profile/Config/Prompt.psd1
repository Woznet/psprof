@{
    # Environment-specific settings
    Environments = @{
        # Console (regular PowerShell)
        Console = @{
            UseOhMyPosh = $true
        }

        # Visual Studio Code
        VSCode = @{
            UseOhMyPosh = $false
            UseCustomPrompt = $true
        }

        # PowerShell ISE
        ISE = @{
            UseOhMyPosh = $false
        }
    }

    # Oh-My-Posh configuration
    OhMyPosh = @{
        Enabled = $true
        ThemePath = '$Env:POSH_THEMES_PATH\wopian.omp.json'
    }

    # VSCode custom prompt settings
    VSCode = @{
        UseCustomPrompt = $true
        ShowGitBranch = $true
        ShowAdminStatus = $true
        ShowPSVersion = $true
    }
}
