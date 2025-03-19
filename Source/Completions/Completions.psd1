<#
    .SYNOPSIS
        Command-to-Script Mapping Hash Table.
    .DESCRIPTION
        This PowerShell Data File (.psd1) contains the necessary mappings which map commands and programs to their
        corresponding shell completion scripts or modules.

        It is used in order to implement a lazy-loading mechanism for importing completion scripts.
    .NOTES
        - The key is the command name.
        - The value is the path to the completion script or module.
        
        Tools with names different than their commands:
            - `gh copilot` is the command for GitHub Copilot, but the command is `gh copilot`.
            - 1Password CLI uses `op` as its CLI command.
            - `s` is the command for `s-search`.
        
#>

$CompletionScripts = @{
    'aws' = "$PSScriptRoot\aws.completion.ps1"
    'choco' = "$PSScriptRoot\choco.completion.ps1"
    'docker' = "$PSScriptRoot\docker.completion.ps1"
    'dotnet' = "$PSScriptRoot\dotnet.completion.ps1"
    'envio' = "$PSScriptRoot\envio.completion.ps1"
    'ffsend' = "$PSScriptRoot\ffsend.completion.ps1"
    'gh' = "$PSScriptRoot\gh.completion.ps1"
    'gh copilot' = "$PSScriptRoot\gh-copilot.completion.ps1"
    'git' = "$PSScriptRoot\git.completion.ps1"
    'git-cliff' = "$PSScriptRoot\git-cliff.completion.ps1"
    'obsidian-cli' = "$PSScriptRoot\obsidian-cli.completion.ps1"
    'oh-my-posh' = "$PSScriptRoot\oh-my-posh.completion.ps1"
    'rclone' = "$PSScriptRoot\rclone.completion.ps1"
    'rig' = "$PSScriptRoot\rig.completion.ps1"
    'rustup' = "$PSScriptRoot\rustup.completion.ps1"
    's' = "$PSScriptRoot\s-search.completion.ps1"
    'scoop' = "$PSScriptRoot\scoop.completion.ps1"
    'spt' = "$PSScriptRoot\spotify-cli.completion.ps1"
    'yq' = "$PSScriptRoot\yq.completion.ps1"
}

$CompletionScripts = @{
    'aws'          = "$ProfileSourcePath\Source\Completions\aws.completion.ps1"
    'choco'        = "$ProfileSourcePath\Source\Completions\choco.completion.ps1"
    'docker'       = "$ProfileSourcePath\Source\Completions\docker.completion.ps1"
    'dotnet'       = "$ProfileSourcePath\Source\Completions\dotnet.completion.ps1"
    'envio'        = "$ProfileSourcePath\Source\Completions\envio.completion.ps1"
    'ffsend'       = "$ProfileSourcePath\Source\Completions\ffsend.completion.ps1"
    'gh'           = "$ProfileSourcePath\Source\Completions\gh.completion.ps1"
    'gh copilot'   = "$ProfileSourcePath\Source\Completions\gh-copilot.completion.ps1"
    'git'          = "$ProfileSourcePath\Source\Completions\git.completion.ps1"
    'git-cliff'    = "$ProfileSourcePath\Source\Completions\git-cliff.completion.ps1"
    'obsidian-cli' = "$ProfileSourcePath\Source\Completions\obsidian-cli.completion.ps1"
    'oh-my-posh'   = "$ProfileSourcePath\Source\Completions\oh-my-posh.completion.ps1"
    'rclone'       = "$ProfileSourcePath\Source\Completions\rclone.completion.ps1"
    'rig'          = "$ProfileSourcePath\Source\Completions\rig.completion.ps1"
    'rustup'       = "$ProfileSourcePath\Source\Completions\rustup.completion.ps1"
    's'            = "$ProfileSourcePath\Source\Completions\s-search.completion.ps1"
    'scoop'        = "$ProfileSourcePath\Source\Completions\scoop.completion.ps1"
    'spt'          = "$ProfileSourcePath\Source\Completions\spotify-cli.completion.ps1"
    'yq'           = "$ProfileSourcePath\Source\Completions\yq.completion.ps1"
}

$ProfileSourcePath