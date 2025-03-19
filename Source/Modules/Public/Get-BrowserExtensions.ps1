Function Get-BrowserExtensions {
    <#
    .SYNOPSIS
        Retrieves a list of installed browser extensions for Chrome or Edge.

    .DESCRIPTION
        This function retrieves the installed browser extensions for Chrome or Edge by reading the manifest.json files in
        each extension's folder.

        It handles potential access issues, skips folders it cannot access, and exports the results to a CSV file.

        It supports only Chromium-based browsers (e.g., Google Chrome and Microsoft Edge).

    .PARAMETER Browser
        Specifies the browser for which to retrieve extensions. Accepts 'Chrome' or 'Edge'.

    .PARAMETER OutputFile
        The path of the output CSV file where the list of extensions will be saved.

    .EXAMPLE
        Get-BrowserExtensions -Browser Chrome -OutputFile "ChromeExtensions.csv"

        This command retrieves all extensions from Google Chrome and saves them in a CSV file named ChromeExtensions.csv.

    .EXAMPLE
        Get-BrowserExtensions -Browser Edge -OutputFile "EdgeExtensions.csv"

        This command retrieves all extensions from Microsoft Edge and saves them in a CSV file named EdgeExtensions.csv.

    .NOTES
        Make sure you have the appropriate file permissions to access the browser extensions folder.

        If some directories are inaccessible, a warning will be issued, and the function will continue processing the
        remaining extensions.

    .OUTPUTS
        A CSV file containing the list of installed browser extensions with columns for ExtensionID, Name, and Version.
    #>
    [CmdletBinding()]
    Param (
        # Specifies the browser for which to retrieve extensions
        [Parameter(Mandatory = $true, HelpMessage = "Specify the browser. Accepts 'Chrome' or 'Edge'.")]
        [ValidateSet("Chrome", "Edge")]
        [string]$Browser,

        # Specifies the output CSV file path
        [Parameter(Mandatory = $true, HelpMessage = "Specify the output CSV file path.")]
        [ValidateNotNullOrEmpty()]
        [String]$OutputFile
    )

    Begin {

      Write-Verbose "[BEGIN]: Get-BrowserExtensions"

      # Determine the extensions folder based on the selected browser
      $extensionsPath = switch ($Browser) {
        "Chrome" { "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions" }
        "Edge" { "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Extensions" }
      }

      # Check if the directory exists
      if (-not (Test-Path -Path $extensionsPath)) {
          Write-Error "The extension directory for $Browser was not found."
          return
      }

      # Get the extension folders
      $extensions = Get-ChildItem -Path $extensionsPath -Directory

      # List to hold extension details
      $extensionList = @()

    }

    Process {

      Write-Verbose "[PROCESS]: Get-BrowserExtensions"

      # Loop through each extension folder
      ForEach ($ext in $extensions) {
          try {
              # Locate the manifest.json file for each extension
              $manifestPath = Get-ChildItem -Path "$($ext.FullName)\*" -Recurse -Filter "manifest.json" -ErrorAction Stop |
                  Select-Object -First 1

              if ($manifestPath) {
                  # Parse the manifest.json file
                  $manifest = Get-Content -Path $manifestPath.FullName | ConvertFrom-Json

                  # Add extension details to the list
                  $extensionList += [PSCustomObject]@{
                      ExtensionID = $ext.Name
                      Name        = $manifest.name
                      Version     = $manifest.version
                  }
              }

          } catch [System.UnauthorizedAccessException] {
              # Handle access denied errors
              Write-Warning "Access denied to folder: $($ext.FullName). Skipping..."
          } catch {
              # Handle other errors
              Write-Warning "An error occurred processing folder: $($ext.FullName). Skipping..."
          }
      }

    }

    End {

        Write-Verbose "[END]: Get-BrowserExtensions"

        # Check if any extensions were found
        if ($extensionList.Count -gt 0) {
            # Export the list to a CSV file
            $extensionList | Export-Csv -Path $OutputFile -NoTypeInformation
            Write-Host "Extension list exported to $OutputFile"
        } else {
            Write-Host "No extensions were found or all directories were inaccessible."
        }

    }

}
