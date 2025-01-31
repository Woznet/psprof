Function Get-UserChoice {
    <#
    .SYNOPSIS
        Prompts the user to select from a list of options.
    .DESCRIPTION
        Prompts the user to select from a list of options.
        Returns the index of the selected option.
    .PARAMETER Options
        The "options" for the user to select from.
        The user selects a choice by specifying the number associated with a choice.

        This parameter accepts an array of strings or hashtables (in any combination).
        If a hashtable is used, the key is the label and the value is the help text.
        Label is the text that is displayed to the user. Help is the text that is displayed when the user presses F1.
        If a hashtable is used, the label must be specified as "Label" and the help text must be specified as "Help".
    .PARAMETER Caption
        The caption to display in the title bar of the prompt window.
    .PARAMETER Message
        The message to display in the prompt window.
    .PARAMETER Vertical
        If specified, the options will be displayed vertically.
        If not specified, the options will be displayed horizontally.
    .PARAMETER DefaultChoice
        The index of the option that is selected by default.
        If not specified, the first option is selected by default.
    .EXAMPLE
        Get-UserChoice -Options 'Option 1', 'Option 2', 'Option 3'

        # Displays a prompt window with the caption:
        # "Select an option", the message "Option 1, Option 2, Option 3", and the options "1 Option 1", "2 Option 2", and "3 Option 3".
        # The user can select an option by pressing the number associated with the option.
        # The default option is "Option 1".
    .EXAMPLE
        Get-UserChoice -Options 'Option 1', 'Option 2', 'Option 3' -Caption 'Select an option' -Message 'Option 1, Option 2, Option 3' -Vertical

        # Displays a prompt window with the caption:
        # "Select an option", the message "Option 1, Option 2, Option 3", and the options "1 Option 1", "2 Option 2", and "3 Option 3".
        # The user can select an option by pressing the number associated with the option.
        # The default option is "Option 1".
        # The options are displayed vertically.
    .EXAMPLE
        Get-UserChoice -Options 'Option 1', 'Option 2', 'Option 3' -Caption 'Select an option' -Message 'Option 1, Option 2, Option 3' -DefaultChoice 2

        # Displays a prompt window with the caption:
        # "Select an option", the message "Option 1, Option 2, Option 3", and the options "1 Option 1", "2 Option 2", and "3 Option 3".
        # The user can select an option by pressing the number associated with the option.
        # The default option is "Option 2".
    .EXAMPLE
        Get-UserChoice -Options 'Option 1', 'Option 2', 'Option 3' -Caption 'Select an option' -Message 'Option 1, Option 2, Option 3' -DefaultChoice 2 -Vertical

        # Displays a prompt window with the caption:
        # "Select an option", the message "Option 1, Option 2, Option 3", and the options "1 Option 1", "2 Option 2", and "3 Option 3".
        # The user can select an option by pressing the number associated with the option.
        # The default option is "Option 2".
        # The options are displayed vertically.
    .INPUTS
        System.String
    .OUTPUTS
        System.Int32
    .NOTES

    .LINK
    https://github.com/PowershellFrameworkCollective/psframework/blob/development/PSFramework/functions/flowcontrol/Get-PSFUserChoice.ps1
    #>
    [OutputType([System.Int32])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string[]]$Options,

        [Parameter(Mandatory = $false)]
        [string]$Caption,

        [Parameter(Mandatory = $false)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [Switch]$Vertical,

        [Parameter(Mandatory = $false)]
        [Int]$DefaultChoice = 0
    )

    Begin {
        if ($Vertical) {
            $optionStrings = foreach ($option in $Options) {
                if ($option -is [hashtable]) { $option.Keys }
                else { $option }
            }
            $count = 1
            $messageStrings = foreach ($optionString in $OptionStrings) {
                "$count $optionString"
                $count++
            }
            $count--
            $Message = ((@($Message) + @($messageStrings)) -join "`n").Trim()
            $choices = 1..$count | ForEach-Object { "&$_" }
        }
        Else {
            $choices = @()
            foreach ($option in $Options) {
                if ($option -is [hashtable]) {
                    $label = $option.Keys -match '^l' | Select-Object -First 1
                    [string]$labelValue = $option[$label]
                    $help = $option.Keys -match '^h' | Select-Object -First 1
                    [string]$helpValue = $option[$help]

                }
                else {
                    $labelValue = "$option"
                    $helpValue = "$option"
                }
                if ($labelValue -match '&') { $choices += New-Object System.Management.Automation.Host.ChoiceDescription -ArgumentList $labelValue, $helpValue }
                else { $choices += New-Object System.Management.Automation.Host.ChoiceDescription -ArgumentList "&$($labelValue.Trim())", $helpValue }
            }
        }
    }

    Process {
        if ($Options.Count -eq 1) { return 0 }

        $Host.UI.PromptForChoice($Caption, $Message, $choices, $DefaultChoice)
    }
}
