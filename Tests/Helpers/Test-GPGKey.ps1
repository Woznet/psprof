Function Test-GPGKey {
    <#
        .SYNOPSIS
            Tests if a GPG key exists.
        .DESCRIPTION
            This function tests if a GPG key exists.
        .PARAMETER Key
            The key to test.
        .EXAMPLE
            Test-GPGKey -Key '0x1234567890ABCDEF'
        .NOTES
            This function wraps the `gpg --list-keys` command.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$Key
    )

    Begin {
        if (-not (Get-Command -Name 'gpg' -ErrorAction SilentlyContinue)) {
            Write-Error "GPG is not installed. Please install GPG and try again."
            return
        }
        $Cmd = "& gpg --list-keys $Key"
    }

    Process {
        $Out = Invoke-Expression -Command $Cmd
    }

    End {
        if ($Out -match 'pub') {
            Write-Host "Key $Key exists" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Key $Key does not exist" -ForegroundColor Red
            return $false
        }
    }
}
