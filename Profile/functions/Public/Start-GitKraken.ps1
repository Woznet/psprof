<#
.SYNOPSIS
    Starts GitKraken
.DESCRIPTION
    Starts GitKraken with optional parameters
.PARAMETER Path
    Path to open in GitKraken
.PARAMETER NewTab
    Open in a new tab
.EXAMPLE
    Start-GitKraken
.EXAMPLE
    Start-GitKraken -Path C:\Projects\MyRepo
.EXAMPLE
    Start-GitKraken -Path C:\Projects\MyRepo -NewTab
#>
function Start-GitKraken {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Path,

        [Parameter()]
        [switch]$NewTab
    )

    process {
        $gitKrakenPath = Get-Command gitkraken.cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source

        if (-not $gitKrakenPath) {
            Write-Error "GitKraken not found in PATH"
            return
        }

        $arguments = @()

        if ($Path) {
            $resolvedPath = Resolve-Path $Path -ErrorAction SilentlyContinue
            if ($resolvedPath) {
                $arguments += "--path=`"$resolvedPath`""
            } else {
                Write-Warning "Path not found: $Path"
            }
        }

        if ($NewTab) {
            $arguments += "--new-tab"
        }

        Write-Verbose "Starting GitKraken with arguments: $arguments"
        Start-Process -FilePath $gitKrakenPath -ArgumentList $arguments
    }
}
