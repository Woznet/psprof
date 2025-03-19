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

        # Load the completion script
        . $ScriptPath

        # Get the completer function that was just loaded
        $completerFunction = Get-Item "Function:*" | Where-Object {
            $_.ScriptBlock.ToString() -match "Register-ArgumentCompleter.*$CommandName"
        } | Select-Object -First 1

        if ($completerFunction) {
            Write-Verbose "Found completer function: $($completerFunction.Name)"

            # Get the actual completer scriptblock
            $completer = Get-ArgumentCompleter -CommandName $CommandName -ErrorAction SilentlyContinue

            if ($completer) {
                Write-Verbose "Running completer for $CommandName"
                # Run the completer
                & $completer.ScriptBlock $commandName $parameterName $wordToComplete $commandAst $fakeBoundParameters
            } else {
                Write-Verbose "No completer found for $CommandName after loading script"
                # Return empty array as fallback
                @()
            }
        } else {
            Write-Verbose "No completer function found for $CommandName in loaded script"
            # Return empty array as fallback
            @()
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
