<#
    .SYNOPSIS
        PowerShell Profile - Prompt Configuration
    .DESCRIPTION
        Configures the PowerShell prompt using Oh-My-Posh or custom prompt.
    .PARAMETER DisablePrompt
        Disables prompt customization.
#>
[CmdletBinding()]
Param(
    [Switch]$DisablePrompt
)

Begin {
    Write-Verbose "[BEGIN]: Prompt.ps1"

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Prompt.psd1"
    if (Test-Path $configPath) {
        $promptConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded prompt configuration from $configPath"
    } else {
        Write-Warning "Prompt configuration not found: $configPath"
        return
    }

    # Check if prompt is disabled
    if ($DisablePrompt) {
        Write-Verbose "Prompt customization is disabled. Skipping prompt configuration."
        return
    }

    # Determine environment
    $environment = "Console"
    if ($isVSCode) {
        $environment = "VSCode"
    } elseif ($isISE) {
        $environment = "ISE"
    }

    Write-Verbose "Current environment: $environment"
}

Process {
    Write-Verbose "[PROCESS]: Prompt.ps1"

    # Check if Oh-My-Posh should be used for this environment
    $useOhMyPosh = $false
    if ($promptConfig.Environments -and $promptConfig.Environments[$environment]) {
        $useOhMyPosh = $promptConfig.Environments[$environment].UseOhMyPosh
    }

    if ($useOhMyPosh -and $promptConfig.OhMyPosh.Enabled) {
        # Configure Oh-My-Posh prompt
        if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
            try {
                Write-Verbose "Configuring Oh-My-Posh prompt"
                $ohMyPoshConfigPath = $ExecutionContext.InvokeCommand.ExpandString($promptConfig.OhMyPosh.ThemePath)

                if (Test-Path -Path $ohMyPoshConfigPath) {
                    $Expression = (& oh-my-posh init pwsh --config=$ohMyPoshConfigPath --print) -join "`n"
                    $Expression | Invoke-Expression
                    Write-Verbose "Oh-My-Posh prompt configured with theme: $ohMyPoshConfigPath"
                } else {
                    Write-Error "Oh-My-Posh configuration path is not valid: $ohMyPoshConfigPath"
                }
            } catch {
                Write-Error ("Failed to configure Oh-My-Posh prompt: {0}" -f $_.Exception.Message)
            }
        } else {
            Write-Warning "Oh-My-Posh is not installed. Skipping prompt customization."
        }
    } elseif ($environment -eq "VSCode" -and $promptConfig.VSCode.UseCustomPrompt) {
        # Configure custom VSCode prompt
        Write-Verbose "Configuring custom VSCode prompt"

        function global:prompt {
            $lastCommand = Get-History -Count 1
            $executionTime = if ($lastCommand) {
                $lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime
            } else {
                [TimeSpan]::Zero
            }

            $executionTimeStr = if ($executionTime.TotalSeconds -ge 1) {
                " [{0:f2}s]" -f $executionTime.TotalSeconds
            } else {
                " [{0:f0}ms]" -f $executionTime.TotalMilliseconds
            }

            $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
            $shortPath = $currentPath.Replace($HOME, "~")

            $promptText = "`n"

            # Add PS version if enabled
            if ($promptConfig.VSCode.ShowPSVersion) {
                $psVersion = $PSVersionTable.PSVersion
                $promptText += "[PS $($psVersion.Major).$($psVersion.Minor)] "
            }

            # Add admin status if enabled
            if ($promptConfig.VSCode.ShowAdminStatus) {
                $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
                if ($isAdmin) {
                    $promptText += "[ADMIN] "
                }
            }

            # Add path
            $promptText += "$shortPath"

            # Add git branch if enabled
            if ($promptConfig.VSCode.ShowGitBranch) {
                try {
                    $gitBranch = git branch --show-current 2>$null
                    if ($gitBranch) {
                        $promptText += " [$gitBranch]"
                    }
                } catch {
                    # Git not available or not in a git repository
                }
            }

            # Add execution time
            $promptText += "$executionTimeStr`n"

            # Add prompt character
            $promptText += "PS> "

            return $promptText
        }
    }
}

End {
    Write-Verbose "[END]: Prompt.ps1"
}
