
# ---------------------------------------------------------------
# Current User, Current Host VSCode Specific Powershell $PROFILE:
# ---------------------------------------------------------------

# Ensure User Environment PATH Variables are loaded
if (-not $env:Path.Contains([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User))) {
  $env:Path += [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
}

# Define the Update-Profile function
function Update-Profile {
    param (
        [string]$ProfilePath
    )
    # Implementation of Update-Profile
    Write-Output "Updating profile at $ProfilePath"
}

# Define the Edit-Profile function
function Edit-Profile {
    param (
        [string]$ProfilePath
    )
    # Implementation of Edit-Profile
    Write-Output "Editing profile at $ProfilePath"
}






