# Profile.Tests.ps1
Import-Module Pester -ErrorAction Stop

Describe 'Profile.ps1 Tests' {

    BeforeAll {
        $TestProfilePath = Join-Path $PSScriptRoot 'Profile.ps1'
    }

    It 'Loads without error' {
        . $TestProfilePath | Out-Null
        $null = $ProfileRootPath  # ensures variables are accessible
    }

    Context 'Variable checks' {
        It 'Defines $ProfileRootPath' {
            $ProfileRootPath | Should -Not -BeNullOrEmpty
        }
        It 'Defines $ProfileSourcePath' {
            $ProfileSourcePath | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When NoImports is not used' {
        It 'Imports additional scripts without error' {
            { . $TestProfilePath } | Should -Not -Throw
        }
    }

    Context 'When NoImports is used' {
        It 'Skips imports without error' {
            { . $TestProfilePath -NoImports } | Should -Not -Throw
        }
    }

    Context 'PSReadLine loading' {
        It 'Loads PSReadLine for ConsoleHost' {
            $IsConsoleHost = $Host.Name -eq 'ConsoleHost'
            if ($IsConsoleHost) {
                # This checks if the function exists after load
                (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) |
                    Should -Not -BeNullOrEmpty
            }
        }
    }
}
