#Requires -Module Pester

<#
#>

Describe 'Test PowerShell Setup and Configuration' {
    BeforeAll {
        $PSVersion = $PSVersionTable.PSVersion
        $PSProfiles = $PROFILE | Get-Member -Type NoteProperty | Select-Object Name, Definition | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.Name
                Path = $_.Definition -match "=(.*)$" | ForEach-Object { $Matches[1] }
            }
        }
    }

    It 'Checks that the all "user" PowerShell profiles exist' {
        Test-Path -Path $PSProfiles[2].Path | Should -Be $true
        Test-Path -Path $PSProfiles[3].Path | Should -Be $true
    }
}

Describe 'PowerShell Core Installation Checks' {

    BeforeAll {
        $DefaultPath = "$Env:PROGRAMFILES\PowerShell\7\pwsh.exe"
        $PreviewPath = "$Env:PROGRAMFILES\PowerShell\7-preview\pwsh.exe"

        $psStableVersionMajor = ((Get-Command $DefaultPath).FileVersionInfo.ProductVersion).Split('.')[0]
        $psStableExpectedVersionMajor = '7'

        $psPreviewVersion = ((Get-Command $PreviewPath).FileVersionInfo.ProductVersion).Substring(0, 5)
        $psPreviewExpectedVersion = '7.4.0'

        $EnvPaths = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'

        $DefaultPathDir = Split-Path $DefaultPath -Parent
        $PreviewPathDir = Split-Path $PreviewPath -Parent

        $StableExists = Test-Path -Path $DefaultPath
        $PreviewExists = Test-Path -Path $PreviewPath
        $SkipStableCheck = If ($StableExists) { $null } Else { $true }
        $SkipPreviewCheck = If ($PreviewExists) { $null } Else { $true }


    }

    It 'Checks if PowerShell Core Stable Version is installed' -Skip:$SkipStableCheck {
        Test-Path $DefaultPath | Should -Be $true
    }

    It 'Checks if Installed Stable PowerShell Core Version is 7+' -Skip:$SkipStableCheck {
        $psStableVersionMajor | Should -BeExactly $psStableExpectedVersionMajor
    }

    It 'Checks if PowerShell Core Preview Version is installed' -Skip:$SkipPreviewCheck {
        Test-Path $PreviewPath | Should -Be $true
    }

    It 'Checks if Installed Preview PowerShell Core Version is correct' -Skip:$SkipPreviewCheck {
        $psPreviewVersion | Should -BeExactly $psPreviewExpectedVersion
    }

    It 'Checks that Stable PowerShell Installed Executable is on system PATH' -Skip:$SkipStableCheck {
        $EnvPaths.Contains($DefaultPathDir) | Should -Be $true
    }

    It 'Checks that Preview PowerShell Installed Executable is on system PATH' -Skip:$SkipPreviewCheck {
        $EnvPaths.Contains($PreviewPathDir) | Should -Be $true
    }

}
