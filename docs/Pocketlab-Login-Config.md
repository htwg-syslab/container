## SSH-Schlüssel einrichten

Für den Zugriff auf den Container wird ein automatisch generierter SSH-Schlüssel verwendet. Dieser wird beim ersten Start des Containers erzeugt und in den Logs angezeigt.

Die folgenden Anleitungen gelten für alle Pocketlab-Container. Verwenden Sie die Werte Ihres Labors:

| | BSYS | ESYS |
|---|---|---|
| Container-Name | `bsyslab` | `esyslab` |
| SSH-Port | `40405` | `40407` |
| Key-Datei | `id_rsa_bsyslab.key` | `id_rsa_esyslab.key` |

### SSH-Schlüssel aus Docker-Logs extrahieren

Um den Schlüssel auszulesen (ersetzen Sie `<container-name>` durch `bsyslab` oder `esyslab`):

```bash
docker logs <container-name>
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

Legen Sie in `~/.ssh/` die Key-Datei an (z.B. `id_rsa_bsyslab.key` für BSYS oder `id_rsa_esyslab.key` für ESYS) und kopieren Sie den kompletten Key hinein – **inklusive** der Zeilen `-----BEGIN OPENSSH PRIVATE KEY-----` und `-----END OPENSSH PRIVATE KEY-----`.

**Windows:** Am Ende der Datei muss ein Return-Zeichen stehen.

#### Windows: PowerShell-Skript

Beim manuellen Copy & Paste unter Windows kommt es oft zu Problemen (Steuerzeichen, falsches Encoding, CRLF statt LF), die zu folgendem Fehler führen:

```
Load key "...id_rsa_bsyslab.key": error in libcrypto
```

**Voraussetzungen:**
- Der Ordner `~\.ssh` muss existieren (siehe oben: `mkdir $env:USERPROFILE\.ssh`)
- Das Skript muss als `.ps1`-Datei gespeichert werden, bevor es ausgeführt werden kann. Hinweise dazu unter [PowerShell scripten](Anleitung_PowerShell_Script.md).

Dieses Skript kopiert den Key sauber in die Key-Datei. Passen Sie die ersten beiden Variablen an Ihr Labor an:

```powershell
# get-lab-key.ps1
# Extrahiert den Private Key aus Docker Logs und speichert ihn 1:1 sauber
#
# Passen Sie diese Werte an Ihr Labor an:
$containerName = "bsyslab"          # oder "esyslab"
$keyFileName   = "id_rsa_bsyslab.key" # oder "id_rsa_esyslab.key"

# Konsolenausgabe auf UTF-8 umstellen
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$keyPath = "$env:USERPROFILE\.ssh\$keyFileName"

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

docker logs $containerName | ForEach-Object {
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
Write-Host "ssh -i $keyPath pocketlab@localhost -p $( if ($containerName -eq 'bsyslab') { '40405' } else { '40407' } )"
```

**WICHTIG:** PowerShell-Skripte sind standardmäßig blockiert. Erlauben Sie die Ausführung mit:

```bash
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Ist die Key-Datei bereits vorhanden, muss diese zuerst gelöscht werden.

#### Mac/Linux

Unter Mac und Linux kopieren Sie den Key am einfachsten per Kommandozeile (im Home-Verzeichnis ausführen). Ersetzen Sie `<container-name>` und `<key-datei>` passend:

**BSYS:**
```bash
docker logs bsyslab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > ~/.ssh/id_rsa_bsyslab.key
```

**ESYS:**
```bash
docker logs esyslab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > ~/.ssh/id_rsa_esyslab.key
```

### Berechtigungen setzen

Die Key-Datei darf nur für Sie lesbar sein:

```bash
chmod 600 ~/.ssh/id_rsa_bsyslab.key   # BSYS
chmod 600 ~/.ssh/id_rsa_esyslab.key   # ESYS
```

**Windows-Nutzer:** Der Befehl `chmod` funktioniert nicht in PowerShell oder CMD. Führen Sie ihn stattdessen in **Git Bash** aus. Falls Sie Git Bash noch nicht installiert haben, siehe [SSH Clients](SSH-Clients.md).

### Fehlerbehandlung

Falls Sie durch Neustart des Containers neue Keys erzeugt haben, kann folgende Meldung erscheinen:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

Lösung: Löschen Sie die localhost-Einträge in `~/.ssh/known_hosts`.

## SSH-Konfiguration

Um den SSH-Zugriff zu vereinfachen, fügen Sie die passende Konfiguration in `~/.ssh/config` ein:

**BSYS:**
```ssh
Host bsyslab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_bsyslab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```

**ESYS:**
```ssh
Host esyslab
    HostName localhost
    User pocketlab
    Port 40407
    IdentityFile ~/.ssh/id_rsa_esyslab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```

Falls Sie beide Labore besuchen, fügen Sie beide Blöcke ein.

Danach reicht `ssh bsyslab` bzw. `ssh esyslab` zum Einloggen.

## SSH-Verbindung herstellen

Beispiel für BSYS (für ESYS Port und Key-Datei entsprechend anpassen):

```bash
ssh -p40405 -i ~/.ssh/id_rsa_bsyslab.key -X pocketlab@localhost
```

| Option | Bedeutung |
|--------|-----------|
| `-p40405` | SSH-Port des Containers (statt Standard-Port 22) |
| `-i ...` | Pfad zum Private Key |
| `-X` | X11-Forwarding für grafische Anwendungen |

Bei Problemen liefert `-v` erweiterte Diagnose-Informationen:

```bash
ssh -p40405 -v -i ~/.ssh/id_rsa_bsyslab.key pocketlab@localhost
```

Falls noch kein X-Server läuft, erscheint ggf.:

```text
xauth: (argv):1:  unable to open display "host.docker.internal:0".
```

Die X-Server-Konfiguration wird im weiteren Verlauf erläutert.
