## X-Server Windows

Für die Ausführung von X-Anwendungen auf einem Windows-Rechner empfehlen wir die Verwendung von "Xming". Xming ist ein Open-Source X-Server für Windows, der es ermöglicht, grafische Anwendungen von Unix- oder Linux-Systemen auf einem Windows-Rechner darzustellen. Es handelt sich um ein äußerst ressourcenschonendes Programm, das sowohl im Speicher- als auch im Rechenkapazitätsverbrauch minimal ist. [Download Xming](https://sourceforge.net/projects/xming/).

### Xming automatisch beim Systemstart ausführen

Nach der Installation von Xming mit dem Installationsassistenten und den Standardeinstellungen können Sie Xming so konfigurieren, dass es automatisch beim Hochfahren des Systems gestartet wird:

1. **Xming-Verknüpfung suchen**: Drücken Sie die Windows-Taste, geben Sie "Xming" ein und wählen Sie "Dateispeicherort öffnen".
2. **Verknüpfung kopieren**: Ein Explorer-Fenster mit verschiedenen Xming-Verknüpfungen sollte sich öffnen. Suchen Sie die einfache "Xming"-Verknüpfung, klicken Sie mit der rechten Maustaste darauf und kopieren Sie den Pfad (dieser sollte standardmäßig unter `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Xming.lnk` gespeichert sein).
3. **Startup-Ordner öffnen**: Drücken Sie "WinKey + R", geben Sie `shell:startup` ein und bestätigen Sie mit Enter.
4. **Verknüpfung hinzufügen**: Im geöffneten Explorer-Fenster rechtsklicken Sie, wählen "Neue Verknüpfung", fügen den kopierten Pfad ein (ohne Anführungszeichen) und bestätigen Sie mit Enter.

Um sicherzustellen, dass Xming im Hintergrund läuft, überprüfen Sie die versteckten Symbole in der Taskleiste – dort sollte das Xming-Symbol angezeigt werden.

## X-Server Mac

### 1. Installation von XQuartz

1. **Download**: Besuchen Sie die offizielle XQuartz-Webseite unter [https://www.xquartz.org](https://www.xquartz.org).
2. **Installation starten**: Laden Sie die neueste Version herunter, öffnen Sie die `.dmg`-Datei und folgen Sie den Anweisungen des Installationsassistenten.
3. **XQuartz starten**: Auf macOS können Sie das **Spotlight-Suchfeld** mit der Tastenkombination `Command + Leertaste` öffnen. Geben Sie anschließend **XQuartz** ein und bestätigen Sie mit der Eingabetaste (`Return`), um das Programm zu starten. 4.**Konfiguration**:
4. Stellen Sie sicher, dass im Reiter „Sicherheit“ in den Einstellungen von XQuartz die Optionen „Verbindungen authentifizieren“ sowie „Verbindungen zu Netzwerk-Clients erlauben“ aktiviert sind.
5. Bitte beachten Sie, dass XQuartz nach jeder Änderung der Konfiguration neu gestartet werden muss, damit die Änderungen wirksam werden.
6. Öffnen Sie ein Terminal auf Ihrem macOS-System und führen Sie den Befehl `xhost +localhost` aus. Dieser Befehl autorisiert den X-Server (z. B. XQuartz), Verbindungen von lokal ausgeführten Anwendungen zu akzeptieren, sodass Programme, die auf demselben Rechner (localhost) ausgeführt werden, Zugriff auf die grafische Oberfläche (Display) erhalten.
7. Sollte `xhost` den Fehler "unable to open DISPLAY" melden, können Sie die DISPLAY-Variable manuell setzen, bevor Sie den ssh-Befehl ausführen. Ermitteln Sie dazu zunächst Ihre aktuelle IP-Adresse und führen Sie in der Shell, von der aus Sie den ssh-Befehl starten möchten, den folgenden Befehl aus: `export DISPLAY=<Ihre_IP>:0.0` . Anschließend sollte xhost korrekt funktionieren, und Sie können sich wie gewohnt per ssh mit pocketlab verbinden.

### 2. XQuartz automatisch beim Systemstart ausführen

Um XQuartz bei jedem Systemstart automatisch auszuführen, können Sie es zu den Anmeldeobjekten hinzufügen:

1. **Systemeinstellungen öffnen**: Öffnen Sie die „Systemeinstellungen“ und navigieren Sie zu „Benutzer & Gruppen“.
2. **Anmeldeobjekte verwalten**: Wählen Sie Ihr Benutzerkonto, klicken Sie auf „Anmeldeobjekte“ und fügen Sie XQuartz über das Pluszeichen `+` hinzu.

## X-Server Linux

Unter Linux läuft X11 nativ, daher sind keine weiteren Schritte erforderlich.
