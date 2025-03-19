Register-ArgumentCompleter -Native -CommandName * -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    # Try to load the completion script for the typed command
    Load-Completion -CommandName $commandName

    # Returning nothing here; the actual completion is handled by the script if it exists
    return $null
}

$Script:CompletionLoaded = @{}

