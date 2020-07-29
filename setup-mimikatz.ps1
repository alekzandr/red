$url = "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200715/mimikatz_trunk.zip"

$output = "$PSScriptRoot\mimikatz.zip"

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Mimikatz downloaded"


