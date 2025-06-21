@{
    # Path aliases
    PathAliases = @{
        'Desktop'   = 'Set-LocationDesktop'
        'Downloads' = 'Set-LocationDownloads'
        'Documents' = 'Set-LocationDocuments'
        'Pictures'  = 'Set-LocationPictures'
        'Music'     = 'Set-LocationMusic'
        'Videos'    = 'Set-LocationVideos'
        'DevDrive'  = 'Set-LocationDevDrive'
    }

    # Command aliases
    CommandAliases = @{
        'Get-AboutHelp' = 'Get-DynamicAboutHelp'
        'krak'          = 'Start-GitKraken'
        'rstudio'       = 'Start-RStudio'
    }

    # Settings
    Settings = @{
        # Enable or disable aliases
        DisableAliases = $false

        # Load aliases from files in the Aliases directory
        LoadFromFiles = $true
    }
}
