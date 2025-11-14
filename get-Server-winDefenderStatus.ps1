# Anmeldeinformationen für Remote-Zugriff abfragen
$myCreds = Get-Credential

# Alle Server aus Active Directory abrufen
#$PCName = Get-ADComputer -Filter 'Name -like "*"' -Properties * | Select-Object -ExpandProperty Name
# Mit Filter für Passwort-Änderungsdatum
#$PCName = Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' -Properties * | where-object PasswordLastset -gt "2023.10.01" | Select-Object -ExpandProperty Name
# Alle Windows Server abrufen
$PCName = Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' -Properties * | Select-Object -ExpandProperty Name

# Windows Defender Status auf allen Servern abfragen
$PCName | Foreach-Object { Invoke-Command -ErrorAction SilentlyContinue -Credential $mycreds -ComputerName $_ -ScriptBlock {get-windowsfeature -name windows-defender | select-object InstallState }}
