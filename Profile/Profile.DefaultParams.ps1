# Default Parameters
$PSDefaultParameterValues = @{
    "Update-Module:Confirm"         = $False
    "Update-Module:Force"           = $True
    "Update-Module:Scope"           = "CurrentUser"
    "Update-Module:ErrorAction"     = "SilentlyContinue"
    "Update-PSResource:Confirm"     = $False
    "Update-PSResource:Force"       = $True
    "Update-PSResource:ErrorAction" = "SilentlyContinue"
    "Update-Help:Force"             = $True
    "Update-Help:ErrorAction"       = "SilentlyContinue"
}

# Ensure default parameter values are appropriate
