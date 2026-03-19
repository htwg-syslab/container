## BSYS Pocketlab

### Vorwort

Es wird empfohlen, die Vorbereitung auf dem System durchzuführen, das Sie während der Laborstunden verwenden werden.

**WICHTIG: Bitte führen Sie die Vorbereitung unbedingt VOR dem ersten Labortermin durch**, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und einige große Dateien heruntergeladen werden müssen.

In der ersten Laborstunde behandeln wir Login, SSH-Konfiguration und die Einrichtung von VS Code. Diese Schritte können Sie auch vorab eigenständig durchführen.

#### Installation des BSYS Pocketlab

Der BSYS-Container ist vorkonfiguriert und kann gestartet werden, sobald Docker Desktop läuft.

- **pocketlabbase** (empfohlen): Schlankes Image mit Terminal-Zugriff. Die Entwicklung erfolgt über das Terminal oder Visual Studio Code.
- **pocketlabui** (optional): Erweitert die Basisversion um eine grafische Oberfläche (GUI) im Browser – siehe [UI-Variante](BSYS-UI-Variante.md). Für das Praktikum nicht erforderlich.

#### Architektur

Wählen Sie das Docker-Image passend zu Ihrer CPU-Architektur, damit der Container ohne Emulation läuft.

##### X86 Architektur (Intel/AMD)

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase
```

##### ARM Maschinen (Apple Mac mit M1/M2/M3/...)

```bash
docker run -d -p 127.0.0.1:40405:22 --name=pocketlab systemlabor/bsys:pocketlabbase-ARM64
```

#### Nach dem Start

Beim ersten Start wird das Image von Docker Hub heruntergeladen. Dieser Vorgang kann je nach Internetverbindung einige Minuten dauern – bitte vorab zu Hause durchführen.

Nach dem Download sehen Sie den laufenden Container unter „Containers" und das Image unter „Images" in Docker Desktop.

Der Parameter `-p 127.0.0.1:40405:22` leitet den SSH-Port (22) des Containers auf den lokalen Port 40405 um. Die SSH-Konfiguration wird im nächsten Abschnitt erläutert.

Gegen Ende des Kurses wird ein X-Server benötigt, um grafische Anwendungen aus dem Container auf Ihrem Rechner anzuzeigen.

### Wichtiger Hinweis

Alle Einstellungen und Dateien im Container werden gelöscht, wenn dieser entfernt wird. Starten Sie den Container erneut, um Ihre Arbeit fortzusetzen, ohne ihn neu erstellen zu müssen.
