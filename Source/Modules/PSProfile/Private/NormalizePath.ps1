Function NormalizePath {
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Path
    )

    if ($Path.EndsWith(':')) {
        $Path = $Path + '\'
    }

    $path = [System.IO.Path]::Combine(((Get-Location).Path), ($path))
    $path = [System.IO.Path]::GetFullPath($path)
    $path = $path.TrimEnd('\')

    return $path
}
