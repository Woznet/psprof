. "$PSScriptRoot\..\Functions\Navigation.ps1"
. "$PSScriptRoot\..\Functions\Public\Start-RStudio.ps1"
. "$PSScriptRoot\..\Functions\Public\Start-GitKraken.ps1"
. "$PSScriptRoot\..\Functions\Public\Get-DynamicAboutHelp.ps1"

Function Invoke-ScriptAnalyzerFix {
    <#
    .SYNOPSIS
        Run PSScriptAnalyzer with the -Fix switch.
    .DESCRIPTION
        Run PSScriptAnalyzer with the -Fix switch.
    .EXAMPLE
        Invoke-ScriptAnalyzerFix -Path .\MyScript.ps1

        This will run PSScriptAnalyzer with the -Fix switch on the MyScript.ps1 file.
    .NOTES
        This function serves as the source function for the "alias" `lintfix`.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [String]$Path = $PWD
    )
    Invoke-ScriptAnalyzer -Fix
}

Function Edit-PSProfile {
    <#
    .SYNOPSIS
        Edit the current user's PowerShell profile.
    .DESCRIPTION
        This function will open the current user's PowerShell profile in the user's default text editor (`$Env:Editor`).
    .EXAMPLE
        Edit-PSProfile

        This will open the current user's PowerShell profile in the user's default text editor.
    .NOTES
        This function serves as the source function for the "alias" `editprof`.
    #>

    $cmd = "$Env:Editor $PROFILE.CurrentUserAllHosts"
    Invoke-Expression -Command $cmd
}

$Global:AliasesImports = $true
