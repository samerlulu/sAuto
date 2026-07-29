# ==========================================
# TestIconFolder Upgrade Script
# ==========================================

$desktop = [Environment]::GetFolderPath("Desktop")

$mainFolder = Join-Path $desktop "TestIconFolder"
$folder1 = Join-Path $mainFolder "Folder-One"
$folder2 = Join-Path $mainFolder "Folder-Two"

$password = "Alpha100%Delta"


# ==========================================
# Find 7-Zip
# ==========================================

function Get-7Zip {

    $paths = @(
        "$env:ProgramFiles\7-Zip\7z.exe",
        "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
    )

    foreach ($p in $paths) {

        if (Test-Path $p) {
            return $p
        }

    }

    return $null
}



# ==========================================
# Install 7-Zip if missing
# ==========================================

function Install-7Zip {

    $installer = Join-Path $env:TEMP "7zip_installer.exe"


    try {

        Write-Host "7-Zip not found."
        Write-Host "Downloading 7-Zip..."


        Invoke-WebRequest `
        -Uri "https://www.7-zip.org/a/7z2409-x64.exe" `
        -OutFile $installer


        Write-Host "Installing 7-Zip silently..."


        Start-Process `
        -FilePath $installer `
        -ArgumentList "/S" `
        -Wait


        Start-Sleep -Seconds 5


        $sevenZip = Get-7Zip


        if ($sevenZip) {

            Write-Host "7-Zip installation successful."

        }
        else {

            Write-Host "7-Zip installation failed."

        }


        return $sevenZip

    }
    catch {

        Write-Host "Unable to install 7-Zip."

        return $null

    }

}



# ==========================================
# Set Folder Icon
# ==========================================

function Set-FolderIcon {

    param(
        [string]$FolderPath,
        [int]$IconIndex
    )


    $desktopIni = Join-Path $FolderPath "desktop.ini"


    @"
[.ShellClassInfo]
IconResource=%SystemRoot%\System32\shell32.dll,$IconIndex
"@ | Set-Content $desktopIni -Encoding Unicode


    attrib +s $FolderPath
    attrib +h $desktopIni

}



# ==========================================
# Create fresh folders
# ==========================================

function Create-FreshFolders {


    if (!(Test-Path $mainFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $mainFolder | Out-Null

    }


    New-Item `
    -ItemType Directory `
    -Path $folder1 `
    -Force | Out-Null


    New-Item `
    -ItemType Directory `
    -Path $folder2 `
    -Force | Out-Null



    Set-FolderIcon $mainFolder 3
    Set-FolderIcon $folder1 4
    Set-FolderIcon $folder2 5

}



# ==========================================
# Main Logic
# ==========================================


if (!(Test-Path $mainFolder)) {


    Write-Host "TestIconFolder does not exist."

    Write-Host "Creating new structure..."


    # No archive required.
    # Do not install 7-Zip.

    Create-FreshFolders


}
else {


    Write-Host "Existing TestIconFolder found."


    # Archive required, so check for 7-Zip.

    $sevenZip = Get-7Zip


    if (!$sevenZip) {

        $sevenZip = Install-7Zip

    }



    # Create Archive folder

    $archiveFolder = Join-Path $mainFolder "Archive"


    New-Item `
    -ItemType Directory `
    -Path $archiveFolder `
    -Force | Out-Null



    # Create timestamp filename

    $timestamp = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"

    $zipName = "${timestamp}_TestIconFolder.zip"

    $zipPath = Join-Path $archiveFolder $zipName



    # Archive existing folders


    if ($sevenZip) {


        Write-Host "Creating password protected ZIP..."


        & $sevenZip a `
        -tzip `
        "-p$password" `
        "-mem=AES256" `
        $zipPath `
        $folder1 `
        $folder2



        Write-Host "ZIP created using 7-Zip encryption"

    }
    else {


        Write-Host ""
        Write-Host "ERROR: 7-Zip encryption unavailable."
        Write-Host "Archive creation cancelled."
        Write-Host "No unencrypted ZIP will be created."

        exit 1

    }



    # Remove old folders

    Write-Host "Removing old folders..."


    Remove-Item `
    $folder1 `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue


    Remove-Item `
    $folder2 `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue



    # Recreate clean folders

    Write-Host "Creating fresh folders..."


    Create-FreshFolders


}



# ==========================================
# Refresh Explorer icons
# ==========================================

Write-Host "Refreshing Explorer view..."


try {

    $shell = New-Object -ComObject Shell.Application

    $shell.Windows() | ForEach-Object {
        $_.Refresh()
    }

    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null

}
catch {

    Write-Host "Explorer refresh could not be completed."

}



Write-Host ""
Write-Host "If icons do not update immediately, press F5 in Explorer."
Write-Host ""

Write-Host "================================"
Write-Host "Completed Successfully"
Write-Host "================================"# ==========================================
# TestIconFolder Upgrade Script
# ==========================================

$desktop = [Environment]::GetFolderPath("Desktop")

$mainFolder = Join-Path $desktop "TestIconFolder"
$folder1 = Join-Path $mainFolder "Folder-One"
$folder2 = Join-Path $mainFolder "Folder-Two"

$password = "Alpha100%Delta"


# ==========================================
# Find 7-Zip
# ==========================================

function Get-7Zip {

    $paths = @(
        "$env:ProgramFiles\7-Zip\7z.exe",
        "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
    )

    foreach ($p in $paths) {

        if (Test-Path $p) {
            return $p
        }

    }

    return $null
}



# ==========================================
# Install 7-Zip if missing
# ==========================================

$sevenZip = Get-7Zip


if (!$sevenZip) {

    Write-Host "7-Zip not found."

    $installer = Join-Path $env:TEMP "7zip_installer.exe"


    try {

        Write-Host "Downloading 7-Zip..."

        Invoke-WebRequest `
        -Uri "https://www.7-zip.org/a/7z2409-x64.exe" `
        -OutFile $installer


        Write-Host "Installing 7-Zip silently..."

        Start-Process `
        -FilePath $installer `
        -ArgumentList "/S" `
        -Wait


        Start-Sleep -Seconds 5


        $sevenZip = Get-7Zip


        if ($sevenZip) {

            Write-Host "7-Zip installation successful."

        }
        else {

            Write-Host "7-Zip installation failed."

        }

    }
    catch {

        Write-Host "Unable to install 7-Zip."

        $sevenZip = $null

    }

}



# ==========================================
# Set Folder Icon
# ==========================================

function Set-FolderIcon {

    param(
        [string]$FolderPath,
        [int]$IconIndex
    )


    $desktopIni = Join-Path $FolderPath "desktop.ini"


    @"
[.ShellClassInfo]
IconResource=%SystemRoot%\System32\shell32.dll,$IconIndex
"@ | Set-Content $desktopIni -Encoding Unicode


    attrib +s $FolderPath
    attrib +h $desktopIni

}



# ==========================================
# Create fresh folders
# ==========================================

function Create-FreshFolders {


    if (!(Test-Path $mainFolder)) {

        New-Item `
        -ItemType Directory `
        -Path $mainFolder | Out-Null

    }


    New-Item `
    -ItemType Directory `
    -Path $folder1 `
    -Force | Out-Null


    New-Item `
    -ItemType Directory `
    -Path $folder2 `
    -Force | Out-Null



    Set-FolderIcon $mainFolder 3
    Set-FolderIcon $folder1 4
    Set-FolderIcon $folder2 5


}



# ==========================================
# Main Logic
# ==========================================


if (!(Test-Path $mainFolder)) {


    Write-Host "TestIconFolder does not exist."

    Write-Host "Creating new structure..."

    Create-FreshFolders


}
else {


    Write-Host "Existing TestIconFolder found."



    # Create Archive folder

    $archiveFolder = Join-Path $mainFolder "Archive"


    New-Item `
    -ItemType Directory `
    -Path $archiveFolder `
    -Force | Out-Null



    # Create timestamp filename

    $timestamp = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"

    $zipName = "${timestamp}_TestIconFolder.zip"

    $zipPath = Join-Path $archiveFolder $zipName



    # Archive existing folders

    if ($sevenZip) {


        Write-Host "Creating password protected ZIP..."


        & $sevenZip a `
        -tzip `
        "-p$password" `
        "-mem=AES256" `
        $zipPath `
        $folder1 `
        $folder2



        Write-Host "Encrypted archive created."

    }
    else {


        Write-Host "Creating normal ZIP fallback..."


        Compress-Archive `
        -Path $folder1,$folder2 `
        -DestinationPath $zipPath `
        -Force


        Write-Host "Normal ZIP created."

    }



    # Remove old folders

    Write-Host "Removing old folders..."


    Remove-Item `
    $folder1 `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue


    Remove-Item `
    $folder2 `
    -Recurse `
    -Force `
    -ErrorAction SilentlyContinue



    # Recreate clean folders

    Write-Host "Creating fresh folders..."


    Create-FreshFolders



}



# Refresh Explorer

Write-Host "Refreshing Explorer..."

#Stop-Process `
#-Name explorer `
#-Force `
#-ErrorAction SilentlyContinue


#Start-Process explorer.exe

$shell = New-Object -ComObject Shell.Application
$shell.Windows() | ForEach-Object { $_.Refresh() }

[System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null

Write-Host ""
Write-Host "================================"
Write-Host "Completed Successfully"
Write-Host "================================"
