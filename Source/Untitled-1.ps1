<#
        .SYNOPSIS
            Lists all custom functions in the current PowerShell profile.
        .DESCRIPTION
            Lists all custom functions in the current PowerShell profile.
        .EXAMPLE
            Get-ProfileFunctions
        .NOTES
            Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    #>

    # Get all functions declared under the $ProfileSourcePath directory:
    $PSProfileFiles = Get-ChildItem -Path "$ProfileSourcePath\*.ps1" |
      Select-Object -ExpandProperty FullName |
      Convert-Path

    $PSProfileFunctions = @()

    ForEach ($PSProfileFile in $PSProfileFiles) {
        $PSProfileFunctions += (Get-Command -Name $PSProfileFile).ScriptBlock.Ast.FindAll(
            { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] },
            $false
        ).Name
    }

    Write-Host "Discovered $($PSProfileFunctions.Count) Functions Declared by the PowerShell Profile: $PROFILE" -ForegroundColor Cyan

    

    $PSProfileFunctions