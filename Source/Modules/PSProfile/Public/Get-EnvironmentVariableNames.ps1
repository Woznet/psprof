Function Get-EnvironmentVariableNames {
	<#
	.SYNOPSIS
	Gets all environment variable names.

	.DESCRIPTION
	Provides a list of environment variable names based on the scope. This
	can be used to loop through the list and generate names.

	.NOTES
	Process dumps the current environment variable names in memory /
	session. The other scopes refer to the registry values.

	.INPUTS
	None

	.OUTPUTS
	A list of environment variables names.

	.PARAMETER Scope
	The environment variable target scope. This is `Process`, `User`, or
	`Machine`.

	.EXAMPLE
	Get-EnvironmentVariableNames -Scope Machine

	.LINK
	Get-EnvironmentVariable

	.LINK
	Set-EnvironmentVariable
	#>
	[CmdletBinding()]
	[Alias('Get-EnvVarNames')]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateSet('User', 'Machine', 'Process')]
		[System.EnvironmentVariableTarget]$Scope
	)

	# Do not log function call

	# HKCU:\Environment may not exist in all Windows OSes (such as Server Core).
	switch ($Scope) {
		'User' {
			Get-Item 'HKCU:\Environment' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property
		}
		'Machine' {
			Get-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' | Select-Object -ExpandProperty Property
		}
		'Process' {
			Get-ChildItem Env:\ | Select-Object -ExpandProperty Key
		}
		default {
			throw "Unsupported environment scope: $Scope"
		}
	}
}

Set-Alias -Name 'Get-EnvVarNames' -Value 'Get-EnvironmentVariableNames'
