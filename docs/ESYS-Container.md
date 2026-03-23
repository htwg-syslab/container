## AIN ESYS — esyslab Container

### Vorwort

Es wird empfohlen, die Vorbereitung auf dem System durchzuführen, das Sie während der Laborstunden verwenden werden.

**WICHTIG: Bitte führen Sie die Vorbereitung unbedingt VOR dem ersten Labortermin durch**, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und einige große Dateien heruntergeladen werden müssen.

#### Installation des esyslab Containers

Der ESYS-Container (`esyslab`) ist vorkonfiguriert und kann gestartet werden, sobald Docker Desktop läuft. Die Entwicklung erfolgt über das Terminal oder Visual Studio Code.

Im Unterschied zum BSYS-Container wird ein **Docker Volume** verwendet, sodass Ihre Daten im Home-Verzeichnis auch dann erhalten bleiben, wenn der Container entfernt und neu erstellt wird.

#### Container starten

```bash
docker run -d -p 127.0.0.1:40407:22 -v esyslab-home:/home/pocketlab --name=esyslab ghcr.io/htwg-syslab/container/esyslab:latest
```

Das Image ist Multi-Arch — Docker wählt automatisch die passende Variante (amd64 oder arm64) für Ihre CPU.

#### Nach dem Start

Beim ersten Start wird das Image von Docker Hub heruntergeladen. Dieser Vorgang kann je nach Internetverbindung einige Minuten dauern – bitte vorab zu Hause durchführen.

Nach dem Download sehen Sie den laufenden Container unter „Containers" und das Image unter „Images" in Docker Desktop.

Der Parameter `-p 127.0.0.1:40407:22` leitet den SSH-Port (22) des Containers auf den lokalen Port 40407 um. Die SSH-Konfiguration wird im Kapitel [Pocketlab Einrichtung](Pocketlab-Setup.md) erläutert.

Der Parameter `-v esyslab-home:/home/pocketlab` erstellt ein benanntes Docker Volume. Ihre Dateien im Home-Verzeichnis bleiben dadurch erhalten, auch wenn Sie den Container löschen und neu erstellen.

#### Nächste Schritte

Fahren Sie mit der [Pocketlab Einrichtung](Pocketlab-Setup.md) fort (Anmeldung, SSH-Konfiguration, VSCode).
