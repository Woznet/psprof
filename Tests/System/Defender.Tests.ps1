Describe 'Windows Defender Checks' {

    BeforeDiscovery {
        $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
        if ($IsAdmin) { $script:SkipDefenderChecks = $null } else { $script:SkipDefenderChecks = $true }
    }

    It 'Checks Defender Exclusions Exist for PowerShell' -Skip:$SkipDefenderChecks {
        $DefenderExclusions = (Get-MpPreference).ExclusionPath
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell"
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell\7"
        $DefenderExclusions | Should -Contain "$Env:PROGRAMFILES\PowerShell\7-preview"
    }
}
