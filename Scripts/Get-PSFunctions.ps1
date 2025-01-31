#Requires -Version 7

[CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'Low',
    DefaultParameterSetName = 'list'
)]
Param(
    [Parameter(Mandatory = $false, Position = 0, ParameterSetName = 'list')]
    [Switch]$ListAvailable
)

BEGIN {
    function functionInBeginBlock() {
        return "functionInBeginBlock"
    }

    function getFunctions($_MyInvocation) {
        $OutputParameter = @()
        foreach ($BlockName in @("BeginBlock", "ProcessBlock", "EndBlock")) {
            $CurrentBlock = $_MyInvocation.MyCommand.ScriptBlock.Ast.$BlockName
            foreach ($Statement in $CurrentBlock.Statements) {
                $Extent = $Statement.Extent.ToString()
                if ([String]::IsNullOrWhiteSpace($Statement.Name) -Or $Extent -inotmatch ('function\W+(?<name>{0})' -f $Statement.Name)) {
                    continue
                }
                $OutputParameter += $Statement.Name
            }
        }
        return $OutputParameter
    }
}

PROCESS {
    function functionInProcessBlock() {
        return "functionInProcessBlock"
    }
}

END {
    function functionInEndBlock() {
        return "functionInEndBlock"
    }

    function theAnswer() {
        return 42
    }
	
    return getFunctions($MyInvocation)
}