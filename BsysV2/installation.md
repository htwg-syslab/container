## BSYS Pocketlab

### Vorwort

Für die Installation des Pocketlab Docker Containers ist es nicht erforderlich, das GitHub-Repository zu klonen. Lokale Builds können je nach Systemkonfiguration und `.gitconfig`-Einstellungen variieren. Es wird daher empfohlen, die nachfolgende Anleitung zu befolgen.

### Ziel

Mit dem BSYS Pocketlab sollen Sie in die Lage versetzt werden, alle AIN BSYS Laboraufgaben in einem Linux-Container auf Ihrem bevorzugten Betriebssystem zu bearbeiten. Hierfür verwenden wir Docker, eine Open-Source-Software zur Isolierung von Anwendungen durch Containervirtualisierung. Docker vereinfacht die Bereitstellung von Anwendungen erheblich, da Container, die alle benötigten Pakete enthalten, leicht als Dateien transportiert und installiert werden können.

Ein Container ist eine leichtgewichtige, virtualisierte Umgebung, die den Anwendungsquellcode mit den Betriebssystembibliotheken und den notwendigen Abhängigkeiten kombiniert, um den Code auszuführen. Docker isoliert den Code, das Laufzeitmodul, Systemwerkzeuge und Systembibliotheken in einem Container, was die Entwicklung und Ausführung von Anwendungen in einer Sandbox-Umgebung vereinfacht. Docker Hub dient als öffentliches Repository für Docker-Images.

Wir nutzen Docker, um alle BSYS-Aufgaben in einem vorbereiteten Linux-Container zu bearbeiten und auszuführen. Ein fertig konfiguriertes Image steht dafür bereits auf Docker Hub zur Verfügung.

**Bitte führen Sie die beiden Abschnitte "Vorbereitung..." unbedingt VOR dem ersten Labortermin durch,** da die WLAN-Durchsatzrate an der HTWG begrenzt ist und zum Einrichten einige große Dateien benötigt werden.


### Vorbereitung Docker Desktop

Im Folgenden werden die erforderlichen Schritte für Einsteiger in Docker beschrieben. Erfahrene Nutzer finden weiter unten im Abschnitt „Quellen“ eine kompakte Übersicht mit allen notwendigen Informationen.

1. Besuchen Sie die [Docker-Website](https://www.docker.com/) und laden Sie die für Ihr Betriebssystem (Windows, Mac, Linux) geeignete Version herunter. Achten Sie bei macOS darauf, die passende Version für Ihren Prozessor (Intel oder ARM) auszuwählen.
2. Starten Sie Docker Desktop. Unter Windows kann es erforderlich sein, ein aktuelles WSL (Windows Subsystem for Linux) Kernel-Update zu installieren; Docker wird Sie gegebenenfalls durch ein Popup-Fenster darauf hinweisen. Wechseln Sie zur Containers-Übersicht (Symbol oben links) und sehen Sie sich die beiden Einführungsvideos „What is a Container“ und „How do I run a Container“ an, um einen ersten Eindruck von den Möglichkeiten und der Funktionalität von Docker zu gewinnen.


### Vorbereitung BSYS Pocketlab

Der BSYS-Container ist bereits vorkonfiguriert und kann gestartet werden, sobald Docker Desktop läuft. Es stehen zwei Arten von Docker-Containern zur Verfügung:

- **pocketlabbase**: Ein minimales Docker-Image, das Ihnen den Zugriff auf das laufende Linux-System über ein Terminal ermöglicht. Die komplette Simulation und Code-Entwicklung kann ebenfalls über Visual Studio Code (VSCode) erfolgen. Weitere Informationen hierzu finden Sie weiter unten.

- **pocketlabui**: Dieses Image umfasst zusätzlich zur Basisversion ein grafisches Benutzerinterface (GUI), das es Ihnen ermöglicht, Linux über Ihren Browser zu bedienen.

Die Nutzung des GUI-Images ist optional und vor allem für Linux-Einsteiger gedacht. Für die Aufgaben im BSYS-Kurs reicht die Terminal-Nutzung oder die Integration mit Editoren wie VSCode vollkommen aus.

### Architektur

Je nach verwendeter CPU-Architektur müssen Sie das passende Docker-Image auswählen, um eine optimale Leistung sicherzustellen. Es ist entscheidend, das Image auszuwählen, das nativ auf Ihrer spezifischen Architektur ausgeführt werden kann, sei es x86_64 (Intel/AMD) oder ARM (Apple M1/M2 oder andere ARM-basierte Prozessoren). Nur durch die Auswahl des korrekten Images kann gewährleistet werden, dass die Container ohne die Notwendigkeit einer Architektur-Emulation betrieben werden. Dadurch wird eine maximale Geschwindigkeit und Effizienz erreicht, da die Emulation von Architekturen häufig zu Leistungseinbußen führen kann.


#### X86 Architektur (Intel/AMD):


base:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase
```

ui:

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui
```



#### ARM Maschinen (Apple Mac mit M (1,2,3, ...) chips):


base:

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase-arm64
```

ui:

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui-arm64
```

Beim erstmaligen Start des Images wird es noch nicht lokal auf Ihrem System vorhanden sein und muss daher von Docker Hub heruntergeladen werden. Dieser Vorgang kann abhängig von Ihrer Internetverbindung einige Minuten in Anspruch nehmen. Da hierbei eine beträchtliche Menge an Daten übertragen wird, wird dringend empfohlen, den Download vorab zu Hause durchzuführen. Die WLAN-Verbindung an der HTWG bietet nur eine begrenzte Datenrate, was den Download erheblich verlangsamen könnte.

Nach Abschluss des Downloads sehen Sie den laufenden Pocketlab-Laborcontainer unter „Containers“ sowie das heruntergeladene `systemlabor/pocketlab` Image unter „Images“ in Docker Desktop.

Der Parameter `-p 127.0.0.1:40405:22` bei der Ausführung des Containers leitet den Port 22 (SSH) des Containers auf den lokalen Port 40405 Ihres Systems um. Wenn Sie sich per SSH mit dem Container verbinden möchten, nutzen Sie einen SSH-Client und stellen die Verbindung über den lokalen Port 40405 her.

Darüber hinaus wird für beide Container-Typen ein X-Server benötigt, um grafische Benutzeroberflächen (GUIs) von Anwendungen, die im Container laufen, auf der Host-Maschine anzuzeigen. Dies wird besonders gegen Ende des Kurses relevant.


### X-Server

#### für Windows:

Wir nutzen hierzu "Xming". Xming ist ein Open-Source X-Server für Windows, der es ermöglicht, grafische Anwendungen von Unix- oder Linux-Systemen auf einem Windows-Rechner auszuführen. Es handelt sich um ein sehr kleines Programm, das weder Speicher- noch Rechenkapazität benötigt. [Download Xming](https://sourceforge.net/projects/xming/).

###### Xming automatisch beim Systemstart ausführen:
Nach dem Herunterladen und Installieren mit dem Installations-assistenten und den Standardeinstellungen wollen wir Xming beim Hochfahren mit starten:

1. Suchen Sie den Pfad zum Xming-Shortcut (nicht den direkten Pfad, sonst begrüßt Sie jedes Mal ein Pop-up, wenn Sie Ihren PC starten). Drücken Sie die Windows-Taste, suchen Sie Xming, und öffnen Sie den Dateispeicherort.
3. Es sollte sich ein Explorer-Fenster mit mehreren Xming-Variationen öffnen. Suchen Sie den "reinen" Xming-Shortcut mit dem simplen Namen "Xming", rechts-klicken Sie darauf und kopieren den Pfad (standardmäßig sollte dieser unter "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Xming\Xming.lnk" sein) in die Zwischenablage.
4. Drücken Sie "WinKey + R" und geben Sie in das Fenster `shell:startup` ein, gefolgt von Enter.
5. Es sollte sich ein Explorer-Fenster öffnen. Rechtsklicken Sie dort, wählen Sie "Neuer Shortcut" und geben Sie den gerade kopierten Pfad ein (Achtung: Es dürfen am Anfang und Ende keine Anführungszeichen stehen), dann drücken Sie Enter.
([Quelle](https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd))

Um zu überprüfen ob Xming im hintergrund läuft kannst du unten rechts unter "hidden Icons" schauen ob sich auch ein Xming symbol dort befindet.

#### für Mac

##### 1. Installation von XQuartz

1. **Download**: Besuche die offizielle XQuartz-Webseite unter [https://www.xquartz.org/releases/XQuartz-2.8.5.html](https://www.xquartz.org/releases/XQuartz-2.8.5.html).
2. **Download starten**: Klicke auf den Link, um die neueste Version von XQuartz herunterzuladen.
3. **Installation**:
   - Öffne die heruntergeladene `.dmg`-Datei.
   - Folge den Anweisungen im Installationsprogramm. Klicke auf „Weiter“ und akzeptiere die Lizenzvereinbarung.
   - Nach Abschluss der Installation wirst du möglicherweise aufgefordert, dich abzumelden und wieder anzumelden, um die Installation abzuschließen.

##### 2. XQuartz automatisch beim Systemstart ausführen

Damit XQuartz bei jedem Systemstart automatisch ausgeführt wird, kannst du es als Anmeldeobjekt hinzufügen:

1. **Systemeinstellungen öffnen**: Gehe zu den „Systemeinstellungen“ auf deinem Mac.
2. **Benutzer & Gruppen**: Wähle „Benutzer & Gruppen“ aus.
3. **Anmeldeobjekte**:
   - Wähle dein Benutzerkonto aus der Liste links.
   - Klicke auf den Reiter „Anmeldeobjekte“.
   - Klicke auf das Pluszeichen `+` unter der Liste der Anmeldeobjekte.
   - Navigiere zu `Programme` und wähle „XQuartz“ aus der Liste der Programme aus.
   - Klicke auf „Hinzufügen“, um XQuartz zur Liste der Anmeldeobjekte hinzuzufügen.

Nun wird XQuartz bei jedem Start deines Macs automatisch ausgeführt.

##### 3. XQuartz manuell starten

Falls du XQuartz manuell starten möchtest:
- Gehe zu „Programme“ > „Dienstprogramme“ und öffne XQuartz.

Das war’s! Jetzt wird XQuartz bei jedem Start deines Macs automatisch ausgeführt und ist bereit für die Nutzung.

#### für Linux

X11 läuft nativ... [Stonks](https://surrealmemes.fandom.com/wiki/Stonks?file=2f0.png)

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

[Kurzinfo zum BSYS Pocketlab Dockerimage](https://github.com/htwg-syslab/container/tree/main/BsysV2/DockerExpertx.md)