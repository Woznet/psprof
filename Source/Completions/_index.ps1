

$CompletionScripts = @{
    'aws'          = "$PSScriptRoot\aws.completion.ps1"
    'choco'        = "$PSScriptRoot\choco.completion.ps1"
    'docker'       = "$PSScriptRoot\docker.completion.ps1"
    'dotnet'       = "$PSScriptRoot\dotnet.completion.ps1"
    'envio'        = "$PSScriptRoot\envio.completion.ps1"
    'ffsend'       = "$PSScriptRoot\ffsend.completion.ps1"
    'gh'           = "$PSScriptRoot\gh.completion.ps1"
    'gh copilot'   = "$PSScriptRoot\gh-copilot.completion.ps1"
    'git'          = "$PSScriptRoot\git.completion.ps1"
    'git-cliff'    = "$PSScriptRoot\git-cliff.completion.ps1"
    'obsidian-cli' = "$PSScriptRoot\obsidian-cli.completion.ps1"
    'oh-my-posh'   = "$PSScriptRoot\oh-my-posh.completion.ps1"
    'rclone'       = "$PSScriptRoot\rclone.completion.ps1"
    'rig'          = "$PSScriptRoot\rig.completion.ps1"
    'rustup'       = "$PSScriptRoot\rustup.completion.ps1"
    's'            = "$PSScriptRoot\s-search.completion.ps1"
    'scoop'        = "$PSScriptRoot\scoop.completion.ps1"
    'spt'          = "$PSScriptRoot\spotify-cli.completion.ps1"
    'yq'           = "$PSScriptRoot\yq.completion.ps1"
}

# Implement a Lazy Loading Function for the Completion Scripts that utilizes the `$CompletionScripts` hash table.

Function Import-LazyCompletion {
    <#
    .SYNOPSIS
        Load the completion script for the specified command.
    .DESCRIPTION
        This function loads the completion script for the specified command by dot-sourcing the script file.

        The function checks if the completion script for the specified command exists in the `$CompletionScripts` hash
        table and if it has not already been loaded. If both conditions are met, the function dot-sources the completion
        script defined in the hash table and sets the `$Script:CompletionLoaded` hash table entry for the specified
        command to `$true` (for the current session).
        
        This function is used to implement a lazy-loading mechanism for importing completion scripts.

    .PARAMETER CommandName
        The name of the command for which to load the completion script. This parameter is mandatory and accepts input
        from the pipeline. The value of this parameter is validated against the keys in the `$CompletionScripts` hash
        table defined in the `Completions.psd1` file.

    .EXAMPLE
        # Load the completion script for the `aws` command.
        Load-Completion -CommandName 'aws'        
    #>
    [CmdletBinding(
        SupportsShouldProcess = $false,
        ConfirmImpact = 'None'
    )]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateScript({$CompletionScripts.ContainsKey($_)})]
        [String]$CommandName
    )

    If ($CompletionScripts.ContainsKey($CommandName) -and -not $Script:CompletionLoaded[$CommandName]) {
        . $CompletionScripts[$CommandName]
        $Script:CompletionLoaded[$CommandName] = $true
    }

}