@{
    # General settings
    Settings = @{
        # Enable or disable completions
        DisableCompletions = $false

        # Enable or disable lazy loading of completions
        LazyLoad = $true
    }

    # Common commands to register for lazy loading
    # Format: CommandName = Path to completion script (relative to Profile root)
    CommonCommands = @{
        'docker' = 'Profile/Completions/docker.ps1'
        'git'    = 'Profile/Completions/git-cliff.ps1'
        'winget' = 'Profile/Completions/winget.ps1'
        'scoop'  = 'Profile/Completions/scoop.ps1'
        'gh'     = 'Profile/Completions/gh-cli.ps1'
        'aws'    = 'Profile/Completions/aws.ps1'
        'bat'    = 'Profile/Completions/bat.ps1'
        'choco'  = 'Profile/Completions/choco.ps1'
        'volta'  = 'Profile/Completions/volta.ps1'
    }
}
