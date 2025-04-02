Function Get-GitHubRateLimits {
    <#
    .SYNOPSIS
        Leverages GitHub CLI to call the GitHub API to retrieve rate limit details.
    #>
    [CmdLetBinding()]
    Param()

    Begin{
        Write-Verbose "[Begin]: Get-GitHubRateLimits"
        if (-not(Get-Command -Name gh -ErrorAction SilentlyContinue)) {
            Write-Warning "No gh CLI found."
            return
        }
    }

    Process {
        Write-Verbose "[Process]: Get-GitHubRateLimits"
        $cmd = "gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /rate_limit"
        & $cmd
    }
}
