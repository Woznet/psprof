#Requires -Modules Pester

<#
.SYNOPSIS
    Tests the global git configuration values.
.DESCRIPTION
    This script tests the global git configuration values to ensure that they are set to the expected
    configuration values. The following configuration values are tested:

    - user.email
    - user.signingkey
    - init.defaultBranch
    - gpg.program
    - commit.gpgSign
    - tag.forceSignAnnotated
#>

Describe 'Testing Git Configuration Values' {
    BeforeAll {
        . "$PSScriptRoot\..\Helpers\Get-GitConfigValue.ps1"
        . "$PSScriptRoot\..\Helpers\Test-Email.ps1"
    }

    It 'Checks a global git configuration file exists' {
        $GitConfigPath = "$HOME\.gitconfig"
        Test-Path -Path $GitConfigPath | Should -Be $true
        $GitConfigContent = Get-Content -Path $GitConfigPath
        $GitConfigContent | Should -Not -BeNullOrEmpty
    }

    It 'Checks that user.email is set and valid' {
        $Test_Email = Get-GitConfigValue -Key 'user.email'
        $Test_Email | Should -Not -BeNullOrEmpty
        Test-Email -Email $Test_Email | Should -Be $true
    }

    It 'Checks that init.defaultBranch is set and is "main"' {
        $Test_DefaultMain = Get-GitConfigValue -Key 'init.defaultBranch'
        $Test_DefaultMain | Should -Be 'main'
    }

    It 'Checks that gpg.program is set and is a valid executable' {
        $Test_GPGProgram = Get-GitConfigValue -Key 'gpg.program'
        $Test_GPGProgram | Should -Not -BeNullOrEmpty
        Get-Command $Test_GPGProgram -ErrorAction SilentlyContinue | Should -Not -BeNull
    }

    It 'Checks that user.signingkey is set' {
        $Test_SigningKey = Get-GitConfigValue -Key 'user.signingkey'
        $Test_SigningKey | Should -Not -BeNullOrEmpty
    }

    It 'Checks that commit.gpgSign is set' {
        $Test_CommitSigning = Get-GitConfigValue -Key 'commit.gpgSign'
        $Test_CommitSigning | Should -Be 'true'
    }

    It 'Checks that tag.forceSignAnnotated is set' {
        $Test_TagSigning = Get-GitConfigValue -Key 'tag.forceSignAnnotated'
        $Test_TagSigning | Should -Be 'true'
    }

}
