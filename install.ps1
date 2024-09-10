$Username = [System.Environment]::UserName
$SdkPath = "C:\Users\$Username\AppData\Local\Android\Sdk"
$DumperUrl = "https://github.com/lollolong/dumper/archive/refs/heads/main.zip"
$FridaServerUrl = "https://github.com/frida/frida/releases/download/16.5.1/frida-server-16.5.1-android-x86.xz"
$CmdlineToolsUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"

if (-not (Test-Path -Path $SdkPath)) {
    New-Item -Path $SdkPath -ItemType Directory
}

Write-Output "Downloading Command Line Tools..."
Invoke-WebRequest -Uri $CmdlineToolsUrl -OutFile "$SdkPath\commandlinetools-win_latest.zip"
Write-Output "Extracting Command Line Tools..."
Expand-Archive -Path "$SdkPath\commandlinetools-win_latest.zip" -DestinationPath "$SdkPath\cmdline-tools\latest" -Force

if (Test-Path -Path "$SdkPath\cmdline-tools\latest\cmdline-tools") {
    Move-Item -Path "$SdkPath\cmdline-tools\latest\cmdline-tools\*" -Destination "$SdkPath\cmdline-tools\latest" -Force
    Remove-Item -Path "$SdkPath\cmdline-tools\latest\cmdline-tools" -Recurse -Force
}

$LicensesPath = "$SdkPath\licenses"
if (-not (Test-Path -Path $LicensesPath)) {
    New-Item -Path $LicensesPath -ItemType Directory
}

@"
e9acab5b5fbb560a72cfaecce8946896ff6aab9d
"@ | Set-Content -Path "$LicensesPath\mips-android-sysimage-license"

@"
d975f751698a77b662f1254ddbeed3901e976f5a
"@ | Set-Content -Path "$LicensesPath\intel-android-extra-license"

@"
33b6a2b64607f11b759f320ef9dff4ae5c47d97a
"@ | Set-Content -Path "$LicensesPath\google-gdk-license"

@"
84831b9409646a918e30573bab4c9c91346d8abd
"@ | Set-Content -Path "$LicensesPath\android-sdk-preview-license"

@"
24333f8a63b6825ea9c5514f83c2829b004d1fee
"@ | Set-Content -Path "$LicensesPath\android-sdk-license"

@"
859f317696f67ef3d7f30a50a5560e7834b43903
"@ | Set-Content -Path "$LicensesPath\android-sdk-arm-dbt-license"

@"
601085b94cd77f0b54ff86406957099ebe79c4d6
"@ | Set-Content -Path "$LicensesPath\android-googletv-license"

Write-Output "Installing platform-tools, platforms, and system images..."
Start-Process -FilePath "$SdkPath\cmdline-tools\latest\bin\sdkmanager.bat" -ArgumentList @("platform-tools", "platforms;android-28", "system-images;android-28;google_apis;x86") -Wait

Write-Output "Creating AVD..."
Start-Process -FilePath "$SdkPath\cmdline-tools\latest\bin\avdmanager.bat" -ArgumentList @("create", "avd", "--name", "pixel", "--package", "system-images;android-28;google_apis;x86", "--device", "pixel") -Wait

if (Test-Path "C:\Users\$Username\.android\avd\pixel.avd\config.ini") {
    (Get-Content "C:\Users\$Username\.android\avd\pixel.avd\config.ini") -replace "hw.keyboard = no", "hw.keyboard = yes" | Set-Content "C:\Users\$Username\.android\avd\pixel.avd\config.ini"
    Write-Output "Hardware keyboard enabled in AVD configuration."
} else {
    Write-Output "AVD configuration file not found."
}

Write-Output "Starting the emulator..."
Start-Process -FilePath "$SdkPath\emulator\emulator.exe" -ArgumentList @("-avd", "pixel")

Write-Output "Downloading Dumper..."
Invoke-WebRequest -Uri $DumperUrl -OutFile "C:\Users\$Username\dumper.zip"
Write-Output "Extracting Dumper..."
Expand-Archive -Path "C:\Users\$Username\dumper.zip" -DestinationPath "C:\Users\$Username\dumper" -Force
Remove-Item -Path "C:\Users\$Username\dumper.zip" -Force

Write-Output "Downloading Frida Server..."
Invoke-WebRequest -Uri $FridaServerUrl -OutFile "$SdkPath\platform-tools\frida-server-16.5.1-android-x86.xz"
Write-Output "Extracting Frida Server..."
& 7z e "$SdkPath\platform-tools\frida-server-16.5.1-android-x86.xz" -o"$SdkPath\platform-tools" -y
Remove-Item -Path "$SdkPath\platform-tools\frida-server-16.5.1-android-x86.xz" -Force

Write-Output "Create Frida Server command.txt..."
@"
su
mv /sdcard/frida-server-16.5.1-android-x86 /data/local/tmp
chmod +x /data/local/tmp/frida-server-16.5.1-android-x86
/data/local/tmp/frida-server-16.5.1-android-x86
"@ | Set-Content -Path "$SdkPath\platform-tools\command.txt"

Write-Output "Install complete."
Write-Output "Wait for Emulator to fully boot and run frida.ps1 in a new window."
Write-Output "Then run dump.ps1"
