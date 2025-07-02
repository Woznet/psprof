if (Get-Command rig -Type Application -ErrorAction SilentlyContinue) {

    $RigInstallPath = Split-Path -Path (Get-Command rig).Source -Parent
    $RigCompletion = Join-Path -Path $RigInstallPath -ChildPath '_rig.ps1'

    if (Test-Path -Path $RigCompletion -PathType Leaf) {
        & $RigCompletion
    }

    Remove-Variable -Name RigInstallPath -ErrorAction SilentlyContinue
    Remove-Variable -Name RigCompletion -ErrorAction SilentlyContinue
}
