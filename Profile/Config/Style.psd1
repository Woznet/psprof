@{
    PSStyle = @{
        Progress = @{
            UseOSCIndicator = $true
            View = 'Minimal'
        }
        FileInfo = @{
            Directory = 'Blue'
        }
        Formatting = @{
            Debug = 'Magenta'
            Verbose = 'Cyan'
            Error = 'BrightRed'
            Warning = 'Yellow'
            FormatAccent = 'BrightBlack'
            TableHeader = 'BrightBlack'
        }
    }

    PSReadLine = @{
        Colors = @{
            Error = 'BrightRed'
            Keyword = 'Magenta'
            Member = 'BrightCyan'
            Parameter = 'BrightCyan'
            Type = 'DarkPlusTypeGreen'  # Custom color: #4EC9B0
            Variable = 'BrightCyan'
            String = 'Yellow'
            Operator = 'White'
            Number = 'BrightGreen'
        }
    }

    LegacyConsole = @{
        DebugBackgroundColor = 'Black'
        DebugForegroundColor = 'Magenta'
        ErrorBackgroundColor = 'Black'
        ErrorForegroundColor = 'Red'
        ProgressBackgroundColor = 'DarkCyan'
        ProgressForegroundColor = 'Yellow'
        VerboseBackgroundColor = 'Black'
        VerboseForegroundColor = 'Cyan'
        WarningBackgroundColor = 'Black'
        WarningForegroundColor = 'DarkYellow'
    }

    ConsoleTitle = @{
        WindowsTerminalFormat = '{0}.{1}'  # Will be formatted with PSVersion Major and Minor
        DefaultFormat = 'PowerShell {0}.{1}'  # Will be formatted with PSVersion Major and Minor
    }
}
