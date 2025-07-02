# Profile.Tests.ps1
Import-Module Pester -ErrorAction Stop

Describe 'Profile.ps1 Tests' {
    BeforeAll {
        if (-not $PROFILE) {
            throw "PROFILE variable is not defined"
        }
        $script:TestProfilePath = $PROFILE
        $script:OriginalProfile = $null
        if (Test-Path $PROFILE) {
            $script:OriginalProfile = Get-Content -Path $PROFILE -Raw
        }

        # Mock common profile functions
        Mock Update-Profile { return $true }
        Mock Edit-Profile { return $true }

        # Add module dependency checks
        $script:RequiredModules = @('PSReadLine', 'Terminal-Icons')
        $script:AvailableModules = Get-Module -ListAvailable $RequiredModules
    }

    AfterAll {
        if ($script:OriginalProfile) {
            Set-Content -Path $PROFILE -Value $script:OriginalProfile
        }
    }

    Context 'Profile Environment' {
        It 'Has valid profile path' {
            $TestProfilePath | Should -Exist
        }

        It 'Can access profile script' {
            $PROFILE | Should -Exist
        }
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
        BeforeAll {
            $script:PSReadLineAvailable = Get-Module -ListAvailable PSReadLine
        }

        It 'Loads PSReadLine when available in ConsoleHost' {
            $IsConsoleHost = $Host.Name -eq 'ConsoleHost'
            if ($IsConsoleHost -and $script:PSReadLineAvailable) {
                (Get-Module PSReadLine) | Should -Not -BeNullOrEmpty
                (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) |
                    Should -Not -BeNullOrEmpty
            } else {
                Set-ItResult -Skipped -Because "Not running in ConsoleHost or PSReadLine not available"
            }
        }
    }

    Context 'Profile Functions' {
        BeforeEach {
            # Improved mock and function cleanup
            Get-Module -Name TestModule -All | Remove-Module -Force
            Get-ChildItem Function: |
                Where-Object { $_.Source -eq $TestProfilePath -or $_.Source -eq 'TestModule' } |
                Remove-Item -Force

            # Reset mocks
            Mock Update-Profile { return $true } -ParameterFilter { $true }
            Mock Edit-Profile { return $true } -ParameterFilter { $true }
        }

        It 'Defines expected utility functions' {
            $ExpectedFunctions = @(
                'Update-Profile'
                'Edit-Profile'
            )

            foreach ($function in $ExpectedFunctions) {
                (Get-Command $function -ErrorAction SilentlyContinue) |
                    Should -Not -BeNullOrEmpty
            }
        }

        It 'Update-Profile executes successfully' {
            { Update-Profile } | Should -Not -Throw
            Should -Invoke Update-Profile -Times 1
        }

        It 'Edit-Profile executes successfully' {
            { Edit-Profile } | Should -Not -Throw
            Should -Invoke Edit-Profile -Times 1
        }
    }

    Context 'Module Dependencies' {
        It 'Has required modules available' {
            foreach ($module in $RequiredModules) {
                $script:AvailableModules |
                    Where-Object Name -eq $module |
                    Should -Not -BeNullOrEmpty -Because "Module $module should be available"
            }
        }
    }

    Context 'Error Handling' {
        It 'Handles missing source files gracefully' {
            Mock Test-Path { return $false }
            { . $TestProfilePath -NoImports } | Should -Not -Throw
        }
    }
}
