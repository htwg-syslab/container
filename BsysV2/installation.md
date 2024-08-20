## BSYS Pocketlab

### Vorwort

Für die Installation des Pocketlab Docker Containers ist es nicht erforderlich, das GitHub-Repository zu klonen. Lokale Builds können je nach Systemkonfiguration und `.gitconfig`-Einstellungen variieren. Es wird daher empfohlen, die nachfolgende Anleitung zu befolgen.

### Ziel

Mit dem BSYS Pocketlab sollen Sie in die Lage versetzt werden, alle AIN BSYS Laboraufgaben in einem Linux-Container auf Ihrem bevorzugten Betriebssystem zu bearbeiten. Hierfür verwenden wir Docker, eine Open-Source-Software zur Isolierung von Anwendungen durch Containervirtualisierung. Docker vereinfacht die Bereitstellung von Anwendungen erheblich, da Container, die alle benötigten Pakete enthalten, leicht als Dateien transportiert und installiert werden können.

Ein Container ist eine leichtgewichtige, virtualisierte Umgebung, die den Anwendungsquellcode mit den Betriebssystembibliotheken und den notwendigen Abhängigkeiten kombiniert, um den Code auszuführen. Docker isoliert den Code, das Laufzeitmodul, Systemwerkzeuge und Systembibliotheken in einem Container, was die Entwicklung und Ausführung von Anwendungen in einer Sandbox-Umgebung vereinfacht. Docker Hub dient als öffentliches Repository für Docker-Images.

Wir nutzen Docker, um alle BSYS-Aufgaben in einem vorbereiteten Linux-Container zu bearbeiten und auszuführen. Ein fertig konfiguriertes Image steht dafür bereits auf Docker Hub zur Verfügung.

Es wird empfohlen, die Vorbereitung auf dem mobilen System durchzuführen, das Sie während der Laborstunden verwenden werden. Selbstverständlich besteht auch die Möglichkeit, die erforderliche Software zusätzlich auf Ihrem Desktop-System für zu Hause zu installieren, um Flexibilität und eine nahtlose Arbeitsumgebung zu gewährleisten.

### Vorbereitung

**WICHTIG: Bitte führen Sie die beiden folgenden Abschnitte "Vorbereitung..." unbedingt VOR dem ersten Labortermin durch**, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und zum Einrichten einige große Dateien benötigt werden. 

In der ersten Laborstunde werden wir uns mit den Themen:

- Login,
- SSH-Konfiguration und
- der Einrichtung von VS Code
  
beschäftigen. Diese Schritte können Sie selbstverständlich auch bereits im Vorfeld eigenständig durchführen, um optimal vorbereitet zu sein.

#### Vorbereitung Docker Desktop

Im Folgenden werden die erforderlichen Schritte für Einsteiger in Docker beschrieben. Erfahrene Nutzer finden weiter unten im Abschnitt „Quellen“ eine kompakte Übersicht mit allen notwendigen Informationen.

1. Besuchen Sie die [Docker-Website](https://www.docker.com/) und laden Sie die für Ihr Betriebssystem (Windows, Mac, Linux) geeignete Version herunter. Achten Sie bei macOS darauf, die passende Version für Ihren Prozessor (Intel oder ARM) auszuwählen.
2. Starten Sie Docker Desktop. Unter Windows kann es erforderlich sein, ein aktuelles WSL (Windows Subsystem for Linux) Kernel-Update zu installieren; Docker wird Sie gegebenenfalls durch ein Popup-Fenster darauf hinweisen. Wechseln Sie zur Containers-Übersicht (Symbol oben links) und sehen Sie sich die beiden Einführungsvideos „What is a Container“ und „How do I run a Container“ an, um einen ersten Eindruck von den Möglichkeiten und der Funktionalität von Docker zu gewinnen.

#### Vorbereitung BSYS Pocketlab

Der BSYS-Container ist bereits vorkonfiguriert und kann gestartet werden, sobald Docker Desktop läuft. Es stehen zwei Arten von Docker-Containern zur Verfügung:

- **pocketlabbase**: Ein minimales Docker-Image, das Ihnen den Zugriff auf das laufende Linux-System über ein Terminal ermöglicht. Die komplette Simulation und Code-Entwicklung kann ebenfalls über Visual Studio Code (VSCode) erfolgen. Weitere Informationen hierzu finden Sie weiter unten.

- **pocketlabui**: Dieses Image umfasst zusätzlich zur Basisversion ein grafisches Benutzerinterface (GUI), das es Ihnen ermöglicht, Linux über Ihren Browser zu bedienen.

Die Nutzung des GUI-Images ist optional und vor allem für Linux-Einsteiger gedacht. Für die Aufgaben im BSYS-Kurs reicht die Terminal-Nutzung oder die Integration mit Editoren wie VSCode vollkommen aus.

#### Architektur

Je nach verwendeter CPU-Architektur müssen Sie das passende Docker-Image auswählen, um eine optimale Leistung sicherzustellen. Es ist entscheidend, das Image auszuwählen, das nativ auf Ihrer spezifischen Architektur ausgeführt werden kann, sei es x86_64 (Intel/AMD) oder ARM64 (Apple M1/M2 oder andere ARM-basierte Prozessoren). Nur durch die Auswahl des korrekten Images kann gewährleistet werden, dass die Container ohne die Notwendigkeit einer Architektur-Emulation betrieben werden. Dadurch wird eine maximale Geschwindigkeit und Effizienz erreicht, da die Emulation von Architekturen häufig zu Leistungseinbußen führen kann.

##### X86 Architektur (Intel/AMD)

base:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase
```

ui:

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui
```

##### ARM Maschinen (Apple Mac mit M (1,2,3, ...) chips)

base:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase-ARM64
```

ui:

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui-AMR64
```

**Bitte beachten Sie, dass die im Folgenden dargestellten Beispiele speziell für die X86-Architektur ausgelegt sind. Wenn Sie auf einem System mit ARM64-Architektur arbeiten, ist es unerlässlich, die entsprechenden Images für ARM64 auszuwählen und Ihre Befehle entsprechend anzupassen (z.B. `pocketlabbase` mit `pocketlabbase-ARM64` ersetzen).**

Beim erstmaligen Start des Images wird es noch nicht lokal auf Ihrem System vorhanden sein und muss daher von Docker Hub heruntergeladen werden. Dieser Vorgang kann abhängig von Ihrer Internetverbindung einige Minuten in Anspruch nehmen. Da hierbei eine beträchtliche Menge an Daten übertragen wird, wird dringend empfohlen, den Download vorab zu Hause durchzuführen. Die WLAN-Verbindung an der HTWG bietet nur eine begrenzte Datenrate, was den Download erheblich verlangsamen könnte.

Nach Abschluss des Downloads sehen Sie den laufenden Pocketlab-Laborcontainer unter „Containers“ sowie das heruntergeladene `systemlabor/pocketlab` Image unter „Images“ in Docker Desktop.

Der Parameter `-p 127.0.0.1:40405:22` bei der Ausführung des Containers leitet den Port 22 (SSH) des Containers auf den lokalen Port 40405 Ihres Systems um. Wenn Sie sich per SSH mit dem Container verbinden möchten, nutzen Sie einen SSH-Client und stellen die Verbindung über den lokalen Port 40405 her. Detaillierte Anweisungen zur Konfiguration der SSH-Verbindung finden Sie in einem späteren Abschnitt dieses Dokuments. Dort wird der gesamte Prozess Schritt für Schritt erläutert, um sicherzustellen, dass die Verbindung korrekt und sicher eingerichtet wird.

Darüber hinaus wird für beide Container-Typen ein X-Server benötigt, um grafische Benutzeroberflächen (GUIs) von Anwendungen, die im Container laufen, auf der Host-Maschine anzuzeigen. Dies wird besonders gegen Ende des Kurses relevant.

### Wichtiger Hinweis

Beachten Sie, dass alle Einstellungen und Dateien im Container gelöscht werden, wenn dieser entfernt wird. Starten Sie den Container erneut, um Ihre Arbeit fortzusetzen, ohne ihn neu erstellen zu müssen.

### Login

Für den Zugriff auf den Container verwenden Sie einen automatisch generierten SSH-Schlüssel. Dieser wird beim ersten Start des Containers erstellt und in den Logs angezeigt. Zum Auslesen des Schlüssels können Sie die Docker-Logs einsehen:

```bash
docker logs pocketlab
```

Der Schlüssel ist zwischen den Zeilen `-----BEGIN OPENSSH PRIVATE KEY-----` und `-----END OPENSSH PRIVATE KEY-----` zu finden. Speichern Sie diesen Schlüssel in einer Datei, beispielsweise `~/.ssh/id_rsa_pocketlab.key`. **WICHTIG** Kopieren Sie auch die beiden Zeilen `-----BEGIN OPENSSH PRIVATE KEY-----` und `-----END OPENSSH PRIVATE KEY-----` mit!

Stellen Sie sicher, dass nur Sie darauf zugreifen können:

```bash
chmod 600 ~/.ssh/id_rsa_pocketlab.key
```

Mit folgendem Befehl können Sie sich dann per SSH in den Container einloggen:

```bash
ssh -p40405 -i ~/.ssh/id_rsa_pocketlab.key -X pocketlab@localhost
```
Die Option `-p40405` weist das SSH-Programm an, die Verbindung zum Remote-Server über den spezifischen Port 40405 herzustellen. In der Standardeinstellung nutzt SSH den Port 22 für Verbindungen. Durch die Angabe von `-p40405` wird der Standardport überschrieben, sodass SSH stattdessen den angegebenen alternativen Port verwendet. Dies ist besonders nützlich, wenn der SSH-Dienst auf dem Remote-Server aus Sicherheits- oder Konfigurationsgründen auf einem anderen Port als dem Standardport läuft.

Zur Erinnerung: In einem vorherigen Schritt haben wir das Docker-Image gestartet und dabei den im Docker-Image laufenden SSH-Server so konfiguriert, dass externe Zugriffe über den Port 40405 erfolgen.

### GUI-Zugriff

Für den Zugriff auf die grafische Benutzeroberfläche (GUI) geben Sie `localhost:40001` in die Adressleiste Ihres Browsers ein.

### SSH-Konfiguration

Um den SSH-Zugriff auf den Container zu vereinfachen, fügen Sie die folgende Konfiguration zu Ihrer `.ssh/config` Datei hinzu:

```ssh
Host pocketlab
    HostName localhost
    User pocketlab
    Port 40405
    IdentityFile ~/.ssh/id_rsa_pocketlab.key
    ForwardX11 yes
```

Nun können Sie sich einfach mit dem Befehl `ssh pocketlab` in den Container einloggen.

### VSCode-Integration

1. **Installation von VSCode und der Remote-SSH-Erweiterung**: Beginnen Sie mit der Installation von Visual Studio Code (VSCode), einer leistungsstarken und vielseitigen Entwicklungsumgebung, die sich ideal für das Arbeiten mit Docker-Containern eignet. Nachdem Sie VSCode erfolgreich installiert haben, fügen Sie die Erweiterung "Remote - SSH" hinzu. Diese Erweiterung ermöglicht es Ihnen, sich über SSH mit entfernten Maschinen oder Containern zu verbinden, wodurch Sie nahtlos in einer Remote-Umgebung arbeiten können, als wäre es eine lokale Entwicklungsumgebung.

2. **Verbindung zum Docker-Container herstellen**: Nach der Installation von VSCode und der Remote-SSH-Erweiterung öffnen Sie die Command Palette, indem Sie `Strg+Shift+P` (oder `Cmd+Shift+P` auf macOS) drücken. Geben Sie in der Suchleiste "Remote-SSH: Connect to Host" ein und wählen Sie diese Option aus. Es wird Ihnen eine Liste der verfügbaren Hosts angezeigt, die in Ihrer `.ssh/config` Datei konfiguriert sind. Wenn Sie die Konfiguration korrekt vorgenommen haben, sollte `pocketlab` als einer der Hosts in dieser Liste erscheinen. Wählen Sie `pocketlab` aus, um eine Verbindung zu Ihrem Docker-Container herzustellen.

Nachdem die Verbindung erfolgreich hergestellt wurde, können Sie Visual Studio Code nutzen, um direkt im Docker-Container zu arbeiten. Dies umfasst das Erstellen, Bearbeiten und Ausführen von C-Programmen oder anderen Codeprojekten. Durch die Remote-SSH-Verbindung arbeiten Sie in der gewohnten VSCode-Oberfläche, während Ihre Projekte auf dem entfernten Container ausgeführt werden, was eine nahtlose Integration von Entwicklung und Deployment ermöglicht.

### X-Server Windows

Für die Ausführung von X-Anwendungen auf einem Windows-Rechner empfehlen wir die Verwendung von "Xming". Xming ist ein Open-Source X-Server für Windows, der es ermöglicht, grafische Anwendungen von Unix- oder Linux-Systemen auf einem Windows-Rechner darzustellen. Es handelt sich um ein äußerst ressourcenschonendes Programm, das sowohl im Speicher- als auch im Rechenkapazitätsverbrauch minimal ist. [Download Xming](https://sourceforge.net/projects/xming/).

#### Xming automatisch beim Systemstart ausführen
Nach der Installation von Xming mit dem Installationsassistenten und den Standardeinstellungen können Sie Xming so konfigurieren, dass es automatisch beim Hochfahren des Systems gestartet wird:

1. **Xming-Verknüpfung suchen**: Drücken Sie die Windows-Taste, geben Sie "Xming" ein und wählen Sie "Dateispeicherort öffnen".
2. **Verknüpfung kopieren**: Ein Explorer-Fenster mit verschiedenen Xming-Verknüpfungen sollte sich öffnen. Suchen Sie die einfache "Xming"-Verknüpfung, klicken Sie mit der rechten Maustaste darauf und kopieren Sie den Pfad (dieser sollte standardmäßig unter `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Xming.lnk` gespeichert sein).
3. **Startup-Ordner öffnen**: Drücken Sie "WinKey + R", geben Sie `shell:startup` ein und bestätigen Sie mit Enter.
4. **Verknüpfung hinzufügen**: Im geöffneten Explorer-Fenster rechtsklicken Sie, wählen "Neue Verknüpfung", fügen den kopierten Pfad ein (ohne Anführungszeichen) und bestätigen Sie mit Enter.

Um sicherzustellen, dass Xming im Hintergrund läuft, überprüfen Sie die versteckten Symbole in der Taskleiste – dort sollte das Xming-Symbol angezeigt werden.

### X-Server Mac

#### 1. Installation von XQuartz

1. **Download**: Besuchen Sie die offizielle XQuartz-Webseite unter [https://www.xquartz.org/releases/XQuartz-2.8.5.html](https://www.xquartz.org/releases/XQuartz-2.8.5.html).
2. **Installation starten**: Laden Sie die neueste Version herunter, öffnen Sie die `.dmg`-Datei und folgen Sie den Anweisungen des Installationsassistenten.
3. **Neustart**: Nach Abschluss der Installation kann ein Neustart oder das Ab- und erneute Anmelden erforderlich sein.

#### 2. XQuartz automatisch beim Systemstart ausführen

Um XQuartz bei jedem Systemstart automatisch auszuführen, können Sie es zu den Anmeldeobjekten hinzufügen:

1. **Systemeinstellungen öffnen**: Öffnen Sie die „Systemeinstellungen“ und navigieren Sie zu „Benutzer & Gruppen“.
2. **Anmeldeobjekte verwalten**: Wählen Sie Ihr Benutzerkonto, klicken Sie auf „Anmeldeobjekte“ und fügen Sie XQuartz über das Pluszeichen `+` hinzu.

#### 3. XQuartz manuell starten

Falls gewünscht, können Sie XQuartz manuell starten: Gehen Sie zu „Programme“ > „Dienstprogramme“ und öffnen Sie XQuartz.

### X-Server Linux

Unter Linux läuft X11 nativ, daher sind keine weiteren Schritte erforderlich.


### Quellen

[Kurzinfo zum BSYS Pocketlab Dockerimage](https://github.com/htwg-syslab/container/tree/main/BsysV2/DockerExperts.md)