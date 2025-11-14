<#
.SYNOPSIS
    Abfrage des Windows Defender Status auf allen Windows Servern in der AD-Domäne

.DESCRIPTION
    Dieses Skript verbindet sich zu allen Windows Servern in Active Directory und
    prüft den Installationsstatus von Windows Defender. Die Ergebnisse werden in
    einer übersichtlichen Tabelle angezeigt und können optional nach CSV exportiert werden.

.PARAMETER ExportPath
    Optional: Pfad für CSV-Export der Ergebnisse

.EXAMPLE
    .\get-Server-winDefenderStatus.ps1

.EXAMPLE
    .\get-Server-winDefenderStatus.ps1 -ExportPath "C:\Reports\DefenderStatus.csv"

.NOTES
    Version: 1.1.0
    Autor: Generiert mit Claude Code
    Datum: 2025-11-14
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$ExportPath
)

# Anmeldeinformationen für Remote-Zugriff abfragen
Write-Host "`n=== Windows Defender Status Abfrage ===" -ForegroundColor Cyan
Write-Host "Bitte Anmeldeinformationen eingeben...`n" -ForegroundColor Yellow
$myCreds = Get-Credential

if (-not $myCreds) {
    Write-Host "Abbruch: Keine Anmeldeinformationen eingegeben." -ForegroundColor Red
    exit 1
}

# Alle Windows Server aus Active Directory abrufen
Write-Host "Rufe Windows Server aus Active Directory ab..." -ForegroundColor Cyan
try {
    # Verschiedene Filtermöglichkeiten (auskommentiert für spätere Nutzung):
    # Alle Computer: Get-ADComputer -Filter 'Name -like "*"' -Properties * | Select-Object -ExpandProperty Name
    # Mit Passwort-Filter: Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' -Properties * | where-object PasswordLastset -gt "2023.10.01" | Select-Object -ExpandProperty Name

    $PCName = Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' -Properties * | Select-Object -ExpandProperty Name

    if ($PCName.Count -eq 0) {
        Write-Host "Keine Windows Server in Active Directory gefunden." -ForegroundColor Red
        exit 1
    }

    Write-Host "Gefunden: $($PCName.Count) Windows Server`n" -ForegroundColor Green
}
catch {
    Write-Host "Fehler beim Abrufen der Server aus AD: $_" -ForegroundColor Red
    exit 1
}

# Ergebnis-Arrays initialisieren
$results = @()
$errors = @()
$counter = 0

# Windows Defender Status auf allen Servern abfragen
Write-Host "Prüfe Windows Defender Status auf allen Servern...`n" -ForegroundColor Cyan

foreach ($computer in $PCName) {
    $counter++
    $percentComplete = ($counter / $PCName.Count) * 100
    Write-Progress -Activity "Windows Defender Status wird geprüft" -Status "Server: $computer ($counter von $($PCName.Count))" -PercentComplete $percentComplete

    try {
        $defenderStatus = Invoke-Command -ErrorAction Stop -Credential $myCreds -ComputerName $computer -ScriptBlock {
            Get-WindowsFeature -Name windows-defender | Select-Object Name, InstallState
        }

        # Ergebnis zum Array hinzufügen
        $results += [PSCustomObject]@{
            ComputerName = $computer
            Feature = $defenderStatus.Name
            InstallState = $defenderStatus.InstallState
            Status = "Erfolgreich"
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        Write-Host "[OK] $computer - $($defenderStatus.InstallState)" -ForegroundColor Green
    }
    catch {
        # Fehler protokollieren
        $errors += [PSCustomObject]@{
            ComputerName = $computer
            Feature = "Windows-Defender"
            InstallState = "Unbekannt"
            Status = "Fehler: $_"
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        Write-Host "[FEHLER] $computer - Nicht erreichbar oder Fehler: $_" -ForegroundColor Red
    }
}

Write-Progress -Activity "Windows Defender Status wird geprüft" -Completed

# Zusammenfassung anzeigen
Write-Host "`n=== Zusammenfassung ===" -ForegroundColor Cyan
Write-Host "Gesamt Server: $($PCName.Count)" -ForegroundColor White
Write-Host "Erfolgreich geprüft: $($results.Count)" -ForegroundColor Green
Write-Host "Fehler: $($errors.Count)" -ForegroundColor Red

# Ergebnisse als Tabelle anzeigen
if ($results.Count -gt 0) {
    Write-Host "`n=== Erfolgreich geprüfte Server ===" -ForegroundColor Cyan
    $results | Format-Table -AutoSize
}

# Fehler anzeigen
if ($errors.Count -gt 0) {
    Write-Host "`n=== Fehler bei folgenden Servern ===" -ForegroundColor Yellow
    $errors | Format-Table -AutoSize
}

# Optional: Export nach CSV
if ($ExportPath) {
    try {
        $allResults = $results + $errors
        $allResults | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8
        Write-Host "`nErgebnisse exportiert nach: $ExportPath" -ForegroundColor Green
    }
    catch {
        Write-Host "`nFehler beim CSV-Export: $_" -ForegroundColor Red
    }
}

Write-Host "`nAbfrage abgeschlossen.`n" -ForegroundColor Cyan
