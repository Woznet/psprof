Function Test-R {
    [CmdletBinding()]
    Param ()
    Process {
        $R_HOME = $Env:R_HOME
        $R_VER = (Split-Path $Env:R_HOME -Leaf).Replace("R-", "")
        #-Filter "R-*" -Directory | Select-Object -ExpandProperty Name
    }
}
