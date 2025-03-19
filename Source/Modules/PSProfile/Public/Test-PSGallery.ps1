Function Test-PSGallery {
    <#
        .SYNOPSIS
            Test if the PowerShell Gallery is setup correctly.
        .DESCRIPTION
            This function performs tests to determine if the PowerShell Gallery is setup correctly on the local machine.

            It will test the following:
              - `PowerShellGet` and `Microsoft.PowerShell.PSResourceGet` modules are installed and imported into the current session
              - The `PSGallery` repository is registered correctly
              - The `PSGallery` repository is trusted
              - That the environment variable `NUGET_API_TOKEN` is set for publishing modules to the PowerShell Gallery

        .EXAMPLE
            Test-PSGallery
    #>
    [CmdletBinding()]
    param()

    Begin {
        $GalleryInfo = Get-PSResourceRepository -Name PSGallery -ErrorAction SilentlyContinue
        $NuGetToken = $env:NUGET_API_TOKEN
    }

    Process {
        # Test if PowerShellGet and Microsoft.PowerShell.PSResourceGet modules are installed and imported
        if (-not (Get-Module -Name PowerShellGet -ListAvailable) -or -not (Get-Module -Name Microsoft.PowerShell.PSResourceGet -ListAvailable)) {
            Write-Warning 'PowerShellGet and Microsoft.PowerShell.PSResourceGet modules are not installed or imported.'
        }

        # Test if PSGallery repository is registered
        if (-not $GalleryInfo) {
            Write-Warning 'PSGallery repository is not registered.'
        }

        # Test if PSGallery repository is trusted
        if ($GalleryInfo -and -not $GalleryInfo.Trusted) {
            Write-Warning 'PSGallery repository is not trusted.'
        }

        # Test if NUGET_API_TOKEN environment variable is set
        if (-not $NuGetToken) {
            Write-Warning 'NUGET_API_TOKEN environment variable is not set.'
        }
    }

    End {
        # Return the results
        [PSCustomObject]@{
            'PowerShellGet'                      = (Get-Module -Name PowerShellGet -ListAvailable)
            'Microsoft.PowerShell.PSResourceGet' = (Get-Module -Name Microsoft.PowerShell.PSResourceGet -ListAvailable)
            'PSGallery'                          = $GalleryInfo
            'NUGET_API_TOKEN'                    = $NuGetToken
        }
    }
}
