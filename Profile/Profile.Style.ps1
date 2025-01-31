# ------------------------------------------------------------
# Profile.Style.ps1 - PowerShell $PSStyle Configuration
# ------------------------------------------------------------

# --------------------------------------------------------------------
# VSCode Default Dark Theme
# --------------------------------------------------------------------

if ($PSStyle) {
    try {
        #Enable new fancy progress bar for Windows Terminal
        if ($ENV:WT_SESSION) {
            $PSStyle.Progress.UseOSCIndicator = $true
        }

        & {
            $FG = $PSStyle.Foreground
            $Format = $PSStyle.Formatting
            $PSStyle.FileInfo.Directory = $FG.Blue
            $PSStyle.Progress.View = 'Minimal'
            $PSStyle.Progress.UseOSCIndicator = $true
            $DefaultColor = $FG.White
            $Format.Debug = $FG.Magenta
            $Format.Verbose = $FG.Cyan
            $Format.Error = $FG.BrightRed
            $Format.Warning = $FG.Yellow
            $Format.FormatAccent = $FG.BrightBlack
            $Format.TableHeader = $FG.BrightBlack
            $DarkPlusTypeGreen = "`e[38;2;78;201;176m" #4EC9B0 Dark Plus Type color
            Set-PSReadLineOption -Colors @{
                Error     = $Format.Error
                Keyword   = $FG.Magenta
                Member    = $FG.BrightCyan
                Parameter = $FG.BrightCyan
                Type      = $DarkPlusTypeGreen
                Variable  = $FG.BrightCyan
                String    = $FG.Yellow
                Operator  = $DefaultColor
                Number    = $FG.BrightGreen

                # These colors should be standard
                # Command            = "$e[93m"
                # Comment            = "$e[32m"
                # ContinuationPrompt = "$e[37m"
                # Default            = "$e[37m"
                # Emphasis           = "$e[96m"
                # Number             = "$e[35m"
                # Operator           = "$e[37m"
                # Selection          = "$e[37;46m"
            }
        }
    } catch {
        Write-Error "Failed to configure PowerShell styles: $_"
    }
} else {
    Write-Error "\$PSStyle is not available."
    #Legacy PS5.1 Configuration
    #ANSI Escape Character
    $e = [char]0x1b
    $host.PrivateData.DebugBackgroundColor = 'Black'
    $host.PrivateData.DebugForegroundColor = 'Magenta'
    $host.PrivateData.ErrorBackgroundColor = 'Black'
    $host.PrivateData.ErrorForegroundColor = 'Red'
    $host.PrivateData.ProgressBackgroundColor = 'DarkCyan'
    $host.PrivateData.ProgressForegroundColor = 'Yellow'
    $host.PrivateData.VerboseBackgroundColor = 'Black'
    $host.PrivateData.VerboseForegroundColor = 'Cyan'
    $host.PrivateData.WarningBackgroundColor = 'Black'
    $host.PrivateData.WarningForegroundColor = 'DarkYellow'

    Set-PSReadLineOption -Colors @{
        Command            = "$e[93m"
        Comment            = "$e[32m"
        ContinuationPrompt = "$e[37m"
        Default            = "$e[37m"
        Emphasis           = "$e[96m"
        Error              = "$e[31m"
        Keyword            = "$e[35m"
        Member             = "$e[96m"
        Number             = "$e[35m"
        Operator           = "$e[37m"
        Parameter          = "$e[37m"
        Selection          = "$e[37;46m"
        String             = "$e[33m"
        Type               = "$e[34m"
        Variable           = "$e[96m"
    }

    Remove-Variable e
}

[Console]::Title = if ($ENV:WT_SESSION) {
    #Short title for Windows Terminal since we have an icon that lets us already know its PowerShell
    "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
} elseif ($ENV:AZUREPS_HOST_ENVIRONMENT -like 'cloud-shell*') {
    #Best way I found to get the tenant name of where cloud shell is running
    "$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor) $((Get-AzTenant -TenantId (Get-AzSubscription -SubscriptionId (Get-SubscriptionIdFromStorageProfile)).HomeTenantId).Name)"
} else {
    "PowerShell $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
}
