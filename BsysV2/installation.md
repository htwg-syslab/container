## BSYS Pocketlab

### Ziel
Mit dem BSYS Pocketlab sollen Sie in der Lage sein, alle AIN BSYS Laboraufgaben in einem Linux-Container auf dem Betriebssystem Ihrer Wahl zu bearbeiten. Dazu nutzen wir Docker, eine freie Software zur Isolierung von Anwendungen mittels Containervirtualisierung. Docker vereinfacht die Bereitstellung von Anwendungen, da Container, die alle nötigen Pakete enthalten, leicht als Dateien transportiert und installiert werden können. Ein Container ist eine leichtgewichtige, virtualisierte Umgebung, die den Anwendungsquellcode mit den Betriebssystembibliotheken und den Abhängigkeiten kombiniert, die zur Ausführung des Codes benötigt werden. Docker isoliert Code, Laufzeitmodul, Systemwerkzeuge und Systembibliotheken in einem Container, was die Entwicklung und Ausführung von Anwendungen in einer Sandbox erleichtert. Docker Hub ist ein öffentliches Repository für Docker-Images.

Wir verwenden Docker, um alle BSYS Homeworks in einem vorbereiteten Linux-Container zu bearbeiten und auszuführen. Ein fertiges Image steht dazu bereits auf Docker Hub bereit.

Die zwei Abschnitte "Vorbereitung... " sollten Sie unbedingt VOR dem Start des ersten Labortermins durchführen, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und wir zum Einrichten einige große Dateien benötigen.

### Vorbereitung Docker Desktop

Im Folgenden werden die nötigen Schritte für "Docker Newbies" erklärt. Die Docker-Profis unter Ihnen finden weiter unten unter dem Punkt Quellen eine Kurzinfo mit allen nötigen Informationen.

1. Besuchen Sie die Docker [Homepage](https://www.docker.com/) und laden Sie dort die für Ihr Betriebssystem (Windows / Mac / Linux) nötige Version herunter. Achten Sie beim Mac auf die richtige Binary-Version, je nachdem ob Sie einen Intel- oder ARM-Chip haben.
2. Starten Sie Docker Desktop. Unter Windows müssen Sie unter Umständen einen aktuellen WSL Windows Kernel installieren. Docker informiert Sie darüber in einem Popup-Fenster. Gehen Sie auf die Containers-Seite (Icon oben links) und schauen Sie sich die beiden Walkthroughs „What is a Container“ und "How do I run a Container" an. Damit bekommen Sie einen ersten Eindruck, was Docker Ihnen an Funktionalität bieten kann.

### Vorbereitung BSYS Pocketlab

Für BSYS ist der Container bereits erstellt und kann nun - wenn Docker Desktop läuft - gestartet werden. Es werden zwei Typen von Docker-Containern angeboten: einmal mit und einmal ohne grafische Oberfläche. Die grafische Oberfläche ist nicht zwingend notwendig, erleichtert aber ggf. die Nutzung für Linux-Neulinge. Für alle Aufgaben im BSYS-Kurs reicht das Terminal mit Editoren (z.B. VSCode) völlig aus. Zu beachten: Der Container mit der grafischen Oberfläche benötigt ca. 2,5 GB mehr Speicherplatz als der Container ohne GUI.

Mit grafischer Oberfläche:

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui
```


Standard:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase
```


Beim ersten Aufruf haben Sie dieses Image noch nicht lokal, und daher wird das Image von Docker Hub heruntergeladen. Das dauert je nach Ihrer Internetverbindung einige Minuten. Da hier eine Menge Daten heruntergeladen werden, sollten Sie dies zu Hause vorbereiten und nicht an der HTWG, da die WLAN-Verbindung an der HTWG nur eine geringe Datenrate erlaubt, wodurch der Download sehr lange dauern würde.

Nach dem Download sehen Sie den laufenden Pocketlab-Laborcontainer unter ‚Containers‘ und das heruntergeladene `systemlabor/pocketlab` Image unter 'Images'.

Der `-p 127.0.0.1:40405:22` Aufruf leitet den Port 22 (SSH) vom Container auf den lokalen Port 40405 Ihres Systems um. Wenn Sie sich nun via SSH auf den Container einloggen wollen, verwenden Sie dafür einen SSH-Client und verbinden sich mit Ihrem lokalen Port 40405.

Des Weiteren wird für beide Container-Typen ein X-Server benötigt, um GUI-Applikationen, die im Container laufen, auf der Host-Maschine anzuzeigen (wichtig gegen Ende des Kurses).

#### X-Server für Windows:

Wir nutzen hierzu "Xming". Xming ist ein Open-Source X-Server für Windows, der es ermöglicht, grafische Anwendungen von Unix- oder Linux-Systemen auf einem Windows-Rechner auszuführen. Es handelt sich um ein sehr kleines Programm, das weder Speicher- noch Rechenkapazität benötigt. [Download Xming](https://sourceforge.net/projects/xming/).

###### Optional:
Nach dem Herunterladen und Installieren mit dem Installations-assistenten und den Standardeinstellungen wollen wir Xming beim Hochfahren mit starten:

1. Suchen Sie den Pfad zum Xming-Shortcut (nicht den direkten Pfad, sonst begrüßt Sie jedes Mal ein Pop-up, wenn Sie Ihren PC starten). Drücken Sie die Windows-Taste, suchen Sie Xming, und öffnen Sie den Dateispeicherort.
3. Es sollte sich ein Explorer-Fenster mit mehreren Xming-Variationen öffnen. Suchen Sie den "reinen" Xming-Shortcut mit dem simplen Namen "Xming", rechts-klicken Sie darauf und kopieren den Pfad (standardmäßig sollte dieser unter "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Xming.lnk" sein) in die Zwischenablage.
4. Drücken Sie "WinKey + R" und geben Sie in das Fenster `shell:startup` ein, gefolgt von Enter.
5. Es sollte sich ein Explorer-Fenster öffnen. Rechtsklicken Sie dort, wählen Sie "Neuer Shortcut" und geben Sie den gerade kopierten Pfad ein (Achtung: Es dürfen am Anfang und Ende keine Anführungszeichen stehen), dann drücken Sie Enter.
([Quelle](https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd))

### Login

Nun fehlt nur noch das Passwort ... und das bekommen Sie auch nicht, denn es ist keines eingerichtet. Wir machen das auf eine bessere und professioneller Weise:

Wenn der Container neu angelegt wird (also jedes Mal, wenn Sie den Container löschen und neu anlegen), durchläuft der Container ein internes Skript, das einen neuen 'random' Schlüssel anlegt. Diesen Schlüssel benötigen Sie, um sich einloggen zu können. Also Achtung: Wenn Sie den Container löschen und einen neuen Container anlegen, wird auch ein neuer Schlüssel erzeugt. Aber keine Sorge:

1. Das wird nicht oft vorkommen (wenn überhaupt), dass Sie einen Container löschen und neu anlegen müssen. Es reicht, den Container zu stoppen und neu zu starten.
2. Das Auslesen des Schlüssels ist sehr einfach.

### BSYS Pocketlab Security

Gehen Sie in Ihrem Docker Desktop auf den laufenden Container und schauen Sie dort in die Logs. Ziemlich am Ende des Logs steht der Key zwischen den beiden Zeilen:

```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

Zeigt Docker Ihnen nichts unter dem Log-Reiter an, benutzen Sie einfach die Kommandozeile:

```bash
docker logs pocketlab
```

Dieser Schlüssel wird nun Ihrem lokal installierten SSH-Client bekannt gegeben, und danach können Sie sich ohne Passwort direkt im Container einloggen.

Für den Kommandozeilen-Client 'ssh' befinden sich die Konfigurationsdateien im versteckten Verzeichnis `.ssh/`. Schauen Sie also mal in Ihrem Home-Verzeichnis nach diesem Verzeichnis. Haben Sie in der Vergangenheit SSH benutzt, sollten darin schon Dateien zu finden sein (z.B. die Datei `.ssh/known_hosts`). Gibt es das Verzeichnis noch nicht, versuchen Sie bitte, auf den laufenden Container via SSH zuzugreifen:

```bash
ssh -p40405 -i -x .ssh/id_rsa_pocketlab.key pocketlab@localhost
```

Nach dem Akzeptieren der Verbindung das SSH-Programm mit STRG+C abbrechen. Nun sollte das `.ssh` Verzeichnis angelegt worden sein.

Legen Sie in diesem `.ssh` Verzeichnis die selbst erstellte Datei `id_rsa_pocketlab.key` an. In diese Datei kopieren Sie den Key, also alle Zeichen zwischen den Zeilen:

```
-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----
```

gefolgt von einem Enter nach dem letzten `-`.

## RSA key mit Linux / Mac

Oben genanntes können Sie noch einfacher mit folgendem Kommandozeilen-Befehl (nur Linux, Mac), den Sie in Ihrem Home-Verzeichnis aufrufen:

```bash
docker logs pocketlab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > .ssh/id_rsa_pocketlab.key
```

Dieser Befehl liest die Log-Datei des laufenden Pocketlab-Containers aus, filtert nur die Zeilen BEGIN, Key und END heraus und schreibt dann die gefilterten Informationen in die Datei `.ssh/id_rsa_pocketlab.key`. Dazu werden die Befehle (`docker logs ... | sed`) hintereinander mit einer sogenannten Pipe (`|`) verbunden und ausgeführt, und das Ergebnis wird in eine Datei geschrieben, indem die Ausgabe mit '>' umgeleitet wird.

Die Datei mit dem Key darf nur für Sie als User lesbar und schreibbar

 sein. Sind zu viele Lese- oder Schreibrechte auf die Datei möglich, beschwert sich das SSH-Programm entsprechend.

Ist der Key gespeichert, können Sie sich nun mit folgendem Befehl aus der Kommandozeile auf dem Container einloggen (Achtung das X muss groß sein, sonst ist das X-forwarding deaktiviert.):

```bash
ssh -p40405 -i -X .ssh/id_rsa_pocketlab.key pocketlab@localhost
```

Bei Problemen überprüfen Sie bitte, ob wirklich der richtige und vollständige Key in der Datei `.ssh/id_rsa_pocketlab.key` steht, beginnend mit der Zeile `-----BEGIN OPENSSH PRIVATE KEY-----` und endend mit der Zeile `-----END OPENSSH PRIVATE KEY-----`.

Die im Container installierte Python-Version können Sie mit

```bash
python3 --version
```
überprüfen.

Um zu testen, ob der X-Server funktioniert, verwenden Sie den Befehl:
```shell
xeyes
```
 Es sollten Squiggle Eyes aufploppen, die dem Cursor folgen.

#### GUI-Zugriff

Falls Sie Zugriff auf die GUI erhalten möchten, können Sie dies über Ihren Browser tun. Geben Sie dazu `localhost:40001` oder [127.0.0.1](http://127.0.0.1:40001/) in die URL-Leiste Ihres Browsers ein.

### SSH-Konfigurationsdatei

Damit Sie sich komfortabel von überall aus Ihrem System schnell in den laufenden Docker-Container einloggen können, konfigurieren wir SSH entsprechend. Konfigurationen Ihres SSH-Clients nehmen Sie in der Datei `.ssh/config` vor. Haben Sie diese Datei noch nicht im `.ssh/` Verzeichnis, speichern Sie einfach die folgenden Einträge als `.ssh/config` Datei ab. Ansonsten erweitern Sie die bestehende Datei entsprechend:

```ssh
Host pocketlab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_pocketlab.key
    ForwardX11 yes
```

Mit
```shell
ssh pocketlab
```

in einem Terminal können Sie sich nun ohne weitere Rückfragen nach Passwort oder Ähnlichem direkt in den Container einloggen.

### VSCode Anbindung

1. Installieren Sie VSCode.
2. Installieren Sie die Remote-SSH-Extension.
3. Unter der Command Palette können Sie nun "Remote-SSH: Connect to Host" aufrufen. Ist die `.ssh/config` wie oben angelegt, wird der pocketlab Host direkt angeboten. Wählen Sie den Host aus. Sie werden nach dem Typ des Hosts gefragt, wählen Sie hier Linux aus.

Damit haben Sie nun ein VSCode-Entwickslungsfenster, welches den Docker-Container nutzt, sodass Sie Ihre C-Programme im Docker-Container erstellen, editieren und ausführen können. Plugins des VSCode können nun auch auf dem Container installiert werden und sind bei einem späteren Reconnect wieder verfügbar.

**ACHTUNG**
Wenn Sie Ihr Betriebssystem herunterfahren, wird der Docker-Container gestoppt. Natürlich können Sie jederzeit den Container auch selbst stoppen. Starten Sie dann zu einem späteren Zeitpunkt den Container wieder, um weiterarbeiten zu können. Wenn Sie den Container löschen und neu anlegen, sind alle Ihre Einstellungen gelöscht. Sie müssen dann wieder mit der Konfiguration, beginnend mit dem Key (siehe oben), starten und die auf dem Container vorhandenen Dateien (wie z.B. die für den Container installierten VSCode-Plugins) neu installieren/kopieren.

### Quellen

[Kurzinfo zum BSYS Pocketlab Dockerimage](https://github.com/htwg-syslab/container/blob/main/bsys/README.md)