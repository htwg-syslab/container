## SSH-Schlüssel einrichten

Für den Zugriff auf den Container wird ein automatisch generierter SSH-Schlüssel verwendet. Dieser Schlüssel wird beim ersten Start des Containers erzeugt und in den Logs angezeigt.

### SSH-Schlüssel aus Docker-Logs extrahieren

Um den Schlüssel auszulesen, können Sie die Docker-Logs aufrufen:

```bash
docker logs pocketlab
```

Der Schlüssel befindet sich zwischen den Zeilen:

`-----BEGIN OPENSSH PRIVATE KEY-----`

und

`-----END OPENSSH PRIVATE KEY-----`.

### SSH-Verzeichnis vorbereiten

Für den Kommandozeilen-Client `ssh` befinden sich die Konfigurationsdateien im versteckten Verzeichnis `.ssh/`. Schauen Sie also in Ihrem Home-Verzeichnis Ihres Rechners nach diesem Verzeichnis. Haben Sie in der Vergangenheit `ssh` benutzt, sollten darin bereits Dateien zu finden sein (z.B. die Datei `.ssh/known_hosts`).

Gibt es das Verzeichnis noch nicht, versuchen Sie bitte, auf den laufenden Container via `ssh` zuzugreifen:

```bash
ssh -p40405 -i  .ssh/id_rsa_pocketlab.key pocketlab@localhost
```

Der Zugriff funktioniert noch nicht, da der Key erst noch kopiert werden muss.

Allgemein: Um bei Problemen erweiterte Informationen des `ssh` Befehls zu erhalten benutzen Sie die `-v` Option, z.B.:

```bash
ssh -p40405 -v -i  .ssh/id_rsa_pocketlab.key pocketlab@localhost
```

### SSH-Schlüssel speichern

Legen Sie in dem `.ssh/` Verzeichnis die Datei `id_rsa_pocketlab.key` an. In diese Datei kopieren Sie den Key, also alle Zeichen zwischen den Zeilen und inkl. der Zeilen

```text
-----BEGIN OPENSSH PRIVATE KEY----- und
-----END OPENSSH PRIVATE KEY-----
```

**WICHTIG:** Achten Sie darauf, die Zeilen `-----BEGIN OPENSSH PRIVATE KEY-----` und `-----END OPENSSH PRIVATE KEY-----` ebenfalls vollständig zu kopieren! Bei Windows muss am Ende der Datei noch ein Return Zeichen eingefügt werden.

#### Windows-spezifische Lösung

Wenn man den Private Key aus `docker logs` per **Copy & Paste** unter Windows in einen Editor übernimmt, kommt es oft zu Problemen:

- Unsichtbare **Steuerzeichen** oder ANSI-Codes
- Falsches **Encoding** (z. B. UTF-16 mit BOM statt UTF-8/ASCII)
- Falsche **Zeilenenden** (CRLF statt LF)
- Extra-Leerzeilen am Ende

➡️ Ergebnis beim Login:
`Load key "...id_rsa_pocketlab.key": error in libcrypto`

Dieses ps1 Skript für Windows kopiert den key sauber in die key datei:

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

Dann können Sie das Skript ausführen. Hinweise zur Erstellung einer ps1 Datei und dessen Ausführung finden Sie hier: [Anleitung PowerShell Script](./Anleitung_PowerShell_Script.md)

Ist bereits die key Datei vorhanden so muss diese zuerst gelöscht werden.

#### Mac/Linux-Lösung

Unter Mac und Linux gibts mit dem Editor weniger Probleme oder man kopiert noch einfacher mit folgendem Kommandozeilen Befehl (Linux, Mac) den Sie in Ihrem Home Direktory aufrufen:

```bash
docker logs pocketlab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > ~/.ssh/id_rsa_pocketlab.key
```

Dieser Kommandozeile (alles in einer Zeile schrieben und mit Return ausführen!) liest die Log Datei des laufenden pocketlab Containers aus, filtern nur die Zeilen BEGIN, Key und der END Zeile aus und schreibt dann die gefilterte Informationen in die Datei `.ssh/id_rsa_pocketlab.key`. Dazu werden die Befehle (docker logs ... | sed ) hintereinander mit einer sogenannten Pipe ( | ) verbunden und ausgeführt und das Ergebnis wird nicht auf die Konsole sondern in eine Datei geschrieben, in dem die Ausgabe umgeleitet wird mit '>'.

### Berechtigungen setzen

Die Datei mit dem Key darf nur für Sie als User lesbar und schreibbar sein. Sind zu viele Lese- oder Schreibrechte auf die Datei möglich, so beschwert sich das ssh Programm entsprechend.

Stellen Sie sicher, dass nur Sie darauf zugreifen können:

```bash
chmod 600 ~/.ssh/id_rsa_pocketlab.key
```

### Fehlerbehandlung

Wichtig: Sollten Sie schon mit keys experimentiert haben und wieder durch das image starten neue keys erzeugt haben ist es möglich dass sich der ssh Befehl beschwert:

```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

Dann müssen Sie die localhost Einträge in der `.ssh/known_hosts` Datei löschen. ssh merkt nämlich, dass sie bereits auf diesem Host waren aber mit einem anderen Key ....

## SSH-Konfiguration

Um den SSH-Zugriff auf den Container zu vereinfachen, fügen Sie die folgende Konfiguration zu Ihrer `.ssh/config` Datei hinzu:

```ssh
Host pocketlab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_pocketlab.key
    ForwardX11 yes
    ForwardX11Trusted yes
```

Nun können Sie sich einfach mit dem Befehl `ssh pocketlab` in den Container einloggen.

## SSH-Verbindung herstellen

### Grundlegende SSH-Verbindung

Mit folgendem Befehl können Sie sich dann per SSH in den Container einloggen:

```bash
ssh -p40405 -i ~/.ssh/id_rsa_pocketlab.key -X pocketlab@localhost
```

### SSH-Optionen erklärt

**Port 40405:** Die Option `-p40405` weist das SSH-Programm an, die Verbindung zum Remote-Server über den spezifischen Port 40405 herzustellen. In der Standardeinstellung nutzt SSH den Port 22 für Verbindungen. Durch die Angabe von `-p40405` wird der Standardport überschrieben, sodass SSH stattdessen den angegebenen alternativen Port verwendet. Dies ist besonders nützlich, wenn der SSH-Dienst auf dem Remote-Server aus Sicherheits- oder Konfigurationsgründen auf einem anderen Port als dem Standardport läuft.

Zur Erinnerung: In einem vorherigen Schritt haben wir das Docker-Image gestartet und dabei den im Docker-Image laufenden SSH-Server so konfiguriert, dass externe Zugriffe über den Port 40405 erfolgen.

**X11-Forwarding:** Die Option `-X` bei `ssh` aktiviert **X11-Forwarding**, wodurch grafische Anwendungen, die auf einem Remote-Server laufen, auf Ihrem lokalen Rechner angezeigt werden können. Dadurch können Sie die Benutzeroberfläche von Programmen, die auf dem Remote-Server ausgeführt werden, nutzen, als ob sie lokal laufen würden. Dies ist besonders nützlich, wenn Sie auf einem entfernten Server arbeiten, aber dennoch Zugriff auf grafische Anwendungen benötigen.

### Fehlerbehandlung

Sollten Sie noch keinen XServer lokal gestartet haben, könnte Ihnen die folgende Fehlermeldung angezeigt werden:

```text
xauth: (argv):1:  unable to open display "host.docker.internal:0".
```

Die Konfiguration des XServers wird im weiteren Verlauf erläutert.

## GUI-Zugriff (Alternative)

Um Zugriff auf die **grafische Benutzeroberfläche (GUI)** des laufenden **Linux-Containers** zu erhalten, müssen Sie statt des `base` Containers den 'ui' Container gestartet und eingerichtet haben. Öffnen Sie einen Webbrowser Ihrer Wahl und geben Sie in die Adressleiste die URL `localhost:40001` ein.

Nach dem Aufruf dieser Adresse wird die grafische Oberfläche des Containers direkt in Ihrem Browser angezeigt. Sie können die Oberfläche wie gewohnt verwenden, indem Sie **Maus** und **Tastatur** nutzen. Dies ermöglicht Ihnen eine vollständige Interaktion mit dem Container, als ob Sie direkt vor einem physischen System sitzen würden.

Durch diese Methode können Sie komfortabel auf die GUI-basierten Anwendungen innerhalb des Containers zugreifen und diese in Ihrer gewohnten Arbeitsumgebung bedienen. Für das Praktikum wird die GUI-Version jedoch nicht benötigt. Sie bietet sich eher für den unerfahrenen Computer-User an.
