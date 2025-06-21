Function Test-Email {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Email
    )

    if ($Email -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') {
        return $true
    } else {
        return $false
    }
}
