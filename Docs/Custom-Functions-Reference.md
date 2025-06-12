# PowerShell Profile Custom Functions Reference

This document provides a comprehensive list of every custom defined function used in the PowerShell profile setup, organized by functional categories.

## Core Profile Functions

### Profile Management
- `Write-ProfileLog` - Logging functionality for profile operations
- `Initialize-DebugLog` - Sets up debug logging
- `Measure-ProfileBlock` - Performance measurement for profile components
- `Invoke-ProfileReload` - Reloads the PowerShell profile
- `Edit-PSProfile` - Opens profile for editing
- `Edit-PSProfileProject` - Opens profile project in editor

### Lazy Loading & Performance
- `Register-LazyCompletion` - Registers lazy-loaded tab completions
- `Register-LazyModule` - Registers lazy-loaded modules
- `Global:TabExpansion2` - Custom tab expansion handler
- `Measure-ScriptBlock` - Measures script block execution time

## Navigation Functions

### Directory Navigation
- `Set-LocationParent` - Navigate to parent directory (`..`)
- `Set-LocationRoot` - Navigate to root directory
- `Set-LocationHome` - Navigate to home directory
- `Set-LocationBin` - Navigate to user's bin directory
- `Set-LocationTools` - Navigate to user's tools directory
- `Set-LocationTemp` - Navigate to temporary directory
- `Set-LocationConfig` - Navigate to configuration directory
- `Set-LocationOneDrive` - Navigate to OneDrive directory
- `Set-LocationDotFiles` - Navigate to dotfiles directory
- `Set-LocationDesktop` - Navigate to desktop
- `Set-LocationDownloads` - Navigate to downloads
- `Set-LocationDocuments` - Navigate to documents
- `Set-LocationPictures` - Navigate to pictures
- `Set-LocationMusic` - Navigate to music
- `Set-LocationVideos` - Navigate to videos
- `Set-LocationDevDrive` - Navigate to development drive

### Simple Navigation Aliases
- `Documents` - Quick navigation to Documents folder
- `Desktop` - Quick navigation to Desktop folder
- `Downloads` - Quick navigation to Downloads folder
- `Temp` - Quick navigation to temp folder
- `cd...` - Go up two directory levels
- `cd....` - Go up three directory levels
- `HKLM:` - Navigate to HKEY_LOCAL_MACHINE registry
- `HKCU:` - Navigate to HKEY_CURRENT_USER registry
- `Env:` - Navigate to environment variables

## System Information Functions

### System Utilities
- `Get-PublicIP` - Retrieves public IP address
- `Get-Timestamp` - Gets current timestamp
- `Get-RandomPassword` - Generates random passwords
- `Get-SystemUptime` - Gets system uptime information
- `Get-PCUptime` - Gets PC uptime
- `Get-PCInfo` - Gets comprehensive PC information
- `Get-WindowsBuild` - Gets Windows build information
- `Get-IPv4NetworkInfo` - Gets IPv4 network information
- `Get-ProcessUsingPort` - Finds processes using specific ports
- `Get-Printers` - Lists available printers
- `Get-RebootLogs` - Gets system reboot logs

### Environment Management
- `Get-EnvironmentVariables` - Gets environment variables with analysis
- `Get-EnvVarsFromScope` - Gets environment variables from specific scope
- `Expand-PathVariable` - Expands PATH variable entries
- `Compare-PathVariables` - Compares PATH variables across scopes
- `Update-Environment` - Updates entire environment
- `Update-SessionEnvironment` - Updates session environment variables

## File System Functions

### File Operations
- `Get-FolderSize` - Gets folder size information
- `Get-FileOwner` - Gets file ownership information
- `Get-ChildItemColor` - Enhanced directory listing with colors
- `Get-SourceCode` - Downloads source code from repositories

### Hash Functions
- `Get-MD5Hash` - Calculates MD5 hash
- `Get-SHA1Hash` - Calculates SHA1 hash
- `Get-SHA256Hash` - Calculates SHA256 hash

## Application Management

### Application Functions
- `Get-Applications` - Lists installed applications
- `Remove-Application` - Removes applications
- `Start-GitKraken` - Starts GitKraken application
- `Start-RStudio` - Starts RStudio application
- `Invoke-Notepad` - Opens Notepad

### Package Management
- `Update-Chocolatey` - Updates Chocolatey packages
- `Update-Scoop` - Updates Scoop packages
- `Update-Python` - Updates Python packages
- `Update-Node` - Updates Node.js packages
- `Update-R` - Updates R packages
- `Update-Pip` - Updates Pip packages
- `Update-Windows` - Updates Windows
- `Update-WinGet` - Updates WinGet
- `Update-PSModules` - Updates PowerShell modules
- `Update-AllPSResources` - Updates all PowerShell resources

## PowerShell Module Functions

### Module Management
- `Get-DuplicatePSModules` - Finds duplicate PowerShell modules
- `Uninstall-DuplicatePSModules` - Removes duplicate modules
- `Get-DynamicAboutHelp` - Gets dynamic help content

## Administrative Functions

### System Administration
- `Test-AdminRights` - Tests for administrative privileges
- `Invoke-Admin` - Runs commands as administrator
- `Mount-DevDrive` - Mounts development drive
- `Reset-NetworkStack` - Resets network stack
- `Reset-NetworkAdapter` - Resets network adapter
- `Remove-TempFiles` - Removes temporary files
- `Set-PowerPlan` - Sets power plan
- `Stop-SelectedProcess` - Stops selected processes
- `Invoke-TakeOwnership` - Takes ownership of files/folders
- `Invoke-TakeOwnershipWindowsApps` - Takes ownership of Windows apps
- `Invoke-DISM` - Runs DISM operations
- `Invoke-SFC` - Runs System File Checker
- `Get-SFCLogs` - Gets SFC logs
- `Invoke-CheckDisk` - Runs check disk
- `Get-WinSAT` - Gets Windows System Assessment Tool results

## Utility Functions

### Helper Functions
- `Import-Completion` - Imports tab completions
- `Import-AliasFile` - Imports alias files
- `Search-History` - Searches command history
- `Get-GitHubRateLimits` - Gets GitHub API rate limits
- `Remove-GitHubWorkflowRuns` - Removes GitHub workflow runs
- `Write-OperationStatus` - Writes operation status messages
- `Invoke-EnvVarAIAnalysis` - AI analysis of environment variables

## Testing Functions

### Test Utilities
- `Test-Internet` - Tests internet connectivity
- `Test-Admin` - Tests administrative privileges
- `Test-Command` - Tests if commands exist
- `Test-ServiceRunning` - Tests if services are running
- `Test-PSGallery` - Tests PowerShell Gallery connectivity
- `Test-SSHKey` - Tests SSH key functionality
- `Test-GPGKey` - Tests GPG key functionality
- `Test-Email` - Tests email functionality

## Specialized Functions

### System Optimization
- `Optimize-DefenderExclusions` - Optimizes Windows Defender exclusions
- `Remove-OldDrivers` - Removes old drivers
- `Clean-ProfileRepository` - Cleans profile repository

### Installation Functions
- `Install-OhMyPosh` - Installs Oh My Posh
- `Install-NerdFont` - Installs Nerd Fonts

---

**Note**: This reference is generated from the PowerShell profile codebase as of June 11, 2025. Functions are organized by category for easy navigation and reference. Each function includes a brief description of its purpose and functionality.

For detailed usage information, parameter details, and examples, refer to the individual function definitions in the source code or use `Get-Help <FunctionName>` in PowerShell.
