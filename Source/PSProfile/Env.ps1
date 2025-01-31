$PSProfilePath = $PROFILE.CurrentUserAllHosts | Split-Path -Parent
$PSProfileSourcePath = Join-Path $PSProfilePath -ChildPath "Source" -AdditionalChildPath "PSProfile"
$PSProfilePublicPath = Join-Path $PSProfileSourcePath -ChildPath "Public"
$PSProfilePrivatePath = Join-Path $PSProfileSourcePath -ChildPath "Private"
$PSProfileDataPath = Join-Path $PSProfileSourcePath -ChildPath "Data"
