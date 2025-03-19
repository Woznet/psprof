Function Update-SessionEnvironment {
	<#
	.SYNOPSIS
	Updates the environment variables of the current powershell session with
	any environment variable changes.

	.DESCRIPTION
	During a PowerShell session, the system/user environment variables may change for various reasons.

	Often, these changes are not visible to the current PowerShell session. This means the user needs to open a new
	PowerShell session (shell) before these settings take effect which is not ideal.

	Utilize this function to refresh the environment variables of the current PowerShell session with any changes.

	.NOTES
	This function should be added to the user's PowerShell $PROFILE using its alias 'refreshenv'. This will allow
	the user to call the function from any PowerShell session as 'refreshenv'.

	Note that the function preserves the PSModulePath process environment variable. This is because the PSModulePath
	environment variable is used to locate modules when importing them.

	.INPUTS
	None.

	.OUTPUTS
	None.

	.EXAMPLE
	PS> Refresh-Environment

	Refresh the environment variables of the current PowerShell session.

	.EXAMPLE
	PS> refreshenv

	Refresh the environment variables of the current PowerShell session using the alias'refreshenv'.

	.LINK
	https://github.com/chocolatey/choco/blob/develop/src/chocolatey.resources/helpers/functions/Update-SessionEnvironment.ps1
	#>
	[CmdletBinding()]
	[Alias('refreshenv')]
	param()

	Begin {

		$RefreshEnv = $false
		$Invocation = $MyInvocation

		if ($Invocation.InvocationName -eq 'refreshenv') {
			$RefreshEnv = $true
		}

		if ($RefreshEnv) {
			Write-Output 'Refreshing environment variables from the registry for powershell.exe. Please wait...'
		}
		else {
			Write-Verbose 'Refreshing environment variables from the registry.'
		}

		$UserName = $Env:USERNAME
		$Arch = $Env:PROCESSOR_ARCHITECTURE
		$PSModPath = $Env:PSModulePath

		$ScopeList = 'Process', 'Machine'
		if ('SYSTEM', "${Env:COMPUTERNAME}`$" -notcontains $UserName) {
			$ScopeList += 'User'
		}
	}

	Process {

		ForEach ($Scope in $ScopeList) {
			Get-EnvironmentVariableNames -Scope $Scope |
			ForEach-Object {
				Set-Item "Env:$_" -Value (Get-EnvironmentVariable -Name $_ -Scope $Scope)
			}
		}

		$paths = 'Machine', 'User' |
		ForEach-Object { (Get-EnvironmentVariable -Name 'PATH' -Scope $_) -split ';' } |
		Select-Object -Unique

		$Env:PATH = $paths -join ';'

		$env:PSModulePath = $PSModPath

		if ($userName) {
			$env:USERNAME = $userName;
		}
		if ($Arch) {
			$env:PROCESSOR_ARCHITECTURE = $Arch;
		}
	}

	End {
		if ($RefreshEnv) {
			Write-Output 'Finished'
		}
	}
}

Set-Alias -Name refreshenv -Value Update-SessionEnvironment
