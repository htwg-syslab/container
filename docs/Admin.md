

## Docker-Images auf einem Mac M1 hochladen

### Voraussetzungen

- Mac mit M1-Chip
- Docker installiert
- Zugriff auf ein Docker-Registry (z.B. Docker Hub, AWS ECR, etc.)

### 1. Docker-Image erstellen

Zunächst musst du ein Docker-Image bauen. Navigiere dazu in das Verzeichnis, in dem sich dein `Dockerfile` befindet, und führe folgenden Befehl aus:

```bash
docker build -t <dein-image-name> .
```
#### Beispiel:
```bash
docker build -t bsysbase .
```

- `<dein-image-name>`: Ersetze dies durch den gewünschten Namen für dein Image.

### 2. Docker-Image taggen

Um das Image hochzuladen, musst du es mit dem Ziel-Repository taggen. Das geht mit folgendem Befehl:

```bash
docker tag <dein-image-name> <dein-repository>/<dein-image-name>:<tag>
```

- `<dein-repository>`: Der Name deines Repositories (z.B. `docker.io/username` für Docker Hub).
- `<tag>`: Optional, z.B. `latest` oder eine Versionsnummer.

#### Beispiel:

```bash
docker tag bsysbase syslab/bsys:base
```


### 3. Bei der Docker-Registry anmelden

Melde dich bei der Registry an, in die du das Image hochladen möchtest. Für Docker Hub geht das mit:

```bash
docker login
```

- Gib deine Docker Hub Zugangsdaten ein, wenn du dazu aufgefordert wirst.

### 4. Docker-Image hochladen

Lade das getaggte Image mit folgendem Befehl hoch:

```bash
docker push <dein-repository>/<dein-image-name>:<tag>
```

#### Beispiel:

```bash
docker push syslab/bsys:base
```

### 5. Überprüfung

Stelle sicher, dass das Image erfolgreich hochgeladen wurde, indem du dein Repository in der Registry besuchst oder mit folgendem Befehl die hochgeladenen Images auflistest:

```bash
docker image ls
```
## Xauthority

Die Warnung `/usr/bin/xauth: file /home/pocketlab/.Xauthority does not exist` beim Einloggen via SSH kann wie folgt behoben werden:

Nach dem Einloggen via SSH erstellen Sie die `.Xauthority`-Datei manuell, indem Sie den folgenden Befehl im pocketlab Container ausführen:

```bash
touch ~/.Xauthority
```

Nachdem die Datei erstellt wurde, verwenden Sie `xauth`, um die notwendigen Autorisierungsdaten zu generieren:

```bash
xauth generate $DISPLAY . trusted
xauth list
```

Diese Befehle sollten die `.Xauthority`-Datei mit den erforderlichen Daten füllen und das Problem beheben.

## docker-compose für gitbook

Quelle: https://github.com/HeRoMo/gitbook-template/tree/master

### Run local server

Run the following command, to start gitbook server.

```bash
$ docker-compose up
```

Open http://localhost:4000, after docker containers are started.
