#Requires -Modules Microsoft.PowerShell.Utility

<#
  .SYNOPSIS
    This script is executed when a new PowerShell session is created for the current user, on any host.
  .PARAMETER DisableCompletions
    Disables loading of completion scripts.
#>
Param(
  [Switch]$DisableCompletions
)

Begin {
  Write-Verbose "[BEGIN]: Profile.Completions.ps1"
  $completionFiles = @()
  if ($DisableCompletions) {
    Write-Verbose "Completions are disabled. Skipping loading completions."
    return
  } else {
    $completionPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($profile), "Profile/completions")
    $completionFiles = Get-ChildItem -Path $completionPath -Filter "*.ps1"
    Write-Verbose "Discovered $($completionFiles.Count) completion scripts in $completionPath"
  }
}

Process {
  Write-Verbose "[PROCESS]: Profile.Completions.ps1"
  $numFiles = $completionFiles.Count
  $i = 0
  ForEach ($file in $completionFiles) {
    $pct = if ($numFiles -ne 0) { ($i / $numFiles) * 100 } else { 0 }
    Write-Progress -Activity "Loading completion scripts" -Status "Loading..." -PercentComplete $pct
    Write-Verbose "Loading completion script: $file"
    try {
      . $file.FullName
      Write-Progress -Activity "Loading completions" -Status "Loaded $($file.Name)"
    } catch {
      Write-Error "Failed to load completion script $($file.Name): $_"
    }
    $i++
  }
  Write-Progress -Activity "Loading completion scripts" -Completed
}

End {
  Write-Verbose "[END]: Profile.Completions.ps1"
}
