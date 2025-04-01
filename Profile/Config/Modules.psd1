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
            Name = 'ZLocation'
            AutoInstall = $false
            PostImport = 'Write-Host -Foreground Green "`n[ZLocation] knows about $((Get-ZLocation).Keys.Count) locations.`n"'
        }
    )
}
