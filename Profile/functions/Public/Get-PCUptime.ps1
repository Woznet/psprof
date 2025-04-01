Function Get-PCUpTime() {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $ComputerName
    )

    begin {
        $Version = $PSVersionTable.PSEdition
    }
    process {
        try {
            switch ($Version) {
                'Desktop' {
                    if ($null -ne $ComputerName) {
                        $SplatMe = @{
                            ClassName    = 'Win32_OperatingSystem'
                            ComputerName = $ComputerName
                        }
                    } else {
                        $SplatMe = @{
                            ClassName = 'Win32_OperatingSystem'
                        }
                    }

                    $Now = Get-Date
                    $LastBootUpTime = (Get-CimInstance @SplatMe -ErrorAction Stop).LastBootUpTime
                    $Return = $Now - $LastBootUpTime
                    return $Return
                }

                'Core' {
                    if ($null -ne $ComputerName) {
                        $PCFunctionDefinition = Get-Definition Get-PCUpTime
                        $Script = @"
                        $PCFunctionDefinition
                        Get-PCUpTime
"@
                        $ScriptBlock = {
                            param ($Script)
                            . ([ScriptBlock]::Create($Script))
                        }
                        $params = @{
                            ComputerName = $ComputerName
                            ScriptBlock  = $ScriptBlock
                            ArgumentList = $Script
                        }
                        Invoke-Command @params
                    } else {
                        Get-Uptime
                    }
                }

                DEFAULT {}
            }
        } catch {
            Write-Error "$($_.Exception.Message)"
        }
    }
}
