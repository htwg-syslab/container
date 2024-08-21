### Xauthority

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