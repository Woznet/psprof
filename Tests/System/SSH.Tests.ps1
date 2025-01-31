#Requires -Modules Pester

<#
.SYNOPSIS
#>

Describe 'Testing SSH Configuration and Keys' {
    BeforeAll {
        . "$PSScriptRoot\..\Helpers\Test-SSHKey.ps1"

        $SSHConfigDir = "$env:USERPROFILE\.ssh"
        $SSHConfigFile = "$SSHConfigDir\config"

        $SSHKeys = Get-ChildItem -Path $SSHConfigDir -Filter 'id_*' -File

        $RSAKeys = $SSHKeys | Where-Object { $_.Name -like 'id_rsa*' }
        $ECDSAKeys = $SSHKeys | Where-Object { $_.Name -like 'id_ed25519*' }
    }

    It 'Checks ssh command is available' {
        Get-Command -Name 'ssh' | Should -Not -BeNull
    }

    It 'Checks that the SSH Agent is running' {
        (Get-Service -Name ssh-agent).Status | Should -Be 'Running'
    }

    It 'Checks ssh-agent service is set to Automatic' {
        (Get-Service -Name ssh-agent).StartType | Should -Be 'Automatic'
    }

    It 'Checks that the SSH directory exists' {
        Test-Path -Path $SSHConfigDir | Should -Be $true
    }

    It 'Checks that the SSH config file exists' {
        Test-Path -Path $SSHConfigFile | Should -Be $true
    }

    It 'Checks that the RSA keys exist' {
        $RSAKeys | Should -Not -BeNullOrEmpty
    }

    It 'Checks that the ECDSA keys exist' {
        $ECDSAKeys | Should -Not -BeNullOrEmpty
    }

    It 'Checks that the RSA keys are not empty' {
        $RSAKeys | ForEach-Object {
            Test-SSHKey -Key $_.Name | Should -Be $true
        }
    }

    It 'Checks that the ECDSA keys are not empty' {
        $ECDSAKeys | ForEach-Object {
            Test-SSHKey -Key $_.Name | Should -Be $true
        }
    }

    It 'Checks that the SSH config file is not empty' {
        $SSHConfigFileContent = Get-Content -Path $SSHConfigFile
        $SSHConfigFileContent | Should -Not -BeNullOrEmpty
    }

    It 'Checks that the SSH config file contains the RSA keys' {
        $RSAKeys | ForEach-Object {
            $SSHConfigFileContent -match $_.Name | Should -Be $true
        }
    }

    It 'Checks that the SSH config file contains the ECDSA keys' {
        $ECDSAKeys | ForEach-Object {
            $SSHConfigFileContent -match $_.Name | Should -Be $true
        }
    }

    It 'Checks that the SSH config file contains the correct permissions' {
        $SSHConfigFilePermissions = (Get-Acl -Path $SSHConfigFile).Access
        $SSHConfigFilePermissions | Should -Not -BeNullOrEmpty
    }



}



Describe 'GitHub SSH Checks' {
    It 'Checks can connect to github via ssh' {

        $global:PSNativeCommandUseErrorActionPreference = $false
        Invoke-Command -ScriptBlock { ssh -T 'git@ssh.github.com' } -ErrorAction Ignore
        $LASTEXITCODE | Should -Be 1
        $? | Should -Be $true
        $global:PSNativeCommandUseErrorActionPreference = $true

    }
}
