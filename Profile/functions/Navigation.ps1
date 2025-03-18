# Navigation functions for common locations and directory traversal
Function Set-LocationDesktop {
    try {
        Set-Location -Path "$env:USERPROFILE\Desktop"
    } catch {
        Write-Error "Failed to set location to Desktop: $_"
    }
}

Function Set-LocationDownloads {
    try {
        Set-Location -Path "$env:USERPROFILE\Downloads"
    } catch {
        Write-Error "Failed to set location to Downloads: $_"
    }
}

Function Set-LocationDocuments {
    try {
        Set-Location -Path "$env:USERPROFILE\Documents"
    } catch {
        Write-Error "Failed to set location to Documents: $_"
    }
}

Function Set-LocationPictures {
    try {
        Set-Location -Path "$env:USERPROFILE\Pictures"
    } catch {
        Write-Error "Failed to set location to Pictures: $_"
    }
}

Function Set-LocationMusic {
    try {
        Set-Location -Path "$env:USERPROFILE\Music"
    } catch {
        Write-Error "Failed to set location to Music: $_"
    }
}

Function Set-LocationVideos {
    try {
        Set-Location -Path "$env:USERPROFILE\Videos"
    } catch {
        Write-Error "Failed to set location to Videos: $_"
    }
}

Function Set-LocationDevDrive {
    try {
        Set-Location -Path 'Dev:'
    } catch {
        Write-Error "Failed to set location to DevDrive: $_"
    }
}

Function cd... {
    try {
        Set-Location -Path '..\..'
    } catch {
        Write-Error "Failed to change directory: $_"
    }
}

Function cd.... {
    try {
        Set-Location -Path '..\..\..'
    } catch {
        Write-Error "Failed to change directory: $_"
    }
}

# Drive shortcuts
Function HKLM: {
    try {
        Set-Location HKLM:
    } catch {
        Write-Error "Failed to set location to HKLM: $_"
    }
}

Function HKCU: {
    try {
        Set-Location HKCU:
    } catch {
        Write-Error "Failed to set location to HKCU: $_"
    }
}

Function Env: {
    try {
        Set-Location Env:
    } catch {
        Write-Error "Failed to set location to Env: $_"
    }
}
