Function DayLight {
    <#
    .SYNOPSIS
        A function used to convert time zone offset from minutes to hours.
    #>
    [CmdletBinding()]
    Param($Minutes)

    if ($Minutes -gt 0) {
        $Hours = $Minutes / 60
        [String]'+' + $Hours + ' h'
    } elseif ($minutes -lt 0) {
        $Hours = $Minutes / 60
        [String]$Hours + ' h'
    } elseif ($Minutes -eq 0) {
        [String]'0 h (GMT)'
    } else {
        [String]'Invalid time zone offset'
    }

}
