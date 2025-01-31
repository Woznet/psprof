<#
.SYNOPSIS
    Default parameters for PSProfile.
#>

@{
    # Update-Module
    'Update-Module:Confirm'     = $False
    'Update-Module:Force'       = $True
    'Update-Module:Scope'       = 'CurrentUser'
    'Update-Module:ErrorAction' = 'SilentlyContinue'
    
    # Update Help
    'Update-Help:Force'         = $True
    'Update-Help:ErrorAction'   = 'SilentlyContinue'

    # PWSHModule
    '*PWSHModule*:GitHubUserID' = 'jimbrig'
    '*PWSHModule*:PublicGist' = $true
    '*PWSHModule*:Scope' = 'AllUsers'

}


$PSDefaultParameterValues = @{
    
}