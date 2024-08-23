## Dateiaustausch zwischen Docker-Container und Host

Beim Arbeiten mit Docker-Containern kann es häufig notwendig sein, Dateien zwischen dem Container und dem Host-System auszutauschen. Es gibt mehrere Möglichkeiten, dies zu erreichen, wobei zwei der gebräuchlichsten Methoden die Verwendung von `scp` und die Nutzung eines Git-Repositories sind.

### 1. Dateiaustausch mit `scp`

Wenn dein Docker-Container über SSH erreichbar ist, kannst du das `scp`-Kommando verwenden, um Dateien sicher zwischen deinem Host und dem Container zu übertragen.

**Beispiel: Eine Datei vom Host in den Container kopieren**

```bash
scp /path/to/local/file pocketlab:/path/in/container/
```

In diesem Beispiel kopierst du eine lokale Datei (`/path/to/local/file`) in das Verzeichnis `/path/in/container/` des Containers. Der Parameter `-P 2222` gibt den Port an, auf dem der SSH-Dienst im Container läuft.

**Beispiel: Eine Datei vom Container auf den Host kopieren**

```bash
scp pocketlab:/path/in/container/file /path/to/local/
```

Hier kopierst du eine Datei aus dem Container (`/path/in/container/file`) auf deinen lokalen Rechner (`/path/to/local/`).

### 2. Dateiaustausch über ein Git-Repository

Eine weitere Methode, um Dateien zwischen dem Host und dem Container zu synchronisieren, ist die Verwendung eines Git-Repositories. Diese Methode ist besonders nützlich, wenn du regelmäßig Dateien austauschen musst oder Versionskontrolle benötigst.

**Beispiel: Klonen eines Repositories im Container**

```bash
git clone https://github.com/username/repository.git /path/in/container/
```

Mit diesem Befehl klonst du ein Git-Repository in ein Verzeichnis innerhalb des Containers. Änderungen am Code können dann direkt im Container vorgenommen werden.

**Beispiel: Änderungen vom Container pushen**

```bash
cd /path/in/container/repository
git add .
git commit -m "Changes made in container"
git push origin main
```

Nach dem Bearbeiten der Dateien im Container kannst du die Änderungen zurück in das Remote-Repository pushen. Dadurch bleiben deine Änderungen gesichert und können bei Bedarf auch auf dem Host wieder abgerufen werden.

**Beispiel: Änderungen vom Host auf den Container holen**

```bash
git pull origin main
```

Wenn du auf dem Host Änderungen vorgenommen hast, kannst du diese einfach in den Container ziehen, indem du das Repository im Container aktualisierst.

### Fazit

Die Verwendung von `scp` ist ideal für den direkten und schnellen Austausch einzelner Dateien zwischen dem Host und dem Container, besonders wenn keine komplexe Versionskontrolle erforderlich ist. Ein Git-Repository hingegen bietet eine robuste Lösung für die Synchronisation und Verwaltung von Dateien, insbesondere bei der Zusammenarbeit in Teams oder bei der Arbeit an umfangreicheren Projekten. Beide Methoden ermöglichen einen nahtlosen Workflow zwischen deinem Host und den isolierten Umgebungen im Docker-Container.
