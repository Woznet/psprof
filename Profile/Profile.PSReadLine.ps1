<#
    .SYNOPSIS
    Current User, All Hosts PowerShell `$PROFILE`: `Profile.PSReadLine.ps1`
#>
#Requires -Modules PSReadLine

using namespace System.Management.Automation
using namespace System.Management.Automation.Language

if (Get-Module -ListAvailable -Name PSReadLine) {
    try {
        Import-Module PSReadLine

        # Set Default Params for Set-PSReadLineOption and Set-PSReadLineKeyHandler
        $PSDefaultParameterValues = @{
            "Set-PSReadLineOption:WarningAction"     = 'SilentlyContinue'
            "Set-PSReadLineOption:ErrorAction"       = 'SilentlyContinue'
            "Set-PSReadLineKeyHandler:WarningAction" = 'SilentlyContinue'
            "Set-PSReadLineKeyHandler:ErrorAction"   = 'SilentlyContinue'
        }

        # --------------------------------------------------------------------
        # PSReadLine Options
        # --------------------------------------------------------------------

        # Set PSReadLine Options's (Beta Version Required)

        # Edit Mode
        Set-PSReadLineOption -EditMode Windows

        # Predictive Intellisense
        Set-PSReadLineOption -PredictionSource HistoryAndPlugin

        # ListView
        Set-PSReadLineOption -PredictionViewStyle ListView

        # History Search
        Set-PSReadLineOption -HistorySearchCursorMovesToEnd

        # --------------------------------------------------------------------
        # PSReadLine Key Bindings
        # --------------------------------------------------------------------

        Set-PSReadLineKeyHandler -Key 'UpArrow' -Function 'HistorySearchBackward'
        Set-PSReadLineKeyHandler -Key 'DownArrow' -Function 'HistorySearchForward'
        Set-PSReadLineKeyHandler -Key 'Alt+RightArrow' -Function 'AcceptNextSuggestionWord'
        Set-PSReadLineKeyHandler -Key 'Ctrl+Home' -Function 'BeginningOfLine'
        Set-PSReadLineKeyHandler -Key 'Ctrl+End' -Function 'EndOfLine'

        # F1 Help
        Set-PSReadLineKeyHandler -Key F1 `
            -BriefDescription CommandHelp `
            -LongDescription 'Open the help window for the current command' `
            -ScriptBlock {
            param($key, $arg)

            [AST]$ast = $null
            $tokens = $null
            $errors = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

            $commandAst = $ast.FindAll( {
                    $node = $args[0]
                    $node -is [CommandAst] -and
                    $node.Extent.StartOffset -le $cursor -and
                    $node.Extent.EndOffset -ge $cursor
                }, $true) | Select-Object -Last 1

            if ($commandAst -ne $null) {
                $commandName = $commandAst.GetCommandName()
                if ($commandName -ne $null) {
                    $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
                    if ($command -is [Management.Automation.AliasInfo]) {
                        $commandName = $command.ResolvedCommandName
                    }

                    if ($commandName -ne $null) {
                        #First try online
                        try {
                            Get-Help $commandName -Online -ErrorAction Stop
                        } catch [InvalidOperationException] {
                            if ($PSItem -notmatch 'The online version of this Help topic cannot be displayed') { throw }
                            Get-Help $CommandName -ShowWindow
                        }
                    }
                }
            }
        }

        # F7 Show Command History Window
        Set-PSReadLineKeyHandler -Key F7 `
            -BriefDescription History `
            -LongDescription 'Show command history' `
            -ScriptBlock {
            $pattern = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
            if ($pattern) {
                $pattern = [regex]::Escape($pattern)
            }

            $history = [System.Collections.ArrayList]@(
                $last = ''
                $lines = ''
                foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath)) {
                    if ($line.EndsWith('`')) {
                        $line = $line.Substring(0, $line.Length - 1)
                        $lines = if ($lines) {
                            "$lines`n$line"
                        } else {
                            $line
                        }
                        continue
                    }

                    if ($lines) {
                        $line = "$lines`n$line"
                        $lines = ''
                    }

                    if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
                        $last = $line
                        $line
                    }
                }
            )
            $history.Reverse()

            $command = $history | Out-GridView -Title History -PassThru
            if ($command) {
                [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
            }
        }

        # Capture Screen (Interactive Selection from Terminal via "Chord")
        Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen

        # Sometimes you want to get a property of invoke a member on what you've entered so far
        # but you need parens to do that.  This binding will help by putting parens around the current selection,
        # or if nothing is selected, the whole line.
        Set-PSReadLineKeyHandler -Key 'Alt+(' `
            -BriefDescription ParenthesizeSelection `
            -LongDescription 'Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis' `
            -ScriptBlock {
            param($key, $arg)

            $selectionStart = $null
            $selectionLength = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

            $line = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            if ($selectionStart -ne -1) {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
            } else {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
                [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
            }
        }

        # Each time you press Alt+', this key handler will change the token
        # under or before the cursor.  It will cycle through single quotes, double quotes, or
        # no quotes each time it is invoked.
        Set-PSReadLineKeyHandler -Key "Alt+'" `
            -BriefDescription ToggleQuoteArgument `
            -LongDescription 'Toggle quotes on the argument under the cursor' `
            -ScriptBlock {
            param($key, $arg)

            $ast = $null
            $tokens = $null
            $errors = $null
            $cursor = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

            $tokenToChange = $null
            foreach ($token in $tokens) {
                $extent = $token.Extent
                if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
                    $tokenToChange = $token

                    # If the cursor is at the end (it's really 1 past the end) of the previous token,
                    # we only want to change the previous token if there is no token under the cursor
                    if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext()) {
                        $nextToken = $foreach.Current
                        if ($nextToken.Extent.StartOffset -eq $cursor) {
                            $tokenToChange = $nextToken
                        }
                    }
                    break
                }
            }

            if ($tokenToChange -ne $null) {
                $extent = $tokenToChange.Extent
                $tokenText = $extent.Text
                if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"') {
                    # Switch to no quotes
                    $replacement = $tokenText.Substring(1, $tokenText.Length - 2)
                } elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'") {
                    # Switch to double quotes
                    $replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"'
                } else {
                    # Add single quotes
                    $replacement = "'" + $tokenText + "'"
                }

                [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                    $extent.StartOffset,
                    $tokenText.Length,
                    $replacement)
            }
        }

        Set-PSReadLineKeyHandler -Description 'Edit current directory with Visual Studio Code' -Chord Ctrl+Shift+e -ScriptBlock {
            if (Get-Command code-insiders -ErrorAction SilentlyContinue) { code-insiders . } else {
                code .
            }
        }

    } catch {
        Write-Error "Failed to configure PSReadLine: $_"
    }
} else {
    Write-Error "PSReadLine module is not installed."
}
