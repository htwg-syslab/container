## OSTEP Homeworks

Das OSTEP Homework Repository wurde bereits in Ihrem Container installiert und befindet sich im Home-Verzeichnis unter dem Pfad `ostep-homework`. Dieses Verzeichnis enthält sämtliche Aufgaben und Materialien der Homeworks wie sie vom OSTEP-Autor zur Verfügung gestellt werden.

Das Verzeichnis ist als **Lese-Spiegel** eingerichtet: Sie können die Simulationen darin ausführen und neue eigene Dateien anlegen, aber nichts in das Repository des OSTEP-Autors zurückschreiben (`git push` ist gesperrt).

Um das OSTEP Homework Repository auf dem neuesten Stand zu halten, können Sie regelmäßig die neueste Version des Repositories von GitHub abrufen. Gehen Sie dazu wie folgt vor:

1. **Navigieren Sie in das Repository-Verzeichnis**: Öffnen Sie ein Terminal in Ihrem Container und wechseln Sie in das Verzeichnis, in dem das Repository gespeichert ist:

    ```bash
    cd ~/ostep-homework
    ```

2. **Aktualisieren Sie das Repository**: Führen Sie den folgenden Befehl aus, um die neueste Version vom Remote-Repository abzurufen:

    ```bash
    git update
    ```

    `git update` ist ein Alias, der nur in `~/ostep-homework` verfügbar ist. Er holt den aktuellen Stand des `master`-Branches und setzt Ihr lokales Verzeichnis exakt auf diesen Stand.

    > **Achtung:** Änderungen an Dateien, die zum Repository gehören (z. B. ein editiertes Skript oder README, geänderte Dateirechte), gehen dabei **verloren**. Neu angelegte eigene Dateien bleiben erhalten. Eigenen Code und eigene Notizen legen Sie am besten in Ihrem eigenen Repository ab, nicht in `~/ostep-homework`.

3. **Überprüfen Sie die Aktualisierungen**: Nachdem der `git update`-Befehl ausgeführt wurde, werden alle neuen Dateien oder Änderungen in Ihrem lokalen Verzeichnis verfügbar sein.

Indem Sie regelmäßig `git update` ausführen, stellen Sie sicher, dass Sie immer mit den neuesten Aufgaben und Aktualisierungen des OSTEP Homework Repositorys arbeiten.
