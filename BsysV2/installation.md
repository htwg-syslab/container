## BSYS Pocketlab

 
### Ziel
Mit dem BSYS Pocketlab sollen Sie in die Lage versetzt werden, auf dem Betriebssystem Ihrer Wahl alle AIN BSYS Laboraufgaben in einem Linux Container bearbeiten zu können. Dazu benutzen wir Docker. 
Docker ist eine freie Software zur Isolierung von Anwendungen mit Hilfe von Containervirtualisierung. Es vereinfacht die Bereitstellung von Anwendungen, weil sich Container, die alle nötigen Pakete enthalten, leicht als Dateien transportieren und installieren lassen. Ein Container ist eine leichtgewichtige, virtualisierte Umgebung, die den Anwendungsquellcode mit den Betriebssystembibliotheken und den Abhängigkeiten kombiniert, die zur Ausführung des Codes benötigt werden. 
Docker ist in der Lage, Code, Laufzeitmodul, Systemwerkzeuge und Systembibliotheken - alles was auf einem Rechner installiert werden kann - in einem Container zu isolieren. Das macht es einfach, Anwendungen in einer Sandbox zu entwickeln und auszuführen. Docker Hub ist ein öffentliches Repository für Docker-Images.
Wir benutzen Docker um in einem entsprechend vorbereiteten Linux Container alles BSYS Homeworks bearbeiten und ausführen zu können. Ein fertiges Image steht dazu bereits auf Docker-Hub bereit.
 
Die zwei Abschnitte "Vorbereitung... " sollten Sie unbedingt VOR dem Start des 1. Labortermins durchführen, da die WLAN Durchsatzrate an der HTWG begrenzt ist und wir zum Einrichten einige grosse Dateien benötigen. 
 
### Vorbereitung Docker Desktop
 
Im Folgenden werden die nötigen Schritte für "Docker Newbies" erklärt. Die Docker Profis unter Ihnen finden weiter unten unter dem Punkt Quellen eine Kurzinfo mit allen nötigen Informationen.
    
1. Gehen Sie auf die Docker Home Page (https://www.docker.com/) und laden Sie dort die für Ihre Betriebssystem (Windows / Mac / Linux) nötige Version. Achten Sie beim Mac auf die richtige Binary Version, je nachdem ob Sie einen Intel oder Mac Chip haben.
2. Starten Sie den Docker Desktop. Unter Windows müssen Sie unter Umständen einen aktuellen wsl Windows Kernel installieren. Docker informiert Sie darüber in einem Popup Fenster. Gehen Sie auf die Containers Seite (Icon oben links) und schauen Sie sich beiden Walkthroughs „What is a Container“ und "How do I run a Container" an. Damit bekommen Sie einen ersten Eindruck was Docker Ihnen an Funktionalität bieten kann.
 
### Vorbereitung BSYS Pocketlab
Für BSYS ist der Container bereits erstellt und dieser kann nun - wenn Docker Desktop läuft - gestartet werden.
Es werden 2 Typen von Docker Containern angeboten. Einmal mit und einmal ohne graphische oberfläche. Die grafische Oberfläche ist nicht zwinend notwendig aber erleichertert ggf. die nutzung für Linux-neulinge.
Für alle Aufgaben im Bsys Kurs reicht das Terminal mit editoren (e.g. VsCode, Vim, ...) völlig aus.
Zu beachten: Der Container mit der graphischen Oberfläche benötig mit ca. 2,5 GB etwas mehr Speicherplatz als der Container ohne GUI.

Standard:

`docker run -d -p 127.0.0.1:40405:22 --name=pocketlab tanguylemo/pocketlab:base`

mit grafischen Oberfläche:

`docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab tanguylemo/pocketlab:ui`

Mit dem Befehl wird versucht einen Container aus dem Image `pocketlab:base` zu starten. Beim ersten Aufruf haben Sie dieses Image noch nicht lokal und daher wird nun das Image von Docker Hub heruntergeladen. Das dauert je nach Ihrer Internetverbindung einige Minuten. Und da hier eine Menge Daten herunter geladen werden sollten Sie dies auch unbedingt zu Hause vorbereiten und nicht an der HTWG. Die WLAN Verbindung an der HTWG erlaubt nur eine geringe Datenrate wodurch der Download sehr lange dauern würde.
 
Nach dem Download sehen Sie den laufenden pocketlab Labor Container unter ‚Containers‘ und unter Image das heruntergeladene `systemlabor/pocketlab` Image.
 
Der `-p 127.0.0.1:40405:22` Aufruf biegt den Port 22 (ssh) von dem Container um auf den lokalen Port 40405 Ihres Systems. Wenn Sie sich nun also via ssh auf den Container einloggen wollen, so benutzen Sie dafür ein ssh Client mit welchem Sie sich auf Ihren lokalen Port 40405 verbinden.
 

Desweiteren wird für beide Container-Typen ein X-server gebraucht mit welchen man GUI-Applikationen die auf dem Container laufen auf der Host-Machine angezeigt werden(wichtig gegen ende des Kurses). 



##### Anleitung für Windows:

Wir nutzen hierzu "Xming". Xming ist ein Open-Source X-Server für Windows, der es ermöglicht, grafische Anwendungen von Unix- oder Linux-Systemen auf einem Windows-Rechner auszuführen. Es handelt sich um ein sehr kleines Programm, welches weder Speicher- noch Rechenkapazität benötigt.
(download: https://sourceforge.net/projects/xming/ (ggf. beschwert sich der Browser. Dies kann man ruhig ignorieren)).:

Nach dem herunterladen und installieren mit Installationswizard und standardeinstellungen wollen wir Xming beim Hochfahren mit starten:
1. Hierfür suchen wir uns den Pfad in welchen wir Xming istalliert haben (standard: "C:\Program Files (x86)\Xming\Xming.exe" ) und kopieren diesen.
2. Tippen "WinKey + R" und in das Fenster: `shell:startup` und folglich enter
3. Es sollte sich ein Explorer-Fenster geöffnet haben. Rechtsklick -> new Shortcut -> den von gerade eben kopierten Pfad (achtung es dürfen am Anfang und Ende keine Anführungszeichen befinden) -> Enter.
([Quelle](https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd))
 

Nun fehlt nur noch das erstellen der Verbindung und das Passwort.... Und das bekommen Sie auch nicht, denn es ist keines eingerichtet .... somit machen wir das auf eine bessere und professionellere Weise:
    
Wenn der Container neu angelegt wird (also jedes mal wenn Sie den Container löschen und neu anlegen) durchläuft der Container ein internes Skript welches einen neuen 'random' Schlüssel anlegt. Diesen Schlüssel benötigen Sie um sich einloggen zu können. Also Achtung: Wenn Sie den Container löschen und einen neuen Container anlegen bedeutet das, es wird auch ein neuer Schlüssel erzeugt. Aber keine Sorge:

1. Wird das nicht so oft (wenn überhaupt) vorkommen, dass Sie einen Container löschen und neu anlegen müssen. Es langt auch den Container - wenn er angelegt ist - zu stoppen und zu starten.
2. Ist das Auslesen des Schlüssels sehr einfach.
 
Wie kommt man nun an den Schlüssel ran?
 
### BSYS Pocketlab Security
Gehen Sie dazu in Ihrem Docker Desktop auf den laufen Container und schauen Sie dort in die Logs. Ziemlich am Ende des Logs steht der Key zwischen den beiden Zeilen:
    
    -----BEGIN OPENSSH PRIVATE KEY-----  und
    -----END OPENSSH PRIVATE KEY-----
 
Zeigt Docker Ihnen nichts unter dem Log Reiter an,  benutzen Sie einfach die Kommandozeile:
    
    docker logs pocketlab
    
Dieser Schlüssel (Key) wird nun Ihrem lokal installierten ssh Client bekannt gegeben und danach können Sie sich ohne Passwort direkt im Container einloggen. 
 
Für den Kommandozeilen Client 'ssh' befinden sich die Konfigurationsdateien im versteckten Verzeichnis `.ssh/` . Schauen Sie also mal in Ihrem Home Direktory Ihres Rechners nach diesem Verzeichnis. Haben Sie in der Vergangenheit ssh benutzt sollten darin schon Dateien zu finden sein (z.B. die Datei `.ssh/known_hosts`). Gibt es das Verzeichnis noch nicht, versuchen Sie bitte auf den laufenden Container via ssh zuzugreifen:
 
    ssh -p40405 -i -x .ssh/id_rsa_pocketlab.key pocketlab@localhost 
 
Nach dem Akzeptieren der Verbindung das ssh Programm mit CTL-C abbrechen. Nun sollte das `.ssh` Verzeichnis angelegt worden sein.
 
Legen Sie In diesem `.ssh/` Verzeichnis die selbsterstellte Datei `id_rsa_pocketlab.key` an. In diese Datei kopieren Sie den Key, also alle Zeichen zwischen den Zeilen.
 
    -----BEGIN OPENSSH PRIVATE KEY----- und 
    -----END OPENSSH PRIVATE KEY-----

gefolgt von einem enter nach dem letzten - .
 
(Das können Sie mit einem Editor machen oder noch einfacher mit folgendem Kommandozeilen Befehl (Linux, Mac) den Sie in Ihrem Home Direktory aufrufen:
    
    docker logs pocketlab | sed -n '/-----BEGIN OPENSSH PRIVATE KEY-----/,/-----END OPENSSH PRIVATE KEY-----/p' > .ssh/id_rsa_pocketlab.key
 
Dieser Kommandozeile (alles in einer Zeile schrieben und mit Return ausführen!) liest die Log Datei des laufenden pocketlab Containers aus, filtern nur die Zeilen BEGIN, Key und der END Zeile aus und schreibt dann die gefilterte Informationen in die Datei `.ssh/id_rsa_pocketlab.key`. Dazu werden die Befehle (`docker logs ... | sed` ) hintereinander mit einer sogenannten Pipe ( | ) verbunden und ausgeführt und das Ergebnis wird nicht auf die Konsole sondern in eine Datei geschrieben, in dem die Ausgabe umgeleitet wird mit '>'.)
 
Die Datei mit dem Key darf nur für Sie als User lesbar und schreibbar sein. Sind zu viele Lese- oder Schreibrechte auf die Datei möglich, so beschwert sich das ssh Programm entsprechend. 
 
Ist der Key gespeichert können Sie sich nun mit folgendem Befehl aus der Kommandozeile auf dem Container einloggen:
    
    ssh -p40405 -i  .ssh/id_rsa_pocketlab.key pocketlab@localhost
 
Bei Problemen bitte überprüfen, ob wirklich der richtige und vollständige Key in der Datei `.ssh/id_rsa_pocketlab.key` steht, beginnend mit der 
    -----BEGIN OPENSSH PRIVATE KEY----- Zeile und am Ende die 
    -----END OPENSSH PRIVATE KEY----- 
    
    Zeile.
    
Im Container können Sie z.B. nun mit dem Befehl `cat /etc/debian_version` sich die zugrunde liegende Linux Distribution anschauen.
 
Die im Container installierte Python Version kann mit 
    
    python3 --version

Ob der X-server funktioniert haben mit xeyes . Es sollten Squigglie eyes aufploppen die den cursor folgen. 

GUI:
Falls sie nun zugriff auf die GUI erhalten wollten könne sie sich via ihren Browser darauf zugreifen.
Dafür reicht es localhost:40001 oder [127.0.0.1](http://127.0.0.1:40001/) in der url-leiste ihres Browsers einzugeben.

### ssh config Datei
Damit wir nun komfortabel von überall aus unserem System uns schnell in den laufenden Docker Container einloggen können konfigurieren wir noch ssh entsprechend. Konfigurationen Ihres ssh Clients nehmen Sie in der Datei `.ssh/config` vor. Haben Sie diese Datei noch nicht im `.ssh/` Verzeichnis, einfach die folgenden Einträge als `.ssh/config` Datei abspeichern. Ansonsten die Datei entsprechend erweitern:
 
    Host pocketlab
        HostName localhost
        User pocketlab
        Port 40405
        IdentityFile ~/.ssh/id_rsa_pocketlab.key
        ForwardX11 yes

    
Mit `ssh pocketlab` in einem Terminal können Sie sich nun ohne weitere Rückfragen nach Passwort oder ähnlichem direkt in den Container einloggen.
 
### VSCode Anbindung
 
- Installieren Sie vscode
- Installieren Sie die Remote-ssh Extension.
- Unter der Command Palette können Sie nun "Remote ssh: Connect to Host" aufrufen. Ist die `.ssh/config` wie oben angelegt wird der pocketlab host direkt angeboten. Wählen Sie den Host aus. Sie werden nach dem Typ des Hosts gefragt und hier wählen Sie Linux aus.
 
Damit haben Sie nun ein vscode Entwicklungsfenster, welches den Docker Container nutzt, sodass Sie Ihre C Programme im Docker Container erstellen/editieren und ausführen können. Plugins des VSCode können nun auch auf dem Container installiert werden und sind bei einem späteren Reconnect wieder verfügbar.
 
**ACHTUNG**
Wenn Sie Ihr Betriebssystem runter fahren wird der Docker Container gestoppt. Natürlich können Sie jederzeit den Container auch selbst stoppen. Starten Sie dann zu einem späteren Zeitpunkt den Container wieder um weiter arbeiten zu können. 
Wenn Sie den Container löschen und neu anlegen sind ALLE Ihre Einstellungen gelöscht. Sie müssen dann wieder mit der Konfiguration, beginnend mit dem Key (siehe oben) starten und die auf dem Container vorhandene Dateien (wie z.B. die für den Container installierte vscode Plugins) neu installieren/kopieren.
 
### Quellen
 
[Kurzinfo zum BSYS Pocketlab Dockerimage](https://github.com/htwg-syslab/container/blob/main/bsys/README.md)