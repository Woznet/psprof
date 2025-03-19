Function ShortenPath {
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    $VarsToShorten = @(
        'USERPROFILE',
        'APPDATA',
        'LOCALAPPDATA',
        'TEMP',
        'TMP',
        'PROGRAMFILES(x86)',
        'PROGRAMFILES',
        'PROGRAMW6432',
        'PROGRAMDATA',
        'COMMONPROGRAMFILES(x86)',
        'COMMONPROGRAMFILES',
        'COMMONPROGRAMW6432',
        'SYSTEMROOT',
        'SYSTEMDRIVE'
    )

    ForEach ($Var in $VarsToShorten) {
        $ReplaceWith = NormalizePath([System.Environment]::GetEnvironmentVariable($Var))

        if ($Path.StartsWith($ReplaceWith, 'CurrentCultureIgnoreCase')) {
            $Path = "%$Var%$($Path.Substring($ReplaceWith.Length))"
        }
    }

    return $Path
}
