
# ---------------------------------------------------------------
# Current User, Current Host VSCode Specific Powershell $PROFILE:
# ---------------------------------------------------------------

# Ensure User Environment PATH Variables are loaded
if (-not $env:Path.Contains([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User))) {
  $env:Path += [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
}

# Set VSCode-specific environment variable to help with detection
$env:TERM_PROGRAM = 'vscode'

# VSCode-specific settings
if (-not (Get-Variable -Name isVSCode -ErrorAction SilentlyContinue)) {
  $Global:isVSCode = $true
  $Global:isRegularPowerShell = $false
  $Global:isISE = $false
}

# VSCode-specific prompt (simpler than oh-my-posh)
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

  # Return the prompt string
  "$ESC[34m$shortPath$ESC[0m$gitBranch$adminStatus$ESC[90m PS$psVersion>$ESC[0m "
}

# Import PowerToys CommandNotFound module if available
# if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound) {
#   Import-Module -Name Microsoft.WinGet.CommandNotFound -ErrorAction SilentlyContinue
# }
