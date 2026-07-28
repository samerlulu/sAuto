write-Host "Hellow from GCloud!"
Get-Date

# Create Desktop folder and subfolders
$desktop = [Environment]::GetFolderPath("Desktop")

$mainFolder = Join-Path $desktop "TestIconFolder"
$subFolder1 = Join-Path $mainFolder "Folder-One"
$subFolder2 = Join-Path $mainFolder "Folder-Two"

New-Item -ItemType Directory -Path $subFolder1 -Force | Out-Null
New-Item -ItemType Directory -Path $subFolder2 -Force | Out-Null

# Windows built-in icons
$iconFolder = "$env:SystemRoot\System32\shell32.dll"

write-Host "Foldres Done :)"

# Function to set folder icon
function Set-FolderIcon {
    param (
        [string]$FolderPath,
        [string]$IconLocation
    )

    $desktopIni = Join-Path $FolderPath "desktop.ini"

    @"
[.ShellClassInfo]
IconResource=$IconLocation
IconFile=$IconLocation
IconIndex=0
"@ | Set-Content -Path $desktopIni -Encoding Unicode

    # Make folder system/hidden so Windows reads desktop.ini
    attrib +s $FolderPath
    attrib +h $desktopIni
}

# Apply icons
Set-FolderIcon $mainFolder "$iconFolder,3"
Set-FolderIcon $subFolder1 "$iconFolder,4"
Set-FolderIcon $subFolder2 "$iconFolder,5"

# Refresh icon cache / Explorer
Stop-Process -Name explorer -Force
Start-Process explorer.exe

Write-Host "Done. Folder icons changed:"
Write-Host $mainFolder
