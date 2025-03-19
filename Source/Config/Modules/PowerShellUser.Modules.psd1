<#
    .SYNOPSIS
        PowerShell (Core) Modules Data Configuration File
    .DESCRIPTION
        This file is used as both reference as well as for managing and maintaining a library of installed
        PowerShell modules. This file is used to define the modules that are installed and available for use
        in the current environment for the current user.
    .NOTES
        File Name      : PowerShell.Modules.psd1
        Author         : Jimmy Briggs
        Prerequisites  : PowerShell Core Version 7+ and the Microsoft.PowerShell.PSResourceGet Module
    .LINK
        https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.psresourceget/about/about_psresourceget
#>

@{
    'Az.Tools.Predictor'                    = @{}
    'Benchpress'                            = @{}
    'BuildHelpers'                          = @{}
    'BurntToast'                            = @{
        PreRelease = $true
    }
    'CompletionPredictor'                   = @{}
    'ComputerCleanup'                       = @{}
    'Configuration'                         = @{}
    'DataMashup'                            = @{
        PreRelease = $true
    }
    'DesktopManager'                        = @{}
    'DockerCompletion'                      = @{}
    'EZOut'                                 = @{}
    'F7History'                             = @{}
    'Firewall-Manager'                      = @{}
    'FormatMarkdownTable'                   = @{}
    'Hcl2PS'                                = @{}
    'HelpOut'                               = @{}
    'ImportExcel'                           = @{}
    'InvokeBuild'                           = @{}
    'jwtPS'                                 = @{}
    'Metadata'                              = @{}
    'Microsoft.PowerShell.ConsoleGuiTools'  = @{}
    'Microsoft.PowerShell.Crescendo'        = @{}
    'Microsoft.PowerShell.PSResourceGet'    = @{}
    'Microsoft.PowerShell.SecretManagement' = @{}
    'Microsoft.PowerShell.SecretStore'      = @{}
    'Microsoft.PowerShell.ThreadJob'        = @{}
    'Microsoft.PowerShell.WhatsNew'         = @{}
    'Microsoft.WinGet.Client'               = @{}
    'Microsoft.WinGet.Configuration'        = @{
        PreRelease = $true
    }
    'Microsoft.WinGet.DSC'                  = @{
        PreRelease = $true
    }
    'ModuleBuilder'                         = @{}
    'ModuleFast'                            = @{}
    'Pester'                                = @{}
    'platyPS'                               = @{}
    'Posh'                                  = @{}
    'posh-git'                              = @{}
    'powershell-yaml'                       = @{}
    'PowerShellAI'                          = @{}
    'PowerShellAI.Functions'                = @{}
    'PowerShellBuild'                       = @{}
    'ps-menu'                               = @{}
    'ps2exe'                                = @{}
    'psake'                                 = @{}
    'PSClearHost'                           = @{}
    'PSCodeHealth'                          = @{}
    'PSCompletions'                         = @{}
    'PSConfigFile'                          = @{}
    'PSDepend'                              = @{}
    'PSEverything'                          = @{}
    'PSFileTransfer'                        = @{}
    'PSFunctionInfo'                        = @{}
    'PSFzf'                                 = @{}
    'PSJsonCredential'                      = @{}
    'PSLog'                                 = @{}
    'PSReadLine'                            = @{}
    'PSScriptAnalyzer'                      = @{}
    'PSScriptTools'                         = @{}
    'PSSoftware'                            = @{}
    'PSSQLite'                              = @{}
    'PSStucco'                              = @{}
    'PSTypeExtensionTools'                  = @{}
    'PSWindowsUpdate'                       = @{}
    'PSWinVitals'                           = @{}
    'PSWriteColor'                          = @{}
    'PSWriteExcel'                          = @{}
    'PSWriteHTML'                           = @{}
    'Sampler'                               = @{}
    'ShowDemo'                              = @{}
    'SysInfo'                               = @{}
    'TabExpansionPlusPlus'                  = @{}
    'Terminal-Icons'                        = @{}
    'TerminalGuiDesigner'                   = @{}
    'tiPS'                                  = @{}
    'VSCodeBackup'                          = @{}
    'WifiTools'                             = @{}
    'WindowSandboxTools'                    = @{}
    'WinGet'                                = @{}
    'WinGetTools'                           = @{}
    'Write-ObjectToSQL'                     = @{}
    'WTToolBox'                             = @{}
    'ZLocation'                             = @{}
}
