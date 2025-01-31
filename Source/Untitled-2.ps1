# ---------------------------------------------------------------------
# PowerShell Profile - Custom Functions
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Dynamic "ConsoleGridView" Functions
# ---------------------------------------------------------------------

Function Stop-SelectedProcess {
    <#
    .SYNOPSIS
        Stops a selected process from a dynamic list of running processes.
    .DESCRIPTION
        This utility function stops a selected process from a dynamic list of running processes.
    .EXAMPLE
        Stop-SelectedProcess
    .EXAMPLE
        Stop-SelectedProcess -Name 'notepad'
    .NOTES
        Author: Jimmy Briggs <
    #>
    #Requires -Module Microsoft.PowerShell.ConsoleGuiTools
    [CmdletBinding()]
    Param()

    Begin {
        $Processes = Get-Process | Select-Object -Property Id, Name, Description
    }

    Process {
        $Selection = $Processes | Out-ConsoleGridView -Title 'Select a Process to Stop' -OutputMode Multiple
        $Selection | ForEach-Object {
            if ($WhatIfPreference) {
                Write-Host "Stopping Process: $($_.Name) - ID: $($_.Id)" -ForegroundColor Yellow
            } else {
                Stop-Process -Id $_.Id -Force
            }
        }
    }

    End {

    }
}
Function Get-DynamicAboutHelp {
    <#
    .SYNOPSIS
        Displays a dynamic list of about topics and allows the user to select one to view.
    .DESCRIPTION
        This utility function displays a dynamic list of about topics and allows the user to select one to view.
    .EXAMPLE
        Get-DynamicAboutHelp
    .EXAMPLE
        Get-DynamicAboutHelp -Glob 'about*'
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>
    #Requires -Module Microsoft.PowerShell.ConsoleGuiTools
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]$Glob = 'about*'
    )

    Begin {
        $About = Get-Help -Name $Glob | Select-Object -Property Name, Synopsis
    }

    Process {
        $About | Out-ConsoleGridView -Title 'Select a Help Topic' -OutputMode Single | Get-Help
    }

    End {

    }
}

Function Start-GitKraken {
    <#
    .SYNOPSIS
        Starts GitKraken at the current Git Repository (or provided path).
    .DESCRIPTION
        This utility function starts the GitKraken Git Client Program, launching it under the present git repository's
        working directory by default (or provided path).
    .EXAMPLE
        Start-GitKraken
    .EXAMPLE
        Start-GitKraken -Path 'C:\Projects\MyProject'
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>
    [CmdletBinding()]
    [Alias('gitkraken', 'krak')]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$Path = (Get-Location).ProviderPath
    )

    Begin {

        $StartPath = (Get-Location).ProviderPath

        # Ensure Git Repository
        if (-not(Test-Path -Path "$StartPath\.git")) {
            Write-Warning 'Not a Git Repository. Aborting...'
            return
        }

        $GitKrakenExePath = Resolve-Path "$Env:LOCALAPPDATA\gitkraken\app-*\gitkraken.exe"

        # Ensure GitKraken
        if (-not(Test-Path -Path $GitKrakenExePath)) {
            Write-Warning 'GitKraken not found. Aborting...'
            return
        }

        # Latest GitKraken Version Only
        if ($GitKrakenExePath.Count -gt 1) {
            $GitKrakenExePath = $GitKrakenExePath[$GitKrakenExePath.Count - 1]
        }

        $LogFilePath = "$Env:TEMP\gitkrakenstart.log"
        Write-Verbose "GitKraken Startup Log File: $LogFilePath"

    }

    Process {
        Write-Host "Starting GitKraken at $StartPath..." -ForegroundColor Cyan
        Start-Process -FilePath $GitKrakenExePath -ArgumentList "--path $StartPath" -RedirectStandardOutput $LogFilePath
    }

}

Function Start-RStudio {
    <#
    .SYNOPSIS
        Starts RStudio IDE at the current working directory (or provided path).
    .DESCRIPTION
        This utility function starts the RStudio IDE, launching it under the working directory by default (or provided path).
    .EXAMPLE
        Start-RStudio
    .EXAMPLE
        Start-RStudio -Path 'C:\Projects\MyProject'
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>
    [CmdletBinding()]
    [Alias('rstudio')]
    Param(
        [Parameter(Mandatory = $false)]
        [String]$Path = (Get-Location).ProviderPath
    )

    Begin {

        $RprojFile = Get-ChildItem -Path $Path -Filter '*.Rproj' -File | Select-Object -First 1

        # If a *.Rproj file is in current wd use that:
        if ($RprojFile) {
            Write-Host "Found RStudio Project File: $($RprojFile.FullName)" -ForegroundColor Cyan
            Start-Process -FilePath $RprojFile.FullName
            return
        }

        # ensure absolute path
        $StartPath = $Path | Resolve-Path
        $ExePath = "$Env:PROGRAMFILES\RStudio\rstudio.exe" | Resolve-Path
        $LogPath = "$Env:TEMP\rstudiostart.log" | Resolve-Path
        Write-Verbose "RStudio Startup Log File: $LogPath"

        if (-not(Test-Path -Path $ExePath)) {
            Write-Warning 'RStudio not found. Aborting...'
            return
        }
    }

    Process {
        Write-Host "Starting RStudio at $StartPath..." -ForegroundColor Cyan
        Start-Process -FilePath $ExePath -ArgumentList $StartPath -RedirectStandardOutput $LogPath
    }
}

Function Get-ProcessUsingPort {
    <#
    .SYNOPSIS
        Get the process using a specific port.
    .DESCRIPTION
        This function gets the process using a specific port.
    .PARAMETER Port
        The port number.
    .EXAMPLE
        Get-ProcessUsingPort -Port 80

        # Get the process using port 80. Should return the "system" process.
    .LINK
        Get-Proccess
    .LINK
        Get-NetTCPConnection
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 65535)]
        [Int]$Port
    )

    Process {
        Get-Process -Id (Get-NetTCPConnection -LocalPort $Port).OwningProcess | Out-More
    }
}

Function Update-Environment {
    Refresh-Profile
    Refresh-Path
    Refresh-Module
    Refresh-Function
    Refresh-Alias
    Refresh-Variable

}
Function Invoke-ProfileReload {
    & $PROFILE
}

Function Get-PublicIP {
    (Invoke-WebRequest 'http://ifconfig.me/ip' ).Content
}

Function Get-Timestamp {
    Get-Date -Format u
}

Function Get-RandomPassword {
    $length = 16
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+'
    -join ((0..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

Function Update-WinGet {
    Params(
        [Switch]$Admin,
        [Switch]$Interactive
    )

    if (Get-PSResource -Name WingetTools -ErrorAction SilentlyContinue) {
        Import-Module WingetTools
    } else {
        Install-Module WingetTools -Force -SkipPublisherCheck
    }

    if ($Admin) {
    } else {
        winget upgrade --all
    }
}
Function Update-Chocolatey {}
Function Update-Scoop {}
Function Update-R {}
Function Update-Python {}

Function Update-Node {}

Function Update-Pip {}
Function Update-Windows {}

Function Mount-DevDrive {
    if (-not(Test-Path -Path 'X:\')) {

        if (Get-PSDrive -Name 'Dev' -ErrorAction SilentlyContinue) {
            Write-Host 'Mapped PSDrive for  DevDrive already exists. Aborting Mounting...' -ForegroundColor Yellow
            Return
        } else {

            $cmd = "sudo powershell.exe -Command 'Mount-VHD -Path I:\DevDrive\DevDrive.vhdx'"

            try {
                Write-Verbose 'Mounting DevDrive...'
                Invoke-Expression -Command $cmd
            } catch {
                Write-Warning 'Failed to mount DevDrive...'
            }

            Write-Verbose 'Creating DevDrive PSDrive...'
            New-PSDrive -Name 'Dev' -PSProvider FileSystem -Root 'X:\' -Scope Global
        }
    }
}

Function Set-LocationDesktop {
    Set-Location -Path "$env:USERPROFILE\Desktop"
}

Function Set-LocationDownloads {
    Set-Location -Path "$env:USERPROFILE\Downloads"
}

Function Set-LocationDocuments {
    Set-Location -Path "$env:USERPROFILE\Documents"
}

Function Set-LocationPictures {
    Set-Location -Path "$env:USERPROFILE\Pictures"
}

Function Set-LocationMusic {
    Set-Location -Path "$env:USERPROFILE\Music"
}

Function Set-LocationVideos {
    Set-Location -Path "$env:USERPROFILE\Videos"
}

Function Set-LocationDevDrive {
    Set-Location -Path 'Dev:'
}

Function cd... {
    Set-Location -Path '..\..'
}

Function cd.... {
    Set-Location -Path '..\..\..'
}

Function Get-MD5Hash { Get-FileHash -Algorithm MD5 $args }

Function Get-SHA1Hash { Get-FileHash -Algorithm SHA1 $args }

Function Get-SHA256Hash { Get-FileHash -Algorithm SHA256 $args }

Function Invoke-Notepad { notepad.exe $args }


# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

Function Invoke-Admin {
    if ($args.Count -gt 0) {
        $argList = "& '" + $args + "'"
        Start-Process "$PSHOME\pwsh.exe" -Verb runAs -ArgumentList $argList
    } else {
        Start-Process "$PSHOME\pwsh.exe" -Verb RunAs
    }
}

Function Edit-PSProfile {
    $cmd = "$Env:Editor $PROFILE.CurrentUserAllHosts"
    Invoke-Expression -Command $cmd
}

Function Edit-PSProfileProject {
    if (-not($ProfileRootPath)) {
        Write-Warning 'ProfileRootPath not found.'
        $Global:ProfileRootPath = Split-Path -Path $PROFILE -Parent
    }

    $cmd = "$Env:Editor $ProfileRootPath"
    Invoke-Expression -Command $cmd
}

Function Invoke-WingetUpdate {
    Import-Module WingetTools

}

Function Invoke-TakeOwnership {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$Path
    )

    $cmd = "sudo takeown /f '$Path' /r /d y"

    if ($WhatIfPreference) {
        Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
    } else {
        Invoke-Expression -Command $cmd
    }

}

Function Invoke-TakeOwnershipWindowsApps {
    sudo takeown /f "$Env:PROGRAMFILES\WindowsApps" /r /d y
}

Function Invoke-DISM {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [Switch]$RestoreHealth,
        [Parameter()]
        [Switch]$CheckHealth,
        [Parameter()]
        [Switch]$ScanHealth,
        [Parameter()]
        [Switch]$CleanupImage,
        [Parameter()]
        [Switch]$AnalyzeComponentStore
    )

    $cmd = 'sudo dism'
    $cmd += ' /Online'

    if ($RestoreHealth) {
        $cmd += ' /RestoreHealth'
    }

    if ($CheckHealth) {
        $cmd += ' /CheckHealth'
    }

    if ($ScanHealth) {
        $cmd += ' /ScanHealth'
    }

    if ($CleanupImage) {
        $cmd += ' /Cleanup-Image'
    }

    if ($AnalyzeComponentStore) {
        $cmd += ' /AnalyzeComponentStore'
    }

    Write-Host "DISM Command: $cmd" -ForegroundColor Cyan

    if ($WhatIfPreference) {
        Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
    } else {
        Invoke-Expression -Command $cmd
    }

}

Function Invoke-SFC {
    [CmdletBinding()]
    Param()

    $cmd = 'sudo sfc /scannow'

    Write-Host "SFC Command: $cmd" -ForegroundColor Cyan

    if ($WhatIfPreference) {
        Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
    } else {
        Invoke-Expression -Command $cmd
    }

    Write-Host 'SFC Scan Complete.' -ForegroundColor Green

    $SFCLogPath = "$Env:WinDir\Logs\CBS\CBS.log"
    if (Test-Path -Path $SFCLogPath) {
        Write-Host "Review log file at: $SFCLogPath" -ForegroundColor Cyan
    }
}

Function Get-SFCLogs {
    $SFCLogPath = "$Env:WinDir\Logs\CBS\CBS.log"
    if (Test-Path -Path $SFCLogPath) {
        Get-Content -Path $SFCLogPath
    } else {
        Write-Warning 'SFC Log file not found.'
    }
}

Function Invoke-CheckDisk {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$Path = 'C:'
    )

    $cmd = "sudo chkdsk $Path /f /r"

    if ($WhatIfPreference) {
        Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
    } else {
        Invoke-Expression -Command $cmd
    }
}

Function Get-WinSAT {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [Switch]$Formal
    )

    if ($Formal) {
        $cmd = "sudo winsat formal"
    } else {
        $cmd = "sudo Get-CimInstance Win32_WinSat"
    }

    Write-Host "WinSAT Command: $cmd" -ForegroundColor Cyan

    if ($WhatIfPreference) {
        Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
    } else {
        Invoke-Expression -Command $cmd
    }

}


# Get-ProfileFunctions: Lists all custom functions in the current PowerShell profile.

Function Get-PSProfileFunctions {
    <#
        .SYNOPSIS
            Lists all custom functions in the current PowerShell profile.
        .DESCRIPTION
            Lists all custom functions in the current PowerShell profile.
        .EXAMPLE
            Get-ProfileFunctions
        .NOTES
            Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>

    $Functions = @(

        [PSCustomObject]@{
            Name        = 'Get-PSProfileFunctions'
            Description = 'Lists all custom functions in the current PowerShell profile.'
            Alias       = 'psprofilefunctions'
        }

        [PSCustomObject]@{
            Name        = 'Get-PSProfileModules'
            Description = 'Lists all loaded modules in the current PowerShell profile.'
            Alias       = 'psprofilemodules'
        }

        [PSCustomObject]@{
            Name        = 'Update-Environment'
            Description = 'Updates the current environment.'
            Alias       = 'refreshenv'
        }

        [PSCustomObject]@{
            Name        = 'Invoke-ProfileReload'
            Description = 'Reloads the current PowerShell profile.'
            Alias       = 'reloadpsprofile'
        }

        [PSCustomObject]@{
            Name        = 'Get-PublicIP'
            Description = 'Gets the public IP address of the current machine.'
            Alias       = 'publicip'
        }

        [PSCustomObject]@{
            Name        = 'Get-Timestamp'
            Description = 'Gets the current timestamp.'
            Alias       = 'timestamp'
        }

        [PSCustomObject]@{
            Name        = 'Get-RandomPassword'
            Description = 'Generates a random password.'
            Alias       = 'randompassword'
        }

        [PSCustomObject]@{
            Name        = 'Update-WinGet'
            Description = 'Updates the Windows Package Manager (WinGet).'
            Alias       = 'updatewinget'
        }

        [PSCustomObject]@{
            Name        = 'Update-Chocolatey'
            Description = 'Updates the Chocolatey Package Manager.'
            Alias       = 'updatechoco'
        }

        [PSCustomObject]@{
            Name        = 'Update-Scoop'
            Description = 'Updates the Scoop Package Manager.'
            Alias       = 'updatescoop'
        }

        [PSCustomObject]@{
            Name        = 'Update-R'
            Description = 'Updates the R Programming Language.'
            Alias       = 'updater'
        }

        [PSCustomObject]@{
            Name        = 'Update-Python'
            Description = 'Updates the Python Programming Language.'
            Alias       = 'updatepython'
        }

        [PSCustomObject]@{
            Name        = 'Update-Node'
            Description = 'Updates the Node.js JavaScript Runtime.'
            Alias       = 'updatenode'
        }

    )

    Write-Host 'PowerShell Profile Custom Functions:' -ForegroundColor Cyan

    $Functions | Format-Table -AutoSize