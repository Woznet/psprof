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
        # Uncomment these when the completion scripts are available
        # 'docker' = 'Completions/docker.ps1'
        # 'git'    = 'Completions/git.ps1'
        # 'winget' = 'Completions/winget.ps1'
        # 'scoop'  = 'Completions/scoop.ps1'
        # 'gh'     = 'Completions/gh-cli.ps1'
    }
}
