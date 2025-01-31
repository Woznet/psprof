# ---------------------------------------------------------------------
# PowerShell Profile - Custom Functions
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# Dynamic "ConsoleGridView" Functions
# ---------------------------------------------------------------------










Function Update-Environment {
    try {
        Refresh-Profile
        Refresh-Path
        Refresh-Module
        Refresh-Function
        Refresh-Alias
        Refresh-Variable
    } catch {
        Write-Error "Failed to update environment: $_"
    }
}
Function Invoke-ProfileReload {
    try {
        & $PROFILE
    } catch {
        Write-Error "Failed to reload profile: $_"
    }
}

Function Get-PublicIP {
    try {
        (Invoke-WebRequest 'http://ifconfig.me/ip' ).Content
    } catch {
        Write-Error "Failed to get public IP: $_"
    }
}

Function Get-Timestamp {
    Get-Date -Format u
}

Function Get-RandomPassword {
    try {
        $length = 16
        $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+'
        -join ((0..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    } catch {
        Write-Error "Failed to generate random password: $_"
    }
}

Function Update-WinGet {
    Params(
        [Switch]$Admin,
        [Switch]$Interactive
    )

    try {
        if (Get-PSResource -Name WingetTools -ErrorAction SilentlyContinue) {
            Import-Module WingetTools
        } else {
            Install-Module WingetTools -Force -SkipPublisherCheck
        }

        if ($Admin) {
        } else {
            winget upgrade --all
        }
    } catch {
        Write-Error "Failed to update WinGet: $_"
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
    try {
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
    } catch {
        Write-Error "Failed to mount DevDrive: $_"
    }
}

Function Set-LocationDesktop {
    try {
        Set-Location -Path "$env:USERPROFILE\Desktop"
    } catch {
        Write-Error "Failed to set location to Desktop: $_"
    }
}

Function Set-LocationDownloads {
    try {
        Set-Location -Path "$env:USERPROFILE\Downloads"
    } catch {
        Write-Error "Failed to set location to Downloads: $_"
    }
}

Function Set-LocationDocuments {
    try {
        Set-Location -Path "$env:USERPROFILE\Documents"
    } catch {
        Write-Error "Failed to set location to Documents: $_"
    }
}

Function Set-LocationPictures {
    try {
        Set-Location -Path "$env:USERPROFILE\Pictures"
    } catch {
        Write-Error "Failed to set location to Pictures: $_"
    }
}

Function Set-LocationMusic {
    try {
        Set-Location -Path "$env:USERPROFILE\Music"
    } catch {
        Write-Error "Failed to set location to Music: $_"
    }
}

Function Set-LocationVideos {
    try {
        Set-Location -Path "$env:USERPROFILE\Videos"
    } catch {
        Write-Error "Failed to set location to Videos: $_"
    }
}

Function Set-LocationDevDrive {
    try {
        Set-Location -Path 'Dev:'
    } catch {
        Write-Error "Failed to set location to DevDrive: $_"
    }
}

Function cd... {
    try {
        Set-Location -Path '..\..'
    } catch {
        Write-Error "Failed to change directory: $_"
    }
}

Function cd.... {
    try {
        Set-Location -Path '..\..\..'
    } catch {
        Write-Error "Failed to change directory: $_"
    }
}

Function Get-MD5Hash {
    try {
        Get-FileHash -Algorithm MD5 $args
    } catch {
        Write-Error "Failed to get MD5 hash: $_"
    }
}

Function Get-SHA1Hash {
    try {
        Get-FileHash -Algorithm SHA1 $args
    } catch {
        Write-Error "Failed to get SHA1 hash: $_"
    }
}

Function Get-SHA256Hash {
    try {
        Get-FileHash -Algorithm SHA256 $args
    } catch {
        Write-Error "Failed to get SHA256 hash: $_"
    }
}

Function Invoke-Notepad {
    try {
        notepad.exe $args
    } catch {
        Write-Error "Failed to invoke Notepad: $_"
    }
}


# Drive shortcuts
function HKLM: {
    try {
        Set-Location HKLM:
    } catch {
        Write-Error "Failed to set location to HKLM: $_"
    }
}
function HKCU: {
    try {
        Set-Location HKCU:
    } catch {
        Write-Error "Failed to set location to HKCU: $_"
    }
}
function Env: {
    try {
        Set-Location Env:
    } catch {
        Write-Error "Failed to set location to Env: $_"
    }
}

Function Invoke-Admin {
    try {
        if ($args.Count -gt 0) {
            $argList = "& '" + $args + "'"
            Start-Process "$PSHOME\pwsh.exe" -Verb runAs -ArgumentList $argList
        } else {
            Start-Process "$PSHOME\pwsh.exe" -Verb RunAs
        }
    } catch {
        Write-Error "Failed to invoke admin: $_"
    }
}

Function Edit-PSProfile {
    try {
        $cmd = "$Env:Editor $PROFILE.CurrentUserAllHosts"
        Invoke-Expression -Command $cmd
    } catch {
        Write-Error "Failed to edit PS profile: $_"
    }
}

Function Edit-PSProfileProject {
    try {
        if (-not($ProfileRootPath)) {
            Write-Warning 'ProfileRootPath not found.'
            $Global:ProfileRootPath = Split-Path -Path $PROFILE -Parent
        }

        $cmd = "$Env:Editor $ProfileRootPath"
        Invoke-Expression -Command $cmd
    } catch {
        Write-Error "Failed to edit PS profile project: $_"
    }
}

Function Invoke-WingetUpdate {
    try {
        Import-Module WingetTools
    } catch {
        Write-Error "Failed to invoke Winget update: $_"
    }
}

Function Invoke-TakeOwnership {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$Path
    )

    try {
        $cmd = "sudo takeown /f '$Path' /r /d y"

        if ($WhatIfPreference) {
            Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
        } else {
            Invoke-Expression -Command $cmd
        }
    } catch {
        Write-Error "Failed to take ownership: $_"
    }
}

Function Invoke-TakeOwnershipWindowsApps {
    try {
        sudo takeown /f "$Env:PROGRAMFILES\WindowsApps" /r /d y
    } catch {
        Write-Error "Failed to take ownership of WindowsApps: $_"
    }
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

    try {
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
    } catch {
        Write-Error "Failed to invoke DISM: $_"
    }
}

Function Invoke-SFC {
    [CmdletBinding()]
    Param()

    try {
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
    } catch {
        Write-Error "Failed to invoke SFC: $_"
    }
}

Function Get-SFCLogs {
    try {
        $SFCLogPath = "$Env:WinDir\Logs\CBS\CBS.log"
        if (Test-Path -Path $SFCLogPath) {
            Get-Content -Path $SFCLogPath
        } else {
            Write-Warning 'SFC Log file not found.'
        }
    } catch {
        Write-Error "Failed to get SFC logs: $_"
    }
}

Function Invoke-CheckDisk {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$Path = 'C:'
    )

    try {
        $cmd = "sudo chkdsk $Path /f /r"

        if ($WhatIfPreference) {
            Write-Host "WhatIf: $cmd" -ForegroundColor Yellow
        } else {
            Invoke-Expression -Command $cmd
        }
    } catch {
        Write-Error "Failed to invoke CheckDisk: $_"
    }
}

Function Get-WinSAT {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [Switch]$Formal
    )

    try {
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
    } catch {
        Write-Error "Failed to get WinSAT: $_"
    }
}


function Get-Folder {
    <#
    .SYNOPSIS
        Gets a filename through the native OpenFileDialog. Can select a single file or multiple files.
    .DESCRIPTION
        Gets a filename through the native OpenFileDialog. Can select a single file
        or multiple files. If user clicks 'OK' an [array] is returned, otherwise returns
        a $null if the dialog is canceled.
    .PARAMETER InitialDirectory
        The directory for the OpenFileDialog to start in. Defaults to $pwd.
        Aliased to 'Path'.
    .PARAMETER MultiSelect
        Determines if you can select one or multiple files. Defaults to $false.
        Aliased to 'Multi'.
    .PARAMETER Filter
        A character string delimited with pipe '|' character. Each 'token' in the string follows the form
        'Description|FileSpec'. Multiple 'tokens' can be in the string and they too are separated
        by the pipe character. Defaults to 'All files|*.*'.
    .EXAMPLE
        PS C:\> $File = Get-FileName
        Will present a fileopen dialog box where only a single file can be selected and the fileopen
        dialog box will start in the current directory. Assigns selected file to the 'File' variable.
    .EXAMPLE
        PS C:\> $File = Get-FileName -MultiSelect -Filter 'Powershell files|*.ps1|All files|*.*'
        Will present a fileopen dialog box where multiple files can be selected and the fileopen
        dialog box will start in the current directory. There will be a drop down list box in lower right
        where the user can select 'Powershell files' or 'All files' and the files listed will change.
        Assigns selected file(s) to the 'File' variable.
    .EXAMPLE
        PS C:\> $File = Get-FileName -MultiSelect -InitialDirectory 'C:\Temp'
        Will present a fileopen dialog box where multiple files can be selected and the fileopen
        dialog box will start in the C:\Temp directory. Assigns selected file(s) to the 'File' variable.
    .EXAMPLE
        PS C:\> Get-FileName | get-childitem
        Pipes selected filename to the get-childitem cmdlet.
    .INPUTS
        None are required, but you can use parameters to control behavior.
    .OUTPUTS
        [array] If user selects file(s) and clicks 'OK'. Will return an array with a .Count
                    and each element in the array will be the file(s) selected
        $null If the user clicks 'Cancel'.
    .NOTES
        Inspiration: Part of the ISEColorThemeCmdlets.ps1 Script by Jeff Pollock
                    http://gallery.technet.microsoft.com/ISE-Color-Theme-Cmdlets-24905f9e
        Changes: Added parameter for MultiSelect of files. Forced function to always return an array. Filter is
                    now a parameter that can be specified to control behavior. Changed InitialDirectory to default
                    to $pwd and to give an alias of 'Path' which is commonly used parameter name.
                    Also changed syntax to Add-Type -AssemblyName to conform with
                    Powershell 2+ and to be more "Powershelly".

        # Source: https://gallery.technet.microsoft.com/ISE-Color-Theme-Cmdlets-24905f9e
        # get-help about_ISE-Color-Theme-Cmdlets for more information
    #>
    [CmdletBinding(ConfirmImpact = 'None')]
    [OutputType([String[]])]
    Param(
        [Alias('InitialDirectory', 'RootFolder')]
        [String]$Path = "$pwd",
        [Switch]$NoNewFolder,
        [Alias('Description')]
        [String]$Title
    )

    Begin {
        Write-Verbose -Message "Starting [$($MyInvocation.Mycommand)]"
    }

    Process {
        try {
            Add-Type -AssemblyName System.Windows.Forms

            $FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
            $FolderBrowserDialog.RootFolder = 'MyComputer'
            $FolderBrowserDialog.SelectedPath = $Path
            if ($NoNewFolder) { $FolderBrowserDialog.ShowNewFolderButton = $false }
            if ($Title) { $FolderBrowserDialog.Description = $Title }

            $Result = $FolderBrowserDialog.ShowDialog()

            # needed to play around to force PowerShell to return an array.
            if ($Result -eq 'OK') {
                [array] $ReturnArray = $FolderBrowserDialog.SelectedPath
                Write-Output -InputObject (, $ReturnArray)
            }
        } catch {
            Write-Error "Failed to get folder: $_"
        }
    }

    End {
        Write-Verbose -Message "Ending [$($MyInvocation.Mycommand)]"
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

    try {
        # Get all functions declared under the $ProfileSourcePath directory:
        $PSProfileFiles = Get-ChildItem -Path "$ProfileSourcePath\*.ps1" |
            Select-Object -ExpandProperty FullName |
                Convert-Path

        $PSProfileFunctions = @()

        ForEach ($PSProfileFile in $PSProfileFiles) {
            $PSProfileFunctions += (Get-Command -Name $PSProfileFile).ScriptBlock.Ast.FindAll(
                { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] },
                $false
            ).Name
        }

        Write-Host "Discovered $($PSProfileFunctions.Count) Functions Declared by the PowerShell Profile: $PROFILE" -ForegroundColor Cyan

        $Functions = @()

        ForEach ($Function in $PSProfileFunctions) {

            $FunctionName = $Function.Name
            $FunctionDescription = $Function | Get-HelpPreview
            $FunctionAlias = $Function.GetAlias()

            $FunctionObject = [PSCustomObject]@{
                Name        = $FunctionName
                Description = $FunctionDescription
                Alias       = $FunctionAlias
            }

            $Functions += $FunctionObject

        }

        $Functions | Sort-Object -Property Name
    } catch {
        Write-Error "Failed to get PS profile functions: $_"
    }
}


# [PSCustomObject]@{
#     Name        = 'Get-PSProfileFunctions'
#     Description = 'Lists all custom functions in the current PowerShell profile.'
#     Alias       = 'psprofilefunctions'
# }
