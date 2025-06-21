# # ----------------------------------------------------------------------------
# # `ai` CLI Shell Completion for PowerShell
# # ----------------------------------------------------------------------------

# <#

# #>
# #Requires -Module PSBashCompletions

# Process {

#     Write-Verbose "[PROCESS]: ai completion"

#     try {
#         Register-BashArgumentCompleter "ai" $BashCompletionPath
#     } catch {
#         Write-Error "Failed to register ai CLI shell completions."
#     }

# }

# End {

#     Write-Verbose "[END]: ai completion"

# }

# Begin {

#     Write-Verbose "[BEGIN]: ai completion"

#     if (-not (Get-Command ai -ErrorAction SilentlyContinue)) {
#         Write-Error "ai is not installed. Please install ai CLI from npm."
#     }

#     $BashCompletionPath = "$PSScriptRoot/bash/ai_bash_completion.sh"

#     if (-not (Test-Path $BashCompletionPath)) {
#         Write-Error "ai bash completion script not found."
#     }

#     Import-Module PSBashCompletions

# }
