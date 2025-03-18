
# ---------------------------------------------------------------
# Current User, Current Host VSCode Specific Powershell $PROFILE:
# ---------------------------------------------------------------

# Ensure User Environment PATH Variables are loaded
if (-not $env:Path.Contains([System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User))) {
  $env:Path += [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
}







