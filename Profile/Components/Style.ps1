<#
    .SYNOPSIS
        PowerShell Profile - Style Configuration
    .DESCRIPTION
        Configures PowerShell's $PSStyle and console appearance settings.
    .PARAMETER DisableStyles
        Disables style configuration.
#>
[CmdletBinding()]
Param(
    [Switch]$DisableStyles
)

Begin {
    Write-Verbose "[BEGIN]: Style.ps1"
    if ($DisableStyles) {
        Write-Verbose "Styles are disabled. Skipping style configuration."
        return
    }

    # Load configuration
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\Style.psd1"
    if (Test-Path $configPath) {
        $styleConfig = Import-PowerShellDataFile -Path $configPath
        Write-Verbose "Loaded style configuration from $configPath"
    } else {
        Write-Warning "Style configuration not found: $configPath"
        return
    }
}

Process {
    Write-Verbose "[PROCESS]: Style.ps1"

    if ($PSStyle) {
        try {
            Write-Verbose "Configuring PSStyle settings"

            # Configure Progress style
            if ($styleConfig.PSStyle.Progress) {
                if ($null -ne $styleConfig.PSStyle.Progress.UseOSCIndicator) {
                    $PSStyle.Progress.UseOSCIndicator = $styleConfig.PSStyle.Progress.UseOSCIndicator
                }

                if ($styleConfig.PSStyle.Progress.View) {
                    $PSStyle.Progress.View = $styleConfig.PSStyle.Progress.View
                }
            }

            # Configure FileInfo style
            if ($styleConfig.PSStyle.FileInfo) {
                if ($styleConfig.PSStyle.FileInfo.Directory) {
                    $PSStyle.FileInfo.Directory = $PSStyle.Foreground.($styleConfig.PSStyle.FileInfo.Directory)
                }
            }

            # Configure Formatting style
            if ($styleConfig.PSStyle.Formatting) {
                $Format = $PSStyle.Formatting
                $FG = $PSStyle.Foreground

                foreach ($key in $styleConfig.PSStyle.Formatting.Keys) {
                    $colorName = $styleConfig.PSStyle.Formatting[$key]
                    $Format.$key = $FG.$colorName
                }
            }

            # Configure PSReadLine colors
            if ($styleConfig.PSReadLine -and $styleConfig.PSReadLine.Colors) {
                $customColors = @{}

                foreach ($key in $styleConfig.PSReadLine.Colors.Keys) {
                    $colorName = $styleConfig.PSReadLine.Colors[$key]

                    # Handle custom color (DarkPlusTypeGreen)
                    if ($colorName -eq 'DarkPlusTypeGreen') {
                        $customColors[$key] = "`e[38;2;78;201;176m" # 4EC9B0 Dark Plus Type color
                    } else {
                        $customColors[$key] = $PSStyle.Foreground.$colorName
                    }
                }

                Set-PSReadLineOption -Colors $customColors
            }
        } catch {
            Write-Error "Failed to configure PowerShell styles: $_"
        }
    } else {
        Write-Verbose "Configuring legacy style settings"
        try {
            # Configure legacy console colors
            if ($styleConfig.LegacyConsole) {
                foreach ($key in $styleConfig.LegacyConsole.Keys) {
                    $host.PrivateData.$key = $styleConfig.LegacyConsole[$key]
                }
            }

            # Configure PSReadLine colors for legacy console
            if ($styleConfig.PSReadLine -and $styleConfig.PSReadLine.Colors) {
                # ANSI Escape Character
                $e = [char]0x1b
                $colors = @{}

                foreach ($key in $styleConfig.PSReadLine.Colors.Keys) {
                    $colors[$key] = "$e[37m" # Default to white
                }

                Set-PSReadLineOption -Colors $colors

                Remove-Variable e
            }
        } catch {
            Write-Error "Failed to configure legacy styles: $_"
        }
    }

    # Set console title
    if ($styleConfig.ConsoleTitle) {
        $psVersion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"

        if ($ENV:WT_SESSION -and $styleConfig.ConsoleTitle.WindowsTerminalFormat) {
            [Console]::Title = $styleConfig.ConsoleTitle.WindowsTerminalFormat -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor
        } else {
            [Console]::Title = $styleConfig.ConsoleTitle.DefaultFormat -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor
        }
    }
}

End {
    Write-Verbose "[END]: Style.ps1"
}
