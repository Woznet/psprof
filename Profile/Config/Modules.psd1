@{
    # Module paths to add to PSModulePath
    Paths = @(
        @{
            Path = '$env:LOCALAPPDATA\PowerShell\Modules'
            Enabled = $true
            Platform = 'Windows'
        }
    )

    # Essential modules that should always be loaded
    Essential = @(
        'PSReadLine'
        'posh-git'
        'Terminal-Icons'
        'CompletionPredictor'
    )

    # Optional modules that can be loaded if available
    Optional = @(
        @{
            Name = 'Microsoft.PowerShell.ConsoleGuiTools'
            AutoInstall = $false
        },
        @{
            Name = 'F7History'
            AutoInstall = $false
        },
        @{
            Name = 'PoshCodex'
            AutoInstall = $false
        },
        @{
            Name        = 'zoxide'
            AutoInstall = $false
            PostImport  = 'Invoke-Expression (& { (zoxide init powershell | Out-String) })'
        }
    )
}
