# L3

## Requirements

- 7-Zip
- Java 17+
- Powershell 7
- Python

```sh
winget install 7zip.7zip
```

```sh
winget install Microsoft.OpenJDK.17
```

```sh
winget install Microsoft.PowerShell
```

```sh
pip install -r requirements.txt
```
OR
```sh
pip install frida==16.5.1 frida-tools==12.5.1 pycryptodome==3.20.0
```

## `install.ps1`

This script downloads and extracts:
- [dumper](https://github.com/lollolong/dumper)
- Android [Command-line tools](https://developer.android.com/tools/)
- [Frida Server](https://github.com/frida/frida)

Then:
- Creates AVD `pixel` with `Android 9.0`
- Enables hardware keyboard
- Starts emulator
- Sets up Frida command

After:
- Run `frida.ps1` in a new window
- Run `dump.ps1`

## `frida.ps1`

This script:
- Copies Frida Server to emulator
- Runs Frida Server

## `dump.ps1`

This script:
- Runs `dump_keys.py`
