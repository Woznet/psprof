@{
    # Edit Mode
    EditMode = 'Windows'

    # History No Duplicates
    HistoryNoDuplicates = $true

    # History Search Cursor Moves To End
    HistorySearchCursorMovesToEnd = $true

    # Prediction Source
    PredictionSource = 'HistoryAndPlugin'

    # Prediction View Style
    PredictionViewStyle = 'ListView'

    # Colors
    Colors = @{
        Error = 'Red'
        Keyword = 'Magenta'
        Member = 'Cyan'
        Parameter = 'Cyan'
        Type = '#4EC9B0'  # Custom color: Dark Plus Type color
        Variable = 'Cyan'
        String = 'Yellow'
        Operator = 'White'
        Number = 'Green'
    }

    # Key Bindings
    KeyBindings = @(
        @{
            Key = 'UpArrow'
            Function = 'HistorySearchBackward'
        },
        @{
            Key = 'DownArrow'
            Function = 'HistorySearchForward'
        },
        @{
            Key = 'Alt+RightArrow'
            Function = 'AcceptNextSuggestionWord'
        },
        @{
            Key = 'Ctrl+d,Ctrl+c'
            Function = 'CaptureScreen'
        },
        @{
            Key = 'Ctrl+Shift+e'
            Description = 'Edit current directory with Visual Studio Code'
            ScriptBlock = 'if (Get-Command code-insiders -ErrorAction SilentlyContinue) { code-insiders . } else { code . }'
        }
    )

    # Advanced Key Bindings
    AdvancedKeyBindings = @(
        @{
            Key = 'F1'
            BriefDescription = 'CommandHelp'
            LongDescription = 'Open the help window for the current command'
            ScriptPath = 'Profile/Config/PSReadLine.KeyBindings/F1-CommandHelp.ps1'
        },
        @{
            Key = 'F7'
            BriefDescription = 'History'
            LongDescription = 'Show command history'
            ScriptPath = 'Profile/Config/PSReadLine.KeyBindings/F7-History.ps1'
        },
        @{
            Key = 'Ctrl+Alt+v'
            BriefDescription = 'PasteAsHereString'
            LongDescription = 'Paste the clipboard text as a here string'
            ScriptPath = 'Profile/Config/PSReadLine.KeyBindings/CtrlAltV-PasteAsHereString.ps1'
        },
        @{
            Key = 'Alt+('
            BriefDescription = 'ParenthesizeSelection'
            LongDescription = 'Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis'
            ScriptPath = 'Profile/Config/PSReadLine.KeyBindings/AltParenthesis-ParenthesizeSelection.ps1'
        },
        @{
            Key = "Alt+'"
            BriefDescription = 'ToggleQuoteArgument'
            LongDescription = 'Toggle quotes on the argument under the cursor'
            ScriptPath = 'Profile/Config/PSReadLine.KeyBindings/AltQuote-ToggleQuoteArgument.ps1'
        }
    )
}
