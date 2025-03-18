#Requires -Modules Microsoft.PowerShell.Utility

<#
  .SYNOPSIS
    This script is executed when a new PowerShell session is created for the current user, on any host.
  .PARAMETER DisableCompletions
    Disables loading of completion scripts.
  .PARAMETER DisableLazyLoad
    Disables lazy loading of completions and loads them all immediately.
#>
Param(
  [Switch]$DisableCompletions,
  [Switch]$DisableLazyLoad
)

Begin {
  Write-Verbose "[BEGIN]: Profile.Completions.ps1"

  # Import LazyLoad functions
  $lazyLoadFunctionsPath = Join-Path -Path $ProfileRootPath -ChildPath "Profile/Functions/Private/LazyLoad-Functions.ps1"
  if (Test-Path -Path $lazyLoadFunctionsPath) {
    . $lazyLoadFunctionsPath
    Write-Verbose "Imported LazyLoad functions from $lazyLoadFunctionsPath"
  } else {
    Write-Warning "LazyLoad functions file not found: $lazyLoadFunctionsPath"
  }

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

  if ($DisableLazyLoad) {
    # Load all completions immediately
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
  } else {
    # Use lazy loading for completions
    Write-Verbose "Setting up lazy loading for completions"

    # Register common completions for lazy loading
    $commonCommands = @{
      "docker" = $completionFiles | Where-Object { $_.Name -like "*docker*.ps1" } | Select-Object -First 1
      "git"    = $completionFiles | Where-Object { $_.Name -like "*git*.ps1" } | Select-Object -First 1
      "winget" = $completionFiles | Where-Object { $_.Name -like "*winget*.ps1" } | Select-Object -First 1
      "scoop"  = $completionFiles | Where-Object { $_.Name -like "*scoop*.ps1" } | Select-Object -First 1
      "gh"     = $completionFiles | Where-Object { $_.Name -like "*gh*.ps1" } | Select-Object -First 1
    }

    foreach ($command in $commonCommands.Keys) {
      $completionFile = $commonCommands[$command]
      if ($completionFile) {
        Write-Verbose "Registering lazy completion for $command"
        Register-LazyCompletion -CommandName $command -ScriptPath $completionFile.FullName
      }
    }
  }
}

End {
  Write-Verbose "[END]: Profile.Completions.ps1"
}
