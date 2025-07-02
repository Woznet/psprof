Function Test-SSHKey {
    <#
        .SYNOPSIS
            Tests if an SSH key exists.
        .DESCRIPTION
            This function tests if an SSH key exists.
        .PARAMETER Key
            The key to test.
        .EXAMPLE
            Test-SSHKey -Key 'id_rsa'
        .NOTES
            This function wraps the `Test-Path` command.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$Key
    )

    Begin {
        if ((Get-Service -Name ssh-agent).Status -ne 'Running') {
            Write-Warning "SSH Agent is not running. Please start the SSH Agent and try again."
            return
        }
        if (-not (Get-Command -Name 'ssh' -ErrorAction SilentlyContinue)) {
            Write-Error "SSH is not installed. Please install SSH and try again."
            return
        }
        if (-not (Test-Path -Path "$HOME\.ssh")) {
            Write-Error "SSH directory not found at $HOME\.ssh"
            return
        }
        $Path = "$HOME\.ssh\$Key"
    }

    Process {
        if (Test-Path -Path $Path) {
            Write-Host "Key $Key exists" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Key $Key does not exist" -ForegroundColor Red
            return $false
        }
    }
}
