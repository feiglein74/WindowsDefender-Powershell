# CLAUDE.md

Diese Datei bietet Anleitungen für Claude Code (claude.ai/code) bei der Arbeit mit Code in diesem Repository.

## Zweck des Repositories

Dieses Repository enthält PowerShell-Skripte zur Verwaltung und Überwachung von Windows Defender in Windows Server-Umgebungen innerhalb einer Active Directory-Domäne.

## Architektur

### Skript-Design-Muster

Skripte in diesem Repository folgen einem gemeinsamen Muster:
1. **Anmeldeinformationsverwaltung**: Abfrage von Anmeldeinformationen mit `Get-Credential` zur Authentifizierung bei Remote-Servern
2. **AD-Computer-Erkennung**: Abfrage von Active Directory mit `Get-ADComputer` und Filtern zur Identifizierung der Zielserver
3. **Remote-Ausführung**: Verwendung von `Invoke-Command` mit den gesammelten Anmeldeinformationen zur Ausführung von Befehlen auf Remote-Servern
4. **Fehlerbehandlung**: `-ErrorAction SilentlyContinue` wird verwendet, um nicht erreichbare oder nicht reagierende Server ordnungsgemäß zu behandeln

### Active Directory-Filterung

Die Skripte verwenden AD-Filter, um bestimmte Servergruppen anzusprechen:
- Filter nach OperatingSystem: `'OperatingSystem -like "Windows Server*"'`
- Zusätzliche Filter können angewendet werden (z.B. PasswordLastset-Daten), um den Umfang einzugrenzen

### Remote-Befehlsausführung

Alle Skripte verwenden `Invoke-Command` mit:
- `-Credential $mycreds` für die Authentifizierung
- `-ComputerName $_` zur Ansprache jedes Servers in der Pipeline
- `-ScriptBlock {}` mit den remote auszuführenden Befehlen

## Entwicklung

### Skripte testen

Beim Testen von Skripten in diesem Repository:
```powershell
# Zuerst mit einem einzelnen Computer testen
$testComputer = "SERVER01"
Invoke-Command -Credential $mycreds -ComputerName $testComputer -ScriptBlock { ... }

# AD-Abfrage ohne Ausführung testen
Get-ADComputer -filter 'OperatingSystem -like "Windows Server*"' -Properties * | Select-Object Name
```

### Häufige Änderungen

Beim Erstellen neuer Skripte oder Ändern bestehender:
- AD-Filter können angepasst werden, um verschiedene OS-Versionen oder Servergruppen anzusprechen
- Weitere Eigenschaften können bei Bedarf zu `Get-ADComputer -Properties *` Abfragen hinzugefügt werden
- Der `-ErrorAction` Parameter kann auf `Stop` oder `Continue` für unterschiedliches Fehlerbehandlungsverhalten geändert werden
- Ausgabeformatierung in Betracht ziehen: `| Format-Table`, `| Export-Csv`, etc.

### Anforderungen

Skripte benötigen:
- Active Directory PowerShell-Modul (`Import-Module ActiveDirectory`)
- Entsprechende AD-Berechtigungen zum Abfragen von Computer-Objekten
- Administratoranmeldeinformationen für Remote-Server-Zugriff
- PowerShell-Remoting muss auf den Zielservern aktiviert sein

## Versionierung

Dieses Projekt verwendet [Semantic Versioning](https://semver.org/lang/de/) (MAJOR.MINOR.PATCH):

- **MAJOR**: Inkompatible API-Änderungen oder grundlegende Umstrukturierung
- **MINOR**: Neue Funktionalität, die abwärtskompatibel ist
- **PATCH**: Abwärtskompatible Fehlerbehebungen

### Versionsverwaltung

Die aktuelle Version wird in folgenden Dateien gepflegt:
- `VERSION`: Enthält die aktuelle Versionsnummer
- `CHANGELOG.md`: Dokumentiert alle Änderungen pro Version
- Git-Tags: Jede Version wird mit `git tag v1.0.0` markiert

### Version aktualisieren

Bei Änderungen:
1. `VERSION`-Datei mit neuer Versionsnummer aktualisieren
2. `CHANGELOG.md` unter [Unveröffentlicht] Änderungen dokumentieren
3. Bei Release: Unveröffentlichte Änderungen in neue Versionssektion verschieben
4. Git-Tag für die Version erstellen: `git tag -a v1.0.0 -m "Version 1.0.0"`
5. Tag pushen: `git push origin v1.0.0`
