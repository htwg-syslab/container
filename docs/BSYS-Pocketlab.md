## BSYS Pocketlab

### Vorwort

Es wird empfohlen, die Vorbereitung auf dem mobilen System durchzuführen, das Sie während der Laborstunden verwenden werden. Selbstverständlich besteht auch die Möglichkeit, die erforderliche Software zusätzlich auf Ihrem Desktop-System für zu Hause zu installieren, um Flexibilität und eine nahtlose Arbeitsumgebung zu gewährleisten.

### Vorbereitung

**WICHTIG: Bitte führen Sie die "Vorbereitung des BSYS Pocketlab" unbedingt VOR dem ersten Labortermin durch**, da die WLAN-Durchsatzrate an der HTWG begrenzt ist und zum Einrichten einige große Dateien benötigt werden. 

In der ersten Laborstunde werden wir uns mit den Themen:

- Login,
- SSH-Konfiguration und
- der Einrichtung von VS Code
  
beschäftigen. Diese Schritte können Sie selbstverständlich auch bereits im Vorfeld eigenständig durchführen, um optimal vorbereitet zu sein.

#### Vorbereitung des BSYS Pocketlab

Der BSYS-Container ist bereits vorkonfiguriert und kann gestartet werden, sobald Docker Desktop ausgeführt wird. Es stehen zwei Varianten des Docker-Containers zur Verfügung:

- **pocketlabbase**: Ein schlankes Docker-Image, das Ihnen den Zugriff auf das laufende Linux-System über ein Terminal ermöglicht. Die gesamte Simulation sowie die Code-Entwicklung können ebenfalls über Visual Studio Code (VSCode) durchgeführt werden. Detaillierte Informationen hierzu finden Sie weiter unten.

- **pocketlabui**: Dieses Image erweitert die Basisversion um eine grafische Benutzeroberfläche (GUI), die Ihnen die Bedienung des Linux-Systems über Ihren Browser ermöglicht.

Die Verwendung des GUI-Images ist optional und richtet sich vor allem an Benutzer, die weniger Erfahrung mit Linux haben. Für die Aufgaben im BSYS-Kurs ist die Arbeit im Terminal mit `pocketlabbase` ausreichend.

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

Beim erstmaligen Start des Images wird es noch nicht lokal auf Ihrem System vorhanden sein und muss daher von Docker Hub heruntergeladen werden. Dieser Vorgang kann abhängig von Ihrer Internetverbindung einige Minuten in Anspruch nehmen. Da hierbei eine beträchtliche Menge an Daten übertragen wird, wird dringend empfohlen, den Download vorab zu Hause durchzuführen. Die WLAN-Verbindung an der HTWG bietet nur eine begrenzte Datenrate, was den Download erheblich verlangsamen könnte.

Nach Abschluss des Downloads sehen Sie den laufenden Pocketlab-Laborcontainer unter „Containers“ sowie das heruntergeladene `systemlabor/pocketlab` Image unter „Images“ in Docker Desktop.

Der Parameter `-p 127.0.0.1:40405:22` bei der Ausführung des Containers leitet den Port 22 (SSH) des Containers auf den lokalen Port 40405 Ihres Systems um. Wenn Sie sich per SSH mit dem Container verbinden möchten, nutzen Sie einen SSH-Client und stellen die Verbindung über den lokalen Port 40405 her. Detaillierte Anweisungen zur Konfiguration der SSH-Verbindung finden Sie in einem späteren Abschnitt dieses Dokuments. Dort wird der gesamte Prozess Schritt für Schritt erläutert, um sicherzustellen, dass die Verbindung korrekt und sicher eingerichtet wird.
g
Darüber hinaus wird für beide Container-Typen ein X-Server benötigt, um grafische Benutzeroberflächen (GUIs) von Anwendungen, die im Container laufen, auf der Host-Maschine anzuzeigen. Dies wird besonders gegen Ende des Kurses relevant.

### Wichtiger Hinweis

Beachten Sie, dass alle Einstellungen und Dateien im Container gelöscht werden, wenn dieser entfernt wird. Starten Sie den Container erneut, um Ihre Arbeit fortzusetzen, ohne ihn neu erstellen zu müssen.
