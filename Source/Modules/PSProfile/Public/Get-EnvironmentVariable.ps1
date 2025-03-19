Function Get-EnvironmentVariable {
	<#
	.SYNOPSIS
	Gets an Environment Variable.

	.DESCRIPTION
	This will will get an environment variable based on the variable name
	and scope while accounting whether to expand the variable or not
	(e.g.: `%TEMP%`-> `C:\User\Username\AppData\Local\Temp`).

	.NOTES
	This helper reduces the number of lines one would have to write to get
	environment variables, mainly when not expanding the variables is a
	must.

	.PARAMETER Name
	The environment variable you want to get the value from.

	.PARAMETER Scope
	The environment variable target scope. This is `Process`, `User`, or `Machine`.

	.PARAMETER PreserveVariables
	A switch parameter stating whether you want to "expand" the path variables or not. Defaults to $false.
	For example, if you have a path variable like `%TEMP%` and you set this, the function will return
	`C:\User\Username\AppData\Local\Temp`. If you do not set this, the function will return `%TEMP%`.

	.PARAMETER Split
	A switch parameter stating whether you want to split the value by the `;` character. Defaults to $false.
	Useful when you want to get a list of paths from the `PATH` environment variable.

	.PARAMETER IgnoredArguments
	Allows splatting with arguments that do not apply. Do not use directly.

	.EXAMPLE
	PS> Get-EnvironmentVariable -Name 'TEMP' -Scope User -PreserveVariables

	Get the value of the TEMP environment variable from the user scope, preserving its value as registered in the registry.
	.EXAMPLE
	PS> Get-EnvironmentVariable -Name 'PATH' -Scope Machine

	Get all environment variable names from the machine scope.
	.EXAMPLE
	PS> Get-EnvironmentVariable -Name 'PATH' -Scope User -Split

	Get all environment variable names from the user scope and split them by the `;` character onto separate lines.
	.LINK
	Get-EnvironmentVariableNames

	.LINK
	Set-EnvironmentVariable
	#>
	[CmdletBinding()]
	[OutputType([string])]
	[Alias('Get-EnvVar')]
	Param(
		[Parameter(Mandatory = $true)]
		[String]$Name,

		[Parameter(Mandatory = $true)]
		[ValidateSet('Process', 'User', 'Machine')]
		[System.EnvironmentVariableTarget]$Scope,

		[Parameter(Mandatory = $false)]
		[Switch]$PreserveVariables = $false,

		[Parameter(Mandatory = $false)]
		[Switch]$Split,

		[Parameter(ValueFromRemainingArguments = $true)]
		[Object[]]$IgnoredArguments
	)

	Begin {
		[string]$MACHINE_ENVIRONMENT_REGISTRY_KEY_NAME = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment\';
		[Microsoft.Win32.RegistryKey] $win32RegistryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($MACHINE_ENVIRONMENT_REGISTRY_KEY_NAME)
	}

	Process {
		if ($Scope -eq [System.EnvironmentVariableTarget]::User) {
			[string] $USER_ENVIRONMENT_REGISTRY_KEY_NAME = 'Environment';
			[Microsoft.Win32.RegistryKey] $win32RegistryKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($USER_ENVIRONMENT_REGISTRY_KEY_NAME)
		}
		elseif ($Scope -eq [System.EnvironmentVariableTarget]::Process) {
			return [Environment]::GetEnvironmentVariable($Name, $Scope)
		}

		[Microsoft.Win32.RegistryValueOptions] $registryValueOptions = [Microsoft.Win32.RegistryValueOptions]::None

		if ($PreserveVariables) {
			Write-Verbose 'Choosing not to expand environment names'
			$registryValueOptions = [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames
		}

		[string] $environmentVariableValue = [string]::Empty

		try {
			#Write-Verbose "Getting environment variable $Name"
			if ($null -ne $win32RegistryKey) {
				# Some versions of Windows do not have HKCU:\Environment
				$environmentVariableValue = $win32RegistryKey.GetValue($Name, [string]::Empty, $registryValueOptions)
			}
		}
		catch {
			Write-Debug "Unable to retrieve the $Name environment variable. Details: $_"
		}
		finally {
			if ($null -ne $win32RegistryKey) {
				$win32RegistryKey.Close()
			}
		}

		if ($null -eq $environmentVariableValue -or $environmentVariableValue -eq '') {
			$environmentVariableValue = [Environment]::GetEnvironmentVariable($Name, $Scope)
		}
	}

	End {
		if ($Split) {
			return $environmentVariableValue -split ';'
		}
		else {
			return $environmentVariableValue
		}
	}

}

Set-Alias -Name 'Get-EnvVar' -Value 'Get-EnvironmentVariable'
