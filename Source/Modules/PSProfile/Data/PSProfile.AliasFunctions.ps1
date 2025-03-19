# Navigation Alias Functions
${function:Set-ParentLocation} = { Set-Location .. }
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Common Directory Alias Functions
${function:~} = { Set-Location $HOME }
${function:Set-LocationUserBinDir} = { Set-Location $HOME\bin }
${function:toolsdir} = { Set-Location $HOME\tools }
${function:devdir} = { Set-Location $HOME\Dev }
${function:dotsdir} = { Set-Location $HOME\Dev }
${function:docsdir} = { Set-Location $HOME\Documents }
${function:downloadsdir} = { Set-Location $HOME\Downloads }
${function:desktopdir} = { Set-Location $HOME\Desktop }
${function:onedrivedir} = { Set-Location "$HOME\OneDrive" }
${function:wsldrivedir} = { Set-Location '\\wsl.localhost\' }

# Networking Alias Functions
${function:Get-ProcessUsingPort} = { Get-Process -IncludeUserName | Where-Object { $_.TCPConnections -and $_.UDPConnections } }

# Notepad
${function:np} = { notepad.exe }
