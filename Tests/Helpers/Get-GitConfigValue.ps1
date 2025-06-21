Function Get-GitConfigValue {
    <#
        .SYNOPSIS
            Gets a value from the global git config file.
        .DESCRIPTION
            This function gets a value from the global git config file.
        .PARAMETER Key
            The key to get the value for.
        .PARAMETER GitConfigPath
            The path to the git config file. Defaults to $HOME\.gitconfig.
        .EXAMPLE
            Get-GitConfigValue -Key 'user.email'
        .NOTES
            This function wraps the `git config --global --get` command.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$Key,
        [Parameter()]
        [String]$GitConfigPath = "$HOME\.gitconfig"
    )

    Begin {
        if (-not (Get-Command -Name 'git' -ErrorAction SilentlyContinue)) {
            Write-Error "Git is not installed. Please install Git and try again."
            return
        }
        $Cmd = "& git config --global --get $Key"
    }

    Process {
        $Out = Invoke-Expression -Command $Cmd
    }

    End {
        Write-Host "Value for $Key = $Out" -ForegroundColor Green
        return $Out
    }
}
