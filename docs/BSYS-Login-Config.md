## SSH-Schlüssel einrichten

Für den Zugriff auf den Container wird ein automatisch generierter SSH-Schlüssel verwendet. Dieser wird beim ersten Start des Containers erzeugt und in den Logs angezeigt.

### SSH-Schlüssel aus Docker-Logs extrahieren

Um den Schlüssel auszulesen:

```bash
docker logs pocketlab
```

Der Schlüssel befindet sich zwischen den Zeilen:

`-----BEGIN OPENSSH PRIVATE KEY-----`

und

`-----END OPENSSH PRIVATE KEY-----`.

### SSH-Verzeichnis vorbereiten

Die SSH-Konfigurationsdateien befinden sich im versteckten Verzeichnis `~/.ssh/`. Falls dieses Verzeichnis noch nicht existiert, legen Sie es an:

```bash
mkdir -p ~/.ssh
```

Unter Windows (PowerShell):

```powershell
mkdir $env:USERPROFILE\.ssh
```

### SSH-Schlüssel speichern

Legen Sie in `~/.ssh/` die Datei `id_rsa_pocketlab.key` an und kopieren Sie den kompletten Key hinein – **inklusive** der Zeilen `-----BEGIN OPENSSH PRIVATE KEY-----` und `-----END OPENSSH PRIVATE KEY-----`.

**Windows:** Am Ende der Datei muss ein Return-Zeichen stehen.

#### Windows: PowerShell-Skript

Beim manuellen Copy & Paste unter Windows kommt es oft zu Problemen (Steuerzeichen, falsches Encoding, CRLF statt LF), die zu folgendem Fehler führen:

```
Load key "...id_rsa_pocketlab.key": error in libcrypto
```

**Voraussetzungen:**
- Der Ordner `~\.ssh` muss existieren (siehe oben: `mkdir $env:USERPROFILE\.ssh`)
- Das Skript muss als `.ps1`-Datei gespeichert werden, bevor es ausgeführt werden kann. Hinweise dazu unter [PowerShell scripten](Anleitung_PowerShell_Script.md).

Dieses Skript kopiert den Key sauber in die Key-Datei:

```powershell
# get-pocketlab-key.ps1
# Extrahiert den Private Key aus Docker Logs und speichert ihn 1:1 sauber

# Konsolenausgabe auf UTF-8 umstellen
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$keyPath = "$env:USERPROFILE\.ssh\id_rsa_pocketlab.key"

Write-Host ">> Erzeuge SSH-Key unter: $keyPath"

# Abbruch, falls Datei schon existiert
if (Test-Path $keyPath) {
    Write-Error "Die Datei $keyPath existiert bereits!
Bitte die Datei zuerst manuell loeschen, bevor das Skript erneut gestartet wird."
    exit 1
}

# Key manuell extrahieren (wie sed '/BEGIN/,/END/p')
$inBlock = $false
$keyLines = @()

docker logs pocketlab | ForEach-Object {
    if ($_ -match "-----BEGIN OPENSSH PRIVATE KEY-----") { $inBlock = $true }
    if ($inBlock) { $keyLines += $_ }
    if ($_ -match "-----END OPENSSH PRIVATE KEY-----") { $inBlock = $false }
}

if (-not $keyLines) {
    Write-Error "Konnte keinen Key in den Logs finden!"
    exit 1
}

# Datei exakt so schreiben, wie extrahiert (UTF8 ohne BOM, nur LF)
$bytes = [System.Text.Encoding]::UTF8.GetBytes(($keyLines -join "`n") + "`n")
[System.IO.File]::WriteAllBytes($keyPath, $bytes)

# Rechte setzen
icacls $keyPath /inheritance:r /grant:r "$($env:USERNAME):(R)" | Out-Null

# Test
Write-Host ">> Prüfe Key..."
ssh-keygen -y -f $keyPath

Write-Host "`n>> Fertig! Key gespeichert unter: $keyPath"
Write-Host "Teste Verbindung mit:"
Write-Host "ssh -i $keyPath pocketlab@localhost -p 40405"
```

**WICHTIG:** PowerShell-Skripte sind standardmäßig blockiert. Erlauben Sie die Ausführung mit:

```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Ist die Key-Datei bereits vorhanden, muss diese zuerst gelöscht werden.

#### Mac/Linux

Unter Mac und Linux kopieren Sie den Key am einfachsten per Kommandozeile (im Home-Verzeichnis ausführen):

```bash
docker logs pocketlab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > ~/.ssh/id_rsa_pocketlab.key
```

### Berechtigungen setzen

Die Key-Datei darf nur für Sie lesbar sein:

```bash
chmod 600 ~/.ssh/id_rsa_pocketlab.key
```

**Windows-Nutzer:** Der Befehl `chmod` funktioniert nicht in PowerShell oder CMD. Führen Sie ihn stattdessen in **Git Bash** aus. Falls Sie Git Bash noch nicht installiert haben, siehe [SSH Clients](BSYS-SSH-Clients.md).

### Fehlerbehandlung

Falls Sie durch Neustart des Containers neue Keys erzeugt haben, kann folgende Meldung erscheinen:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

Lösung: Löschen Sie die localhost-Einträge in `~/.ssh/known_hosts`.

## SSH-Konfiguration

Um den SSH-Zugriff zu vereinfachen, fügen Sie folgende Konfiguration in `~/.ssh/config` ein:

```ssh
Host pocketlab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_pocketlab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```

Danach reicht `ssh pocketlab` zum Einloggen.

## SSH-Verbindung herstellen

```bash
ssh -p40405 -i ~/.ssh/id_rsa_pocketlab.key -X pocketlab@localhost
```

| Option | Bedeutung |
|--------|-----------|
| `-p40405` | SSH-Port des Containers (statt Standard-Port 22) |
| `-i ...` | Pfad zum Private Key |
| `-X` | X11-Forwarding für grafische Anwendungen |

Bei Problemen liefert `-v` erweiterte Diagnose-Informationen:

```bash
ssh -p40405 -v -i ~/.ssh/id_rsa_pocketlab.key pocketlab@localhost
```

Falls noch kein X-Server läuft, erscheint ggf.:

```text
xauth: (argv):1:  unable to open display "host.docker.internal:0".
```

Die X-Server-Konfiguration wird im weiteren Verlauf erläutert.

### Optional: GUI-Zugriff

Falls Sie die grafische Oberfläche nutzen möchten, siehe [UI-Variante](BSYS-UI-Variante.md).
