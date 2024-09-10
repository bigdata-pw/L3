$Username = [System.Environment]::UserName
$SdkPath = "C:\Users\$Username\AppData\Local\Android\Sdk"

Set-Location -Path "$SdkPath\platform-tools"

Write-Output "Pushing Frida Server to Emulator..."
Start-Process -FilePath ".\adb.exe" -ArgumentList @("push", "frida-server-16.5.1-android-x86", "/sdcard") -Wait

Write-Output "Run Frida Server..."
cmd /c "adb shell < command.txt"
