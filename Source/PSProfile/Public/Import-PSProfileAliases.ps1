Function Import-PSProfileAliases {
    <#
    .SYNOPSIS
        Import the aliases from the PSProfile module.
    .DESCRIPTION
        This function imports the aliases from the PSProfile module.
    #>
    [CmdletBinding()]
    Param (
        [string]$DataFile = 'PSProfile.Aliases.psd1'
    )

    Begin {

        $Path = $PSProfileDataPath | Join-Path -ChildPath $DataFile

        try {
            Write-Verbose "Importing PSProfile Aliases from $DataFile"
            $Aliases = Import-PowerShellDataFile -Path $Path -ErrorAction Stop
        } catch {
            Write-Error "Could not import PSProfile Aliases from $Path"
            return
        }

        $TotalCount = ($Aliases.Keys | ForEach-Object { $Aliases[$_] } | Measure-Object -Property Count -Sum).Sum
        Write-Verbose "Total Aliases: $TotalCount"
        $i = 0

        # Save current psstyle
        $CurrentStyle = $PSStyle

        # Set the PSStyle for Progress
        $PSStyle.Progress.Style = "`e[38;5;123m"
        $PSStyle.Progress.Foreground = "White"
        $PSStyle.Progress.Background = "Blue"
        $PSStyle.Progress.Percent = "White"
        $PSStyle.Progress.Activity = "White"
        $PSStyle.Progress.Status = "White"
        $PSStyle.Progress.Completed = "White"
        $PSStyle.Progress.Remaining = "White"
        $PSStyle.Progress.CompletedBackground = "Blue"


    }

    Process {

        Write-Progress -Activity "Importing PSProfile Aliases" -Status "Importing $TotalCount Aliases"

        $Aliases.GetEnumerator() | ForEach-Object {
            $i++
            Write-Host "===================== Setting $($_.Key) Aliases ====================="
            $_.Value.GetEnumerator() | ForEach-Object {
                $Name = $_.Name.ToString()
                $Value = $_.Value.ToString()
                Write-Host "Setting Alias: $Name = $Value"
                Set-Alias -Name $Name -Value $Value -Scope Global -Force
                $Pct = ($i / $TotalCount) * 100
                Write-Progress -Activity "Importing PSProfile Aliases" -Status "Importing $TotalCount Aliases" -PercentComplete $Pct
            }
        }

        $Aliases.Keys | ForEach-Object {
            $i++
            Write-Host "===================== Setting $($_) Aliases ====================="
            $Aliases[$_].GetEnumerator() | ForEach-Object {
                $Name = $_.Name.ToString()
                $Value = $_.Value.ToString()
                Write-Host "Setting Alias: $Name = $Value"
                Set-Alias -Name $Name -Value $Value -Scope Global -Force
                $Pct = ($i / $TotalCount) * 100
                Write-Progress -Activity "Importing PSProfile Aliases" -Status "Importing $TotalCount Aliases" -PercentComplete $Pct
            }
        }
    }

    End {
        Write-Progress -Activity "Importing PSProfile Aliases" -Status "Importing $TotalCount Aliases" -PercentComplete 100
        Write-Verbose "Imported $TotalCount Aliases"
        # Restore the PSStyle
        $PSStyle = $CurrentStyle
    }

}
