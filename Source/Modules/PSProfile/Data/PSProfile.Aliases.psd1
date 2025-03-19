<#
.SYNOPSIS
    Aliases for PSProfile.
#>

@{
    # General
    General     = @{
        'cls'   = 'Clear-Host'
        'pwd'   = 'Get-Location'
        'cd'    = 'Set-Location'
        'ls'    = 'Get-ChildItem'
        'rm'    = 'Remove-Item'
        'mv'    = 'Move-Item'
        'cp'    = 'Copy-Item'
        'type'  = 'Get-Content'
        'echo'  = 'Write-Output'
        'help'  = 'Get-Help'
        'touch' = 'New-Item'
        'mkdir' = 'New-Item -ItemType Directory'
    }

    # Apps
    Apps        = @{
        'np'    = 'notepad.exe'
        'expl'  = 'explorer.exe'
        'codee' = 'code-insiders'
    }

    # Development
    Development = @{
        'ib'       = 'Invoke-Build'
        'pester'   = 'Invoke-Pester'
        'psake'    = 'Invoke-psake'
        'psdeploy' = 'Invoke-PSDeploy'
        'reqs'     = 'Invoke-PSDepend'
        'reload'   = 'Restart-PSSession'
        'reboot'   = 'Restart-Computer'
    }

    Navigation  = @{
        '..'        = 'Set-ParentLocation'
        '...'       = 'Set-ParentLocation -Depth 2'
        '....'      = 'Set-ParentLocation -Depth 3'
        '.....'     = 'Set-ParentLocation -Depth 4'
        '......'    = 'Set-ParentLocation -Depth 5'
        '~'         = 'Set-Location $HOME'
        'desktop'   = 'Set-Location $HOME\Desktop'
        'documents' = 'Set-Location $HOME\Documents'
        'downloads' = 'Set-Location $HOME\Downloads'
        'dev'       = 'Set-Location $HOME\Dev'
        'dots'      = 'Set-Location $HOME\Dev'
        'tools'     = 'Set-Location $HOME\tools'
        'bin'       = 'Set-Location $HOME\bin'
        'onedrive'  = 'Set-Location "$HOME\OneDrive"'
        'wsldrive'  = 'Set-Location "\\wsl.localhost\"'
    }


    Networking  = @{
        'gpup' = 'Get-ProcessUsingPort'

    }
}
