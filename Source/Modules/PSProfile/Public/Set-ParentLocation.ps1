Function Set-ParentLocation {
    <#
    .SYNOPSIS
        Set the location to the parent directory.
    .DESCRIPTION
        This function sets the location to the parent directory.
    .PARAMETER Depth
        The number of parent directories to move up. Default is 1.
    .EXAMPLE
        Set-ParentLocation
        # Set the location to the parent directory.
    .EXAMPLE
        Set-ParentLocation -Depth 2
        # Set the location to the grandparent directory.
    .LINK
        Get-Location
        Split-Path
        Set-Location
    #>
    [CmdletBinding()]
    Param (
        [int]$Depth = 1
    )

    Process {
        $Path = Get-Location
        for ($i = 0; $i -lt $Depth; $i++) {
            $Path = $Path | Split-Path
        }

        Set-Location $Path
    }
}
