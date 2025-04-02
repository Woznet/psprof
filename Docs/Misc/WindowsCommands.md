# Windows Commands, Tools & Tricks

> [!NOTE]
> A non-comprehensive list of useful tools built into Windows.
>
> **Source**: <https://den.dev/blog/windows-secret-tools-tricks/>

## Table of Contents

- [Command Line Utilities](#command-line-utilities)
  - [1. changepk](#1-changepk)
  - [2. charmap](#2-charmap)
  - [3. choice](#3-choice)
  - [4. cleanmgr](#4-cleanmgr)
  - [5. clip](#5-clip)
  - [6. diskusage](#6-diskusage)
  - [7. findstr](#7-findstr)
  - [8. fondue](#8-fondue)
  - [9. getmac](#9-getmac)
  - [10. hostname](#10-hostname)
  - [11. label](#11-label)
  - [12. netstat](#12-netstat)
  - [13. powercfg](#13-powercfg)
  - [14. psr](#14-psr)
  - [15. systeminfo](#15-systeminfo)
  - [16. takeown](#16-takeown)
  - [17. tasklist](#17-tasklist)
  - [18. tree](#18-tree)
  - [19. tzutil](#19-tzutil)
  - [20. setx](#20-setx)
  - [21. attrib](#21-attrib)
  - [22. robocopy](#22-robocopy)
- [System Management Shortcuts](#system-management-shortcuts)
  - [23. control userpasswords2](#23-control-userpasswords2)
  - [24. computerdefaults](#24-computerdefaults)
  - [25. control](#25-control)
  - [26. devmgmt.msc](#26-devmgmtmsc)
  - [27. diskmgmt.msc](#27-diskmgmtmsc)
  - [28. displayswitch](#28-displayswitch)
  - [29. dxdiag](#29-dxdiag)
  - [30. msconfig](#30-msconfig)
  - [31. msinfo32](#31-msinfo32)
  - [32. optionalfeatures](#32-optionalfeatures)
  - [33. services.msc](#33-servicesmsc)
  - [34. wf.msc](#34-wfmsc)
  - [35. where](#35-where)
  - [36. whoami](#36-whoami)
  - [37. winsat](#37-winsat)
  - [38. winver](#38-winver)
- [Control Panel Applets (.cpl)](#control-panel-applets-cpl)
  - [39. joy.cpl](#39-joycpl)
  - [40. desk.cpl](#40-deskcpl)
  - [41. ncpa.cpl](#41-ncpacpl)
  - [42. mmsys.cpl](#42-mmsyscpl)
  - [43. sysdm.cpl](#43-sysdmcpl)
  - [44. timedate.cpl](#44-timedatecpl)
  - [45. appwiz.cpl](#45-appwizcpl)
  - [46. main.cpl](#46-maincpl)
- [System Properties Commands](#system-properties-commands)
- [Other Utilities](#other-utilities)
  - [47. cttune](#47-cttune)
  - [48. dxcpl](#48-dxcpl)
  - [49. isoburn](#49-isoburn)
  - [50. chkdsk](#50-chkdsk)

## Command Line Utilities

### 1. changepk
Quickly change Windows product key. Access directly from Run dialog with `changepk` or use programmatically:
```powershell
changepk.exe /ProductKey YOURP-RODUC-TKEYH-ERE01-23456
```

### 2. charmap
Character map utility for copying special symbols (like © or ™) when you can't remember keyboard shortcuts.

### 3. choice
CLI tool for prompting users with choices in scripts. Output can be read through `$LASTEXITCODE`.

### 4. cleanmgr
Disk cleanup utility to remove temporary files and free up disk space.

### 5. clip
Pipes command output directly to the clipboard:
```powershell
dir | clip
```

### 6. diskusage
View disk space usage for folders:
```powershell
diskusage C:\Users\username\Documents /h
```

### 7. findstr
Search for text strings in files:
```powershell
findstr /s /i "search_string" *.txt
```

### 8. fondue
Enable Windows features from command line:
```powershell
fondue /enable-feature:Microsoft-Windows-Subsystem-Linux
```
Useful feature IDs: `VirtualMachinePlatform`, `Microsoft-Hyper-V`, `Containers-DisposableClientVM`

### 9. getmac
Displays MAC addresses for network adapters.

### 10. hostname
Returns the current computer name.

### 11. label
Assign labels to disk drives without using Explorer:
```powershell
label C: "System Drive"
```

### 12. netstat
Shows active TCP connections and listening ports.

### 13. powercfg
Manage power settings and diagnose what's keeping your PC awake:
```powershell
powercfg /requests
```

### 14. psr
Steps Recorder - captures screenshots and actions for troubleshooting. Generates a .zip with documentation.

### 15. systeminfo
Displays detailed system information in the terminal.

### 16. takeown
Re-assign permissions to locked or inaccessible files.

### 17. tasklist
Lists running processes with PIDs and memory usage.

### 18. tree
Displays directory structure in a tree format:
```powershell
tree /F
```

### 19. tzutil
Windows Time Zone Utility to get or set time zones.

### 20. setx
Set permanent environment variables:
```powershell
setx PATH "%PATH%;C:\new\path" /M
```

### 21. attrib
Change file attributes (read-only, hidden, etc.).

### 22. robocopy
Robust file copy for backups and data transfers. Faster and more versatile than Explorer.

## System Management Shortcuts

### 23. control userpasswords2
Quick access to local user and security settings.

### 24. computerdefaults
Verify default application associations.

### 25. control
Launch the classic Control Panel.

### 26. devmgmt.msc
Device Manager for hardware driver management.

### 27. diskmgmt.msc
Disk Management utility for partition management.

### 28. displayswitch
Open projection menu (same as Win+P).

### 29. dxdiag
DirectX diagnostic tool for viewing graphics adapter info.

### 30. msconfig
System Configuration utility for boot settings and services.

### 31. msinfo32
System Information tool for hardware/software configuration.

### 32. optionalfeatures
GUI for enabling/disabling Windows features.

### 33. services.msc
View and manage all Windows services.

### 34. wf.msc
Windows Firewall configuration.

### 35. where
Find location of executables in PATH:
```powershell
where.exe notepad
```

### 36. whoami
Display current user account.

### 37. winsat
Run Windows System Assessment Tool:
```powershell
winsat formal
```

### 38. winver
Display Windows version information.

## Control Panel Applets (.cpl)

### 39. joy.cpl
Game controller configuration and calibration.

### 40. desk.cpl
Display settings for multiple monitors.

### 41. ncpa.cpl
Network Connections Panel for adapter management.

### 42. mmsys.cpl
Sound settings for audio devices.

### 43. sysdm.cpl
System Properties dialog.

### 44. timedate.cpl
Time and date settings.

### 45. appwiz.cpl
Programs and Features for uninstalling applications.

### 46. main.cpl
Mouse Properties dialog.

## System Properties Commands

Direct shortcuts to specific System Properties tabs:

- `SystemPropertiesAdvanced`
- `SystemPropertiesComputerName`
- `SystemPropertiesDataExecutionPrevention`
- `SystemPropertiesHardware`
- `SystemPropertiesPerformance`
- `SystemPropertiesProtection`
- `SystemPropertiesRemote`

## Other Utilities

### 47. cttune
ClearType font rendering adjustment tool.

### 48. dxcpl
DirectX control panel for debugging.

### 49. isoburn
Burn ISO images to optical media without third-party software.

### 50. chkdsk
Check disk for errors and bad sectors.
