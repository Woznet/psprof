# -------------------------------------------
# Configure $Env:PSModulePath
# -------------------------------------------

# Get the current PSModulePath environment variable as a powershell object
# $CurrentPSModulePathSystem = [System.Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
# $CurrentPSModulePathUser = [System.Environment]::GetEnvironmentVariable("PSModulePath", "User")
$CurrentPSModulePath = [System.Environment]::GetEnvironmentVariable('PSModulePath', 'Process') -split ';' |
    ConvertTo-Json -AsArray |
    ConvertFrom-Json -AsHashtable

# Remove any paths that contain the string "OneDrive"
$PSModulePath = $CurrentPSModulePath | Where-Object { $_ -notmatch 'OneDrive' }

if ($PSModulePath -ne $CurrentPSModulePath) {
    Write-Verbose '[INFO]: Detected OneDrive in PSModulePath. Removing...'
    # Set the PSModulePath environment variable
    [System.Environment]::SetEnvironmentVariable('PSModulePath', ($PSModulePath -join ';'), 'Process')
}


# -------------------------------------------
# Check $PROFILE Setup
# -------------------------------------------

# Get User Shell "Personal" Folder from Registry
$UserShellFolders = @(
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Personal').Personal
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' -Name 'Personal').Personal
) | Where-Object { $_ -ne $null }

# Determine if the shell folders are using OneDrive
$OneDrivePath = $Env:OneDrive
$OneDrivePersonalPath = Join-Path -Path $OneDrivePath -ChildPath 'Documents'

if ($UserShellFolders -contains $OneDrivePersonalPath) {
    Write-Host '[WARNING]: Detected OneDrive in User Shell Folders. Replacing with local path...'
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Personal' -Value "$HOME\Documents"
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' -Name 'Personal' -Value "$HOME\Documents"
}

# Verify
$UserShellFoldersCheck = @(
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name 'Personal').Personal
    (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' -Name 'Personal').Personal
) | Where-Object { $_ -ne $null }
$UserShellFoldersCheck[0] -eq $UserShellFoldersCheck[1]
$UserShellFoldersCheck[0] -eq "$HOME\Documents"

# Refresh Environment Variables
refreshenv

# Restart Explorer
sudo cmd.exe taskkill /f /im exmplorer.exe
Start-Sleep -Seconds 2
sudo cmd.exe start explorer.exe

# -------------------------------------------
# Uninstall Modules
# -------------------------------------------

$OneDriveModulesPath = "$env:USERPROFILE\OneDrive\Documents\PowerShell\Modules"
$Ignores = @('.Archived', 'Microsoft.PowerShell.PSResourceGet', 'Microsoft.PowerShell.SecretManagement', 'Microsoft.PowerShell.SecretStore', 'PackageManagement', 'PSReadLine')
$ToUninstall = Get-ChildItem -Path $OneDriveModulesPath -Directory |
    Where-Object { $_.Name -notin $Ignores }

$i = 0
$Pct = [Math]::Round(($i / $ToUninstall.Count) * 100, 2)
Write-Host "[INFO]: Uninstalling $($ToUninstall.Count) modules from $OneDriveModulesPath"
Write-Progress -Activity 'Uninstalling Modules' -Status 'Uninstalling Modules' -PercentComplete $Pct

ForEach ($Module in $ToUninstall) {
    $i++
    $Pct = [Math]::Round(($i / $ToUninstall.Count) * 100, 2)
    Write-Progress -Activity 'Uninstalling Modules' -Status "Uninstalling $($Module.Name)" -PercentComplete $Pct

    Write-Host "[INFO]: Attempting to Uninstall $($Module.Name) with PowerShellGet"

    try {
        Uninstall-Module -Name $Module.Name -Force -Verbose -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    } catch {
        Write-Host "[WARNING]: Failed to Uninstall $($Module.Name) with PowerShellGet."
        Write-Host '[INFO]: Attempting to uninstall with Microsoft.PowerShell.PSResourceGet...'
        try {
            Uninstall-PSResource -Name $Module.Name -Force -SkipDependencyCheck -Verbose -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        } catch {
            Write-Error "[ERROR]: Failed to uninstall $($Module.Name) with Microsoft.PowerShell.PSResourceGet."
        } finally {
            if (Test-Path -Path $Module.FullName) {
                Write-Host "[INFO]: Removing $($Module.Name) directory..."
                Remove-Item -Path $Module.FullName -Recurse -Force
            }
        }
    } finally {
        Write-Host "[INFO]: Removing $($Module.Name) directory..."
        Remove-Item -Path $Module.FullName -Recurse -Force
    }
    Write-Progress -Activity 'Uninstalling Modules' -Status "Uninstalling $($Module.Name)" -PercentComplete $Pct
}
Write-Progress -Activity 'Uninstalling Modules' -Status 'Uninstalling Modules' -Completed

Write-Host "Checking for leftover directories in $OneDriveModulesPath"
$Leftovers = Get-ChildItem -Path $OneDriveModulesPath -Directory
if ($Leftovers) {
    Write-Host '[WARNING]: The following directories were not uninstalled:'
    $Leftovers | ForEach-Object { Write-Host $_.Name }
    Write-Host '[INFO]: Removing leftover directories...'
    $Leftovers | Remove-Item -Recurse -Force
}

# -------------------------------------------
# Install Modules
# -------------------------------------------
Import-Module Microsoft.PowerShell.PSResourceGet
Install-PSResource -RequiredResourceFile "$PSScriptRoot\Modules\PowerShell.Modules.psd1" -Force -Verbose -Scope CurrentUser -AcceptLicense -OutVariable InstalledModules

$ProfileRootDir = $PROFILE.CurrentUserAllHosts | Split-Path -Parent

Install-PSResource -RequiredResourceFile "$HOME\Documents\PowerShell\Modules\PowerShell.Modules.psd1" -Force -Verbose -Scope CurrentUser -AcceptLicense -OutVariable InstalledModules


# -------------------------------------------
# Update Modules
