# LazyLoad-Functions.ps1
# Functions for lazy-loading PowerShell completions

function Register-LazyCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$CommandName,

        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    Write-Verbose "Registering lazy completion for $CommandName from $ScriptPath"

    # Create a function that will load the completion when the command is first used
    $scriptBlock = {
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        Write-Verbose "Lazy-loading completion for $commandName"

        # First, unregister this lazy completer to avoid infinite loops
        try {
            [System.Management.Automation.CommandCompletion]::RemoveArgumentCompleter($commandName, $null)
        } catch {
            # Ignore errors - this method might not exist in all PS versions
        }

        # Load the completion script
        . $ScriptPath

        # Now get the newly registered completer and execute it
        $completer = Get-ArgumentCompleter | Where-Object { $_.CommandName -eq $commandName }

        if ($completer) {
            Write-Verbose "Found registered completer for $commandName, executing it"
            # Execute the real completer
            & $completer.ScriptBlock $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters
        } else {
            Write-Verbose "No completer found for $commandName after loading script, trying native completer lookup"

            # For native completers, we need to look in a different place
            # Try to invoke tab completion directly after the script has loaded
            try {
                # Use PowerShell's built-in completion system
                $results = [System.Management.Automation.CommandCompletion]::CompleteInput(
                    "$commandName $wordToComplete",
                    "$commandName $wordToComplete".Length,
                    $null
                )
                return $results.CompletionMatches
            } catch {
                Write-Verbose "Failed to get completions for $commandName after loading: $_"
                # Return empty array as fallback
                @()
            }
        }
    }

    # Register the lazy-loading completer
    Register-ArgumentCompleter -CommandName $CommandName -ScriptBlock $scriptBlock
    Write-Verbose "Registered lazy completion for $CommandName"
}

function Register-CommonCompletions {
    [CmdletBinding()]
    param(
        [string]$CompletionPath = (Join-Path -Path $ProfileSourcePath -ChildPath "Completions")
    )

    if (-not (Test-Path -Path $CompletionPath)) {
        Write-Warning "Completion path not found: $CompletionPath"
        return
    }

    $completionFiles = Get-ChildItem -Path $CompletionPath -Filter "*.ps1" -ErrorAction SilentlyContinue

    if (-not $completionFiles -or $completionFiles.Count -eq 0) {
        Write-Warning "No completion files found in $CompletionPath"
        return
    }

    Write-Verbose "Found $($completionFiles.Count) completion files"

    # Common commands to register completions for
    $commonCommands = @{
        "docker" = $completionFiles | Where-Object { $_.Name -like "*docker*.ps1" } | Select-Object -First 1
        "git" = $completionFiles | Where-Object { $_.Name -like "*git*.ps1" } | Select-Object -First 1
        "winget" = $completionFiles | Where-Object { $_.Name -like "*winget*.ps1" } | Select-Object -First 1
        "scoop" = $completionFiles | Where-Object { $_.Name -like "*scoop*.ps1" } | Select-Object -First 1
        "gh" = $completionFiles | Where-Object { $_.Name -like "*gh*.ps1" } | Select-Object -First 1
    }

    foreach ($command in $commonCommands.Keys) {
        $completionFile = $commonCommands[$command]
        if ($completionFile) {
            Write-Verbose "Registering lazy completion for $command from $($completionFile.FullName)"
            Register-LazyCompletion -CommandName $command -ScriptPath $completionFile.FullName
        }
    }
}
