# PowerShell Core Modules Documentation

>   [!NOTE]
>   *📂 **Folder Purpose**: This folder is part of my dotfiles repository, serving as a reference for installed PowerShell Core modules in my development environment.*

## Contents

[TOC]

## Overview

This document serves the purpose of providing a high-level overview of the PowerShell Core modules installed on my system.

These modules are currently excluded from version control (`.gitignore`) but are critical for my workflows. 

## Module Management

I manage my modules using a custom [modules.json](https://github.com/jimbrig/PowerShell/blob/main/Modules/modules.json) / [modules.yml](https://github.com/jimbrig/PowerShell/blob/main/Modules/modules.yml) configuration file for easy backups and bootstrapping of installations.

The installed modules are backed up into a simple `JSON` file: [modules.json](https://github.com/jimbrig/PowerShell/blob/main/Modules/modules.json) and created via [modules.ps1](https://github.com/jimbrig/PowerShell/blob/main/Modules/modules.ps1).

Additionally, utilize the [Remove-OldModules.ps1](https://github.com/jimbrig/PowerShell/blob/main/Modules/Remove-OldModules.ps1) script to remove any outdated versions of installed modules.

## Installed Modules

Below is a categorized list of the modules, with brief descriptions where applicable.

### 📦 Core Utilities and Helpers

- **BuildHelpers**: Utilities for building and packaging PowerShell modules.
- **BurntToast**: Toast notifications for Windows systems.
- **EZOut**: Streamlines output formatting for PowerShell commands.
- **HelpOut**: Assists in creating and managing PowerShell help documentation.
- **Metadata**: Simplifies managing script metadata.
- **PSTypeExtensionTools**: Tools for managing and extending PowerShell types.

### 🔍 Command and Script Enhancements
- **Az.Tools.Predictor**: AI-driven command prediction for Azure.
- **CompletionPredictor**: Enhances tab-completion predictions.
- **F7History**: Enhanced command history browser.
- **posh-git**: Git enhancements for the PowerShell prompt.
- **PSFzf**: Integration with the fuzzy finder tool `fzf`.
- **TabExpansionPlusPlus**: Custom tab completions for PowerShell commands.
- **ZLocation**: Tracks frequently used directories and provides quick navigation.

### 🔧 Development Tools
- **InvokeBuild**: Build automation for PowerShell projects.
- **platyPS**: Generate PowerShell documentation in Markdown.
- **PowerShellBuild**: Build automation framework for PowerShell modules.
- **psake**: Build automation inspired by Rake.
- **VSCodeBackup**: Backups for Visual Studio Code settings and extensions.

### 📋 Data Management
- **DataMashup**: Tools for data wrangling and manipulation.
- **ImportExcel**: Import and export Excel files without needing Excel installed.
- **PSSQLite**: Work with SQLite databases directly from PowerShell.
- **Write-ObjectToSQL**: Serialize PowerShell objects to SQL.

### 🛠 System Management and Configuration
- **ComputerCleanup**: Tools for cleaning up and optimizing systems.
- **Configuration**: Manage system configurations programmatically.
- **PSWindowsUpdate**: Manage Windows Updates from PowerShell.
- **WifiTools**: Wireless network management utilities.
- **xDSCResourceDesigner**: Tools for creating DSC resources.

### 📦 Package and Resource Management
- **Microsoft.PowerShell.PSResourceGet**: Manage PowerShell resources.
- **PackageManagement**: Manage software packages in PowerShell.
- **WingetTools**: Utilities for managing Windows apps with Winget.
- **Microsoft.WinGet.Client**: Access Winget functionality programmatically.
- **Microsoft.WinGet.CommandNotFound**: Enhances Winget usability in PS.

### 🛡 Security and Secrets
- **Microsoft.PowerShell.SecretManagement**: Manage secrets in a unified way.
- **Microsoft.PowerShell.SecretStore**: A secure vault for SecretManagement.

### 🎨 Console Enhancements
- **Microsoft.PowerShell.ConsoleGuiTools**: GUI tools for the terminal.
- **Terminal-Icons**: Adds file and folder icons to the terminal.
- **PSClearHost**: Enhances the `Clear-Host` experience.
- **PSWriteColor**: Advanced colored text output for scripts.

### 📚 Testing and Quality
- **Pester**: Unit testing framework for PowerShell.
- **PSScriptAnalyzer**: Analyze scripts for style, performance, and errors.
- **PSCodeHealth**: Assess the health of PowerShell scripts and modules.

### 🔍 Command-Line Completions
- **DockerCompletion**: Auto-completions for Docker commands.
- **PSBashCompletions**: Enable bash-style command-line completions.
- **PSCompletions**: Generic tab-completion utilities.

### 🎨 HTML and GUI Tools
- **PSWriteHTML**: Create interactive HTML reports from PowerShell.
- **Microsoft.PowerShell.Crescendo**: Create native commands from PowerShell scripts.

### 🧰 Miscellaneous
- **PSAI**: PowerShell AI utilities.
- **PSEverything**: Interface with Everything Search Engine.
- **PSMenu**: Create terminal-based menus in PowerShell.
- **PSSoftware**: Manage installed software.
- **PSStucco**: Generate and manage structured console output.
- **tiPS**: General-purpose PowerShell tools.

### 🧪 Experimental and Special-Purpose Modules
- **Cobalt**: Experimental module for advanced scripting.
- **ThreadJob**: Multithreaded job management in PowerShell.
- **Microsoft.PowerShell.WhatsNew**: Discover new features in PowerShell.

### 🛠 Tools Under Development
- **WTToolBox**: Utilities for working with Windows Terminal.
- **psyml**: YAML processing tools for PowerShell.
- **powershell-yaml**: YAML serialization and deserialization.

### Notes

- This list will be kept up to date as new modules are added or removed.
- Modules are excluded from version control to keep the repository clean and lightweight.
- To replicate this setup, use the [PowerShellGet](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview) module to install the listed modules.

