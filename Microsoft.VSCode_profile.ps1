
# ---------------------------------------------------------------
# Current User, Current Host VSCode/VSCode Insiders Powershell $PROFILE:
# ---------------------------------------------------------------

# Ensure User Environment PATH Variables are loaded
if (-not $env:Path.Contains([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User))) {
    $env:Path += [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
}

# Detect VSCode or VSCode Insiders
$isVSCodeInsiders = $env:TERM_PROGRAM -eq 'vscode-insiders' -or $Host.Name -match 'Visual Studio Code Insiders'
$isRegularVSCode = $env:TERM_PROGRAM -eq 'vscode' -or $Host.Name -match 'Visual Studio Code' -and -not $isVSCodeInsiders

# Set or preserve VSCode environment variable
if ($isVSCodeInsiders) {
    $env:TERM_PROGRAM = 'vscode-insiders'
    $env:VSCODE_EDITION = 'insiders'
} elseif ($isRegularVSCode) {
    $env:TERM_PROGRAM = 'vscode'
    $env:VSCODE_EDITION = 'stable'
}

# Set global variables for editor detection
if ($isVSCodeInsiders -or $isRegularVSCode) {
    $Global:isVSCode = $true
    $Global:isVSCodeInsiders = $isVSCodeInsiders
    $Global:isRegularVSCode = $isRegularVSCode
    $Global:isRegularPowerShell = $false
    $Global:isISE = $false
}

# VSCode/VSCode Insiders prompt
function prompt {
    $ESC = [char]27
    $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    $shortPath = $currentPath.Replace($HOME, "~")

    # Get git branch if in a git repo
    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $gitBranch = git branch --show-current 2>$null
            if ($gitBranch) {
                $gitBranch = " $ESC[36m($gitBranch)$ESC[0m"
            }
        } catch {
            # Ignore git errors
        }
    }

    # Show admin status
    $adminStatus = ""
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $adminStatus = " $ESC[31m[Admin]$ESC[0m"
    }

    # Show PS version
    $psVersion = "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"

    # Show VSCode edition if it's Insiders
    $editionTag = ""
    if ($Global:isVSCodeInsiders) {
        $editionTag = " $ESC[35m[Insiders]$ESC[0m"
    }

    # Return the prompt string
    "$ESC[34m$shortPath$ESC[0m$gitBranch$adminStatus$editionTag$ESC[90m PS$psVersion>$ESC[0m "
}

# Import PowerToys CommandNotFound module if available
# if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound) {
#   Import-Module -Name Microsoft.WinGet.CommandNotFound -ErrorAction SilentlyContinue
# }
