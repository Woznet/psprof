Function Repair-PathEnvVars {
    <#
    .SYNOPSIS
        Fix and cleanup the PATH environment variable's values.
    .DESCRIPTION
        This function modifies the current user and current machine's PATH environment variables.
        Specifically, it performs the following actions:
            - Moves entries to correct location:
                - Entries in the current user's PATH that are relevant for all users are moved to the machine's PATH.
                - Entries in the machine's PATH that are relevant only for the current user are moved to the user's PATH.
            - Removes duplicates/redundant entries:
                - Duplicate entries in current user's PATH are removed.
                - Duplicate entries in machine's PATH are removed.
                - Entries in the current user's PATH that are already in the machine's PATH are removed.
            - Fix/Remove invalid entries:
                - Entries that do not exist on the file system are removed.
                - Entries that are not directories are removed.
            - Shorten long paths:
                - Paths that are longer than 260 characters are shortened.
                - Replaces parts of the long paths with environment variables (e.g. %ProgramFiles%).
            - Sort entries:
                - Sorts the entries in the current user's PATH.
                - Sorts the entries in the machine's PATH.
    .PARAMETER BackupPath
        The path to backup the current PATH environment variables.
        The default value is the current user's desktop, resulting in two backup files that will be created:
            - YYYY-MM-DD_UserPathBackup.reg
            - YYYY-MM-DD_SystemPathBackup.reg
    .EXAMPLE
        Repair-PathEnvVars
        This command will repair the PATH environment variables for the current user and the machine.
    .EXAMPLE
        Repair-PathEnvVars -BackupPath 'C:\Backups'
        This command will repair the PATH environment variables for the current user and the machine and backup the
        current PATH environment variables to 'C:\Backups'.
    #>
    #Requires -RunAsAdministrator
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High'
    )]
    Param(
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path $_ })]
        [String]$BackupPath = "$Env:USERPROFILE\Desktop"
    )

    Begin {

        $UserPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        $SystemPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')

        [System.Collections.ArrayList]$UserPaths = $UserPath.Split(';').ForEach({ NormalizePath($_) })
        [System.Collections.ArrayList]$SystemPaths = $SystemPath.Split(';').ForEach({ NormalizePath($_) })

    }

    Process {
        Write-Verbose "Move entries in the current user's PATH that are relevant for all users to the machine's PATH."
        $UserMovablePaths = $UserPaths | Where-Object { !$_.StartsWith($Env:USERPROFILE, 'CurrentCultureIgnoreCase') }

        if ($UserMovablePaths.Count -eq 0) {
            Write-Verbose 'No entries to move.'
        } else {
            Write-Verbose "Found $($UserMovablePaths.Count) Entries to Move"
            $UserMovablePaths | ForEach-Object {
                $SystemPaths.Add($_) | Out-Null
                $UserPaths.Remove($_) | Out-Null
            }
        }

        Write-Verbose "Move entries in the machine's PATH that are relevant only for the current user to the user's PATH."
        $SystemMovablePaths = $SystemPaths | Where-Object { $_.StartsWith("$Env:USERPROFILE", 'CurrentCultureIgnoreCase') }

        if ($SystemMovablePaths.Count -eq 0) {
            Write-Verbose 'No entries to move.'
        } else {
            Write-Verbose "Found $($SystemMovablePaths.Count) Entries to Move"
            $SystemMovablePaths | ForEach-Object {
                $UserPaths.Add($_) | Out-Null
                $SystemPaths.Remove($_) | Out-Null
            }
        }

        Write-Verbose 'Remove duplicates/redundant entries.'
        $UserPathsLower = $UserPaths | ForEach-Object { $_.ToLower() }
        [System.Collections.ArrayList]$UserDuplicatePaths = @()

        $UserPathsLower | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object {
            $UserDuplicatePaths.Add($_.Name) | Out-Null
        }

        if ($UserDuplicatePaths.Count -eq 0) {
            Write-Verbose "No duplicate entries found in the current user's PATH."
        } else {
            Write-Verbose "Found $($UserDuplicatePaths.Count) duplicate entries in the current user's PATH."
            $UserDuplicatePaths | ForEach-Object {
                Write-Verbose "Removing duplicate entry: $_"
                $UserPaths.Remove($_) | Out-Null
            }
        }

        $SystemPathsLower = $SystemPaths | ForEach-Object { $_.ToLower() }
        [System.Collections.ArrayList]$SystemDuplicatePaths = @()

        $SystemPathsLower | Group-Object | Where-Object { $_.Count -gt 1 } | ForEach-Object {
            $SystemDuplicatePaths.Add($_.Name) | Out-Null
        }

        if ($SystemDuplicatePaths.Count -eq 0) {
            Write-Verbose "No duplicate entries found in the machine's PATH."
        } else {
            Write-Verbose "Found $($SystemDuplicatePaths.Count) duplicate entries in the machine's PATH."
            $SystemDuplicatePaths | ForEach-Object {
                Write-Verbose "Removing duplicate entry: $_"
                $SystemPaths.Remove($_) | Out-Null
            }
        }

        $UserPathsLower = $UserPaths | ForEach-Object { $_.ToLower() }
        $SystemPathsLower = $SystemPaths | ForEach-Object { $_.ToLower() }

        Write-Verbose "Remove entries in the current user's PATH that are already in the machine's PATH."
        $UserRedundantPaths = $UserPaths | Where-Object { $SystemPathsLower.Contains($_.ToLower()) }

        if ($UserRedundantPaths.Count -eq 0) {
            Write-Verbose "No redundant entries found in the current user's PATH."
        } else {
            Write-Verbose "Found $($UserRedundantPaths.Count) redundant entries in the current user's PATH."
            $UserRedundantPaths | ForEach-Object {
                Write-Verbose "Removing redundant entry: $_"
                $UserPaths.Remove($_) | Out-Null
            }
        }

        Write-Verbose 'Remove entries that do not exist on the file system.'
        $UserBrokenPaths = $UserPaths | Where-Object { -not (Test-Path $_) }

        if ($UserBrokenPaths.Count -eq 0) {
            Write-Verbose "No broken entries found in the current user's PATH."
        } else {
            Write-Verbose "Found $($UserBrokenPaths.Count) broken entries in the current user's PATH."
            $UserBrokenPaths | ForEach-Object {
                Write-Verbose "Removing broken entry: $_"
                $UserPaths.Remove($_) | Out-Null
            }
        }

        $SystemBrokenPaths = $SystemPaths | Where-Object { -not (Test-Path $_) }

        if ($SystemBrokenPaths.Count -eq 0) {
            Write-Verbose "No broken entries found in the machine's PATH."
        } else {
            Write-Verbose "Found $($SystemBrokenPaths.Count) broken entries in the machine's PATH."
            $SystemBrokenPaths | ForEach-Object {
                Write-Verbose "Attempting to find a valid path for: $_"

                # Find portion of path with any numbers
                $ParentPath = Split-Path (Split-Path $_ -Parent) -Parent
                $ValidPath = Get-ChildItem -Path $ParentPath -Directory |
                    Where-Object { $_.Name -match '\d' } |
                    Select-Object -First 1 -ExpandProperty FullName

                    if ($ValidPath) {
                        if (Split-Path $_ -Leaf) {
                            $ValidPath = Join-Path $ValidPath (Split-Path $_ -Leaf)
                        }
                        Write-Verbose "Found a valid path: $ValidPath"
                        Write-Verbose "Changing broken path entry: $_ -> $ValidPath"
                        $SystemPaths[$SystemPaths.IndexOf($_)] = $ValidPath
                    } else {
                        Write-Verbose "No valid path found for: $_"
                        $SystemPaths.Remove($_) | Out-Null
                    }
                    Write-Verbose "Removing broken entry: $_"
                    $SystemPaths.Remove($_) | Out-Null
                }
            }

            Write-Verbose 'Shorten long paths.'
            $UserPathsShort = $UserPaths | ForEach-Object { ShortenPath $_ }
            $SystemPathsShort = $SystemPaths | ForEach-Object { ShortenPath $_ }

            $UserPaths = $UserPathsShort
            $SystemPaths = $SystemPathsShort

            Write-Verbose 'Sort entries.'
            $UserPaths.Sort()
            $SystemPaths.Sort()

            $NewUserPath = $UserPaths.ToArray() -join ';'
            $NewSystemPath = $SystemPaths.ToArray() -join ';'

            Write-Verbose 'Setting the new PATH environment variables.'
            Write-Host 'New User Path Environment Variables:'
            Write-Host $NewUserPath

            Write-Host 'New System Path Environment Variables:'
            Write-Host $NewSystemPath

            $Confirmation = Read-Host 'Do you want to set the new PATH environment variables? (Y/N)'

            if ($Confirmation.ToLower() -ne 'y') {
                Write-Verbose 'User chose not to set the new PATH environment variables.'
                return
            } else {
                Write-Verbose 'Backing up the current PATH environment variables.'
                $UserBackupPath = Join-Path $BackupPath "$(Get-Date -Format 'yyyy-MM-dd')_UserPathBackup.reg"
                $SystemBackupPath = Join-Path $BackupPath "$(Get-Date -Format 'yyyy-MM-dd')_SystemPathBackup.reg"

                Write-Verbose "Backing up the current user's PATH environment variables to: $UserBackupPath"
                reg export 'HKCU\Environment' $UserBackupPath /y

                Write-Verbose "Backing up the machine's PATH environment variables to: $SystemBackupPath"
                reg export 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' $SystemBackupPath /y

                Write-Verbose 'Setting the new PATH environment variables.'
                Set-ItemProperty -Path 'HKCU:\Environment' -Name 'Path' -Value $NewUserPath -Type ExpandString
                Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name 'Path' -Value $NewSystemPath -Type ExpandString
            }
        }

        End {
            Write-Verbose 'Finished.'
        }
    }
