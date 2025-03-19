Function Test-ServiceRunning {
    <#
    .SYNOPSIS
        Tests if a service or services are running.
    .DESCRIPTION
        This function tests if a service or multiple services are running and returns a boolean value depending on
        the result.
    .PARAMETER Name
        The name of the service or services to test.
    .EXAMPLE
        Test-ServiceRunning -Name 'Spooler'
    .EXAMPLE
        Test-ServiceRunning -Name 'Spooler', 'LanmanServer'
    .EXAMPLE
        # Wildcard Support
        Test-ServiceRunning -Name 'Spooler', '*WSL*'
    .OUTPUTS
        [System.Boolean] Returns $True if all services are running, otherwise $False.
    .NOTES
        This function is designed to be used in a pipeline or as an assertion in a script/function that depends on
        the status of a service or services.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String[]]$Name
    )

    Begin {

        $Services = Get-Service -Name $Name -ErrorAction SilentlyContinue

        if (-not $Services) {
            Write-Error "Service not found: $Name"
            return
        }

        $Out = @()
    }

    Process {

        $Out += $Services | ForEach-Object {
            if ($_.Status -eq 'Running') {
                Write-Host "$($_.Name) is running" -ForegroundColor Green
                $True
            } else {
                Write-Host "$($_.Name) is not running" -ForegroundColor Red
                $False
            }
        }
    }

    End {
        if ($Out -contains $False) {
            return $False
        } else {
            return $True
        }
    }
}
