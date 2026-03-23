## AIN BSYS — bsyslab Container

### Vorwort

Es wird empfohlen, die Vorbereitung auf dem System durchzuführen, das Sie während der Laborstunden verwenden werden.

**WICHTIG: Bitte führen Sie die Vorbereitung unbedingt VOR dem ersten Labortermin durch**, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und einige große Dateien heruntergeladen werden müssen.

In der ersten Laborstunde behandeln wir Login, SSH-Konfiguration und die Einrichtung von VS Code. Diese Schritte können Sie auch vorab eigenständig durchführen.

#### Installation des bsyslab Containers

Der BSYS-Container (`bsyslab`) ist vorkonfiguriert und kann gestartet werden, sobald Docker Desktop läuft. Die Entwicklung erfolgt über das Terminal oder Visual Studio Code. Es gibt auch eine [UI-Variante](BSYS-UI-Variante.md) mit grafischer Oberfläche, die für das Praktikum jedoch nicht empfohlen wird.

#### Container starten

```bash
docker run -d -p 127.0.0.1:40405:22 --name=bsyslab ghcr.io/htwg-syslab/container/bsyslab:latest
```

Das Image ist Multi-Arch — Docker wählt automatisch die passende Variante (amd64 oder arm64) für Ihre CPU.

**Optional: Persistentes Home-Verzeichnis**

Standardmäßig gehen alle Dateien verloren, wenn der Container entfernt wird. Mit einem Volume bleibt das Home-Verzeichnis auch nach `docker rm` erhalten:

```bash
docker run -d -p 127.0.0.1:40405:22 -v bsyslab-home:/home/pocketlab --name=bsyslab ghcr.io/htwg-syslab/container/bsyslab:latest
```

#### Nach dem Start

Beim ersten Start wird das Image von Docker Hub heruntergeladen. Dieser Vorgang kann je nach Internetverbindung einige Minuten dauern – bitte vorab zu Hause durchführen.

Nach dem Download sehen Sie den laufenden Container unter „Containers" und das Image unter „Images" in Docker Desktop.

Der Parameter `-p 127.0.0.1:40405:22` leitet den SSH-Port (22) des Containers auf den lokalen Port 40405 um. Die SSH-Konfiguration wird im Kapitel [Pocketlab Einrichtung](Pocketlab-Setup.md) erläutert.

Gegen Ende des Kurses wird ein X-Server benötigt, um grafische Anwendungen aus dem Container auf Ihrem Rechner anzuzeigen.

#### Nächste Schritte

Fahren Sie mit der [Pocketlab Einrichtung](Pocketlab-Setup.md) fort (Anmeldung, SSH-Konfiguration, VSCode).

### Wichtiger Hinweis

Alle Einstellungen und Dateien im Container werden gelöscht, wenn dieser entfernt wird. Starten Sie den Container erneut, um Ihre Arbeit fortzusetzen, ohne ihn neu erstellen zu müssen.
