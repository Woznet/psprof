# GitHub Copilot Instructions for PowerShell Profile Repository

## Repository Overview

This repository contains a customized PowerShell Core profile configuration organized into modular components. It includes custom functions, aliases, modules, and scripts designed to enhance the PowerShell experience.

## Key Components

- **Profile.ps1**: Main entry point that loads all components with performance optimizations
- **Profile/**: Core configuration files organized by functionality
- **Modules/**: Custom PowerShell modules (e.g., PSDefender)
- **Scripts/**: Standalone utility scripts
- **Config/**: Configuration files for modules and scripts
- **Tests/**: Test scripts for verifying functionality

## Coding Conventions

When contributing to this repository, follow these conventions:

### PowerShell Style Guidelines

1. **Function Naming**: Use Pascal Case verb-noun format (e.g., `Export-DefenderExclusions`)
2. **Parameter Naming**: Use Pascal Case (e.g., `$FilePath`)
3. **Variable Naming**: Use camelCase for local variables, PascalCase for script/global variables
4. **Comment Style**: Use single-line comments (`#`) for simple comments, block comments (`<# #>`) for documentation
5. **Indentation**: Use 4 spaces for indentation (not tabs)
6. **Brackets**: Place opening brackets on the same line, closing brackets on a new line

### Documentation Requirements

1. **Function Documentation**: All functions should include comment-based help with:
   - `.SYNOPSIS`: Brief description
   - `.DESCRIPTION`: Detailed description
   - `.PARAMETER`: Description for each parameter
   - `.EXAMPLE`: At least one usage example
   - `.OUTPUTS`: Description of function output
   - `.NOTES`: Additional information (author, version, etc.)

2. **Module Documentation**: All modules should include a module manifest (`.psd1`) and documentation in the module script (`.psm1`)

## Common Patterns

### Module Structure

Modules in this repository follow this structure:

- `ModuleName.psm1`: Main module file with documentation
- `Public/`: Contains exported functions
- `Private/`: Contains internal helper functions

### Error Handling

Use try/catch blocks for error handling with appropriate error messages:

```powershell
try {
    # Code that might fail
} catch {
    Write-Error "Descriptive error message: $_"
}
```

### Administrative Functions

For functions requiring administrative privileges:

- Include a check for admin rights at the beginning of the function
- Return with an error message if admin rights are not available

```powershell
if (-not (Test-AdminRights)) {
    Write-Error "Administrative privileges required."
    return
}
```

## PSDefender Module Guidelines

The PSDefender module manages Windows Defender exclusions:

1. All functions should check for administrative privileges
2. Functions should support both file and path exclusions
3. Include proper error handling and user feedback
4. Support import/export functionality for backup and deployment

## Testing Guidelines

1. All new functions should have corresponding tests in the `Tests/` directory
2. Tests should verify both successful execution and proper error handling
3. Use Pester for writing tests

## Performance Considerations

1. Use lazy loading for completions and non-essential modules
2. Include performance measurement capabilities for profiling
3. Optimize module imports to reduce profile load time

## Changelog Management

This repository uses git-cliff for changelog generation:

1. Follow conventional commit messages
2. The changelog is automatically updated on push to main
3. Pull requests should include appropriate commit messages for changelog generation

## Additional Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/docs/quick-start)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer/tree/master/docs/Rules)
