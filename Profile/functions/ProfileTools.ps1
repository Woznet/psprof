# PowerShell profile management functions
Function Edit-PSProfile {
    try {
        $cmd = "$Env:Editor $PROFILE.CurrentUserAllHosts"
        Invoke-Expression -Command $cmd
    } catch {
        Write-Error "Failed to edit PS profile: $_"
    }
}

Function Edit-PSProfileProject {
    try {
        if (-not($ProfileRootPath)) {
            Write-Warning 'ProfileRootPath not found.'
            $Global:ProfileRootPath = Split-Path -Path $PROFILE -Parent
        }

        $cmd = "$Env:Editor $ProfileRootPath"
        Invoke-Expression -Command $cmd
    } catch {
        Write-Error "Failed to edit PS profile project: $_"
    }
}

Function Get-PSProfileFunctions {
    try {
        $ProfileSourcePath = Split-Path -Path $PROFILE -Parent
        $PSProfileFiles = Get-ChildItem -Path "$ProfileSourcePath\*.ps1" -Recurse |
            Select-Object -ExpandProperty FullName |
                Convert-Path

        $Functions = @()
        foreach ($file in $PSProfileFiles) {
            $ast = [System.Management.Automation.Language.Parser]::ParseFile(
                $file, [ref]$null, [ref]$null)

            $functions = $ast.FindAll({
                    param($ast)
                    $ast -is [System.Management.Automation.Language.FunctionDefinitionAst]
                }, $true)

            foreach ($function in $functions) {
                $help = $function.GetHelpContent()
                $Functions += [PSCustomObject]@{
                    Name        = $function.Name
                    Description = $help.Synopsis
                    File        = $file
                }
            }
        }

        return $Functions | Sort-Object Name
    } catch {
        Write-Error "Failed to get PS profile functions: $_"
    }
}

Function Invoke-ProfileReload {
    try {
        Write-Host "Reloading PowerShell profile..." -ForegroundColor Cyan
        & $PROFILE
        Write-Host "Profile reloaded successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to reload profile: $_"
    }
}
