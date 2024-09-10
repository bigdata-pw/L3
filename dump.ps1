$Username = [System.Environment]::UserName

Set-Location -Path "C:\Users\$Username\dumper\dumper-main"
python dump_keys.py