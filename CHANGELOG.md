# Änderungsprotokoll

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/).
Die Versionierung folgt [Semantic Versioning](https://semver.org/lang/de/).

## [Unveröffentlicht]

_Keine Änderungen_

## [1.1.0] - 2025-11-14

### Hinzugefügt
- PowerShell Comment-Based Help mit Synopsis, Description und Beispielen
- Parameter `-ExportPath` für CSV-Export der Ergebnisse
- Fehlerprotokollierung: Nicht erreichbare Server werden separat erfasst
- Computername in der Ausgabe für bessere Zuordnung
- Zeitstempel für jeden Eintrag (Format: yyyy-MM-dd HH:mm:ss)
- Progress-Bar zeigt Fortschritt während der Abfrage
- Farbcodierte Konsolenausgabe (Grün=OK, Rot=Fehler)
- Zusammenfassung mit Gesamtzahl, erfolgreiche und fehlerhafte Server
- Übersichtliche Tabellenausgabe mit `Format-Table`
- Try-Catch Fehlerbehandlung für robuste Ausführung
- Validierung: Prüfung ob Anmeldeinformationen eingegeben wurden
- Validierung: Prüfung ob Server in AD gefunden wurden

### Geändert
- `ErrorAction` von `SilentlyContinue` auf `Stop` für bessere Fehlerbehandlung
- Ausgabeformat von einfacher Liste zu strukturierter Tabelle
- Skript-Struktur verbessert mit klarer Trennung der Abschnitte

## [1.0.0] - 2025-11-14

### Hinzugefügt
- get-Server-winDefenderStatus.ps1: Skript zur Abfrage des Windows Defender Status auf allen Windows Servern in der AD-Domäne
- CLAUDE.md mit Architektur und Entwicklungshinweisen auf Deutsch
- Deutsche Kommentare im PowerShell-Skript
- CHANGELOG.md zur Dokumentation aller Änderungen
- TODO.md zur Verwaltung offener Aufgaben
- Semantic Versioning eingerichtet

### Geändert
- Alle Kommentare im Code auf Deutsch umgestellt
- Git-Commit-Nachrichten auf Deutsch umgestellt
