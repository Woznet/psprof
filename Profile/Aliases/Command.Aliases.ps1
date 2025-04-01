@{
    # 'Alias' = 'Command'
    'help'    = 'Get-Help'
    'dynhelp' = 'Get-DynamicAboutHelp'
    'krak'    = 'gitkraken.cmd'
    'rstudio' = 'Start-RStudio'
    'codee'   = 'code-insiders.cmd'
    'expl'    = 'explorer.exe'
    'r'       = 'Rscript.bat'
    'rscript' = 'Rscript.bat'
}



Set-Alias -Name 'Desktop' -Value 'Set-LocationDesktop'
Set-Alias -Name 'Downloads' -Value 'Set-LocationDownloads'
Set-Alias -Name 'Documents' -Value 'Set-LocationDocuments'
Set-Alias -Name 'Pictures' -Value 'Set-LocationPictures'
Set-Alias -Name 'Music' -Value 'Set-LocationMusic'
Set-Alias -Name 'Videos' -Value 'Set-LocationVideos'
Set-Alias -Name 'DevDrive' -Value 'Set-LocationDevDrive'

Set-Alias -Name 'Get-AboutHelp' -Value 'Get-DynamicAboutHelp'

Set-Alias -Name 'krak' -Value 'Start-GitKraken'
Set-Alias -Name 'rstudio' -Value 'Start-RStudio'
