Search-Registry {
    <#
    .SYNOPSIS
    #>
    #Requires -Version 5.1
    [CmdletBinding()]
    param(
        [parameter(Position = 0, Mandatory = $TRUE)]
        [String] $StartKey,
        [parameter(Position = 1, Mandatory = $TRUE)]
        [String] $Pattern,
        [Switch] $MatchKey,
        [Switch] $MatchValue,
        [Switch] $MatchData,
        [UInt32] $MaximumMatches = 0,
        [parameter(ValueFromPipeline = $TRUE)]
        [String[]] $ComputerName = $ENV:COMPUTERNAME
    )

    begin {
        $PIPELINEINPUT = (-not $PSBOUNDPARAMETERS.ContainsKey("ComputerName")) -and
        (-not $ComputerName)

        # Throw an error if -Pattern is not valid
        try {
            "" -match $Pattern | out-null
        } catch [System.Management.Automation.RuntimeException] {
            throw "-Pattern parameter not valid - $($_.Exception.Message)"
        }

        # You must specify at least one matching criteria
        if (-not ($MatchKey -or $MatchValue -or $MatchData)) {
            throw "You must specify at least one of: -MatchKey -MatchValue -MatchData"
        }

        # Interpret zero as "maximum possible number of matches"
        if ($MaximumMatches -eq 0) { $MaximumMatches = [UInt32]::MaxValue }

        # These two hash tables speed up lookup of key names and hive types
        $HiveNameToHive = @{
            "HKCR"               = [Microsoft.Win32.RegistryHive] "ClassesRoot";
            "HKEY_CLASSES_ROOT"  = [Microsoft.Win32.RegistryHive] "ClassesRoot";
            "HKCU"               = [Microsoft.Win32.RegistryHive] "CurrentUser";
            "HKEY_CURRENT_USER"  = [Microsoft.Win32.RegistryHive] "CurrentUser";
            "HKLM"               = [Microsoft.Win32.RegistryHive] "LocalMachine";
            "HKEY_LOCAL_MACHINE" = [Microsoft.Win32.RegistryHive] "LocalMachine";
            "HKU"                = [Microsoft.Win32.RegistryHive] "Users";
            "HKEY_USERS"         = [Microsoft.Win32.RegistryHive] "Users";
        }
        $HiveToHiveName = @{
            [Microsoft.Win32.RegistryHive] "ClassesRoot"  = "HKCR";
            [Microsoft.Win32.RegistryHive] "CurrentUser"  = "HKCU";
            [Microsoft.Win32.RegistryHive] "LocalMachine" = "HKLM";
            [Microsoft.Win32.RegistryHive] "Users"        = "HKU";
        }

        # Search for 'hive:\startkey'; ':' and starting key optional
        $StartKey | select-string "([^:\\]+):?\\?(.+)?" | foreach-object {
            $HiveName = $_.Matches[0].Groups[1].Value
            $StartPath = $_.Matches[0].Groups[2].Value
        }

        if (-not $HiveNameToHive.ContainsKey($HiveName)) {
            throw "Invalid registry path"
        } else {
            $Hive = $HiveNameToHive[$HiveName]
            $HiveName = $HiveToHiveName[$Hive]
        }

        # Recursive function that searches the registry
        function search-registrykey($computerName, $rootKey, $keyPath, [Ref] $matchCount) {
            # Write error and return if unable to open the key path as read-only
            try {
                $subKey = $rootKey.OpenSubKey($keyPath, $FALSE)
            } catch [System.Management.Automation.MethodInvocationException] {
                $message = $_.Exception.Message
                write-error "$message - $HiveName\$keyPath"
                return
            }

            # Write error and return if the key doesn't exist
            if (-not $subKey) {
                write-error "Key does not exist: $HiveName\$keyPath" -category ObjectNotFound
                return
            }

            # Search for value and/or data; -MatchValue also returns the data
            if ($MatchValue -or $MatchData) {
                if ($matchCount.Value -lt $MaximumMatches) {
                    foreach ($valueName in $subKey.GetValueNames()) {
                        $valueData = $subKey.GetValue($valueName)
                        if (($MatchValue -and ($valueName -match $Pattern)) -or ($MatchData -and ($valueData -match $Pattern))) {
                            "" | select-object `
                            @{N = "ComputerName"; E = { $computerName } },
                            @{N = "Key"; E = { "$HiveName\$keyPath" } },
                            @{N = "Value"; E = { $valueName } },
                            @{N = "Data"; E = { $valueData } }
                            $matchCount.Value++
                        }
                        if ($matchCount.Value -eq $MaximumMatches) { break }
                    }
                }
            }

            # Iterate and recurse through subkeys; if -MatchKey requested, output
            # objects only report computer and key (keys do not have values or data)
            if ($matchCount.Value -lt $MaximumMatches) {
                foreach ($keyName in $subKey.GetSubKeyNames()) {
                    if ($keyPath -eq "") {
                        $subkeyPath = $keyName
                    } else {
                        $subkeyPath = $keyPath + "\" + $keyName
                    }
                    if ($MatchKey -and ($keyName -match $Pattern)) {
                        "" | select-object `
                        @{N = "ComputerName"; E = { $computerName } },
                        @{N = "Key"; E = { "$HiveName\$subkeyPath" } },
                        @{N = "Value"; E = {} },
                        @{N = "Data"; E = {} }
                        $matchCount.Value++
                    }
                    # $matchCount is a reference
                    search-registrykey $computerName $rootKey $subkeyPath $matchCount
                    if ($matchCount.Value -eq $MaximumMatches) { break }
                }
            }

            # Close opened subkey
            $subKey.Close()
        }

        # Core function opens the registry on a computer and initiates searching
        function search-registry2($computerName) {
            # Write error and return if unable to open the key on the computer
            try {
                $rootKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive,
                    $computerName)
            } catch [System.Management.Automation.MethodInvocationException] {
                $message = $_.Exception.Message
                write-error "$message - $computerName"
                return
            }
            # $matchCount is per computer; pass to recursive function as reference
            $matchCount = 0
            search-registrykey $computerName $rootKey $StartPath ([Ref] $matchCount)
            $rootKey.Close()
        }
    }

    process {
        if ($PIPELINEINPUT) {
            search-registry2 $_
        } else {
            $ComputerName | foreach-object {
                search-registry2 $_
            }
        }
    }

    end {
        # If no matches found, write a message
        if ($matchCount -eq 0) {
            write-warning "No matches found for $Pattern in $HiveName\$StartKey"
        }
    }

}
