## Git-Konfiguration für plattformübergreifenden Dateiaustausch

Um Dateien effizient zwischen Windows und Linux mit Git auszutauschen, ist es wichtig, die richtige Git-Konfiguration zu verwenden. Ein zentrales Thema dabei ist der Umgang mit Zeilenendungen, da Windows und Linux unterschiedliche Standards verwenden (Windows verwendet CRLF, Linux verwendet LF). Um Kompatibilitätsprobleme zu vermeiden, sollte in der Git-Konfiguration der Parameter `core.autocrlf` korrekt gesetzt werden:

- **Auf Windows:** `git config --global core.autocrlf true`
- **Auf Linux:** `git config --global core.autocrlf input`

Diese Einstellungen sorgen dafür, dass Zeilenendungen automatisch konvertiert werden: Dateien werden auf Windows mit CRLF ausgecheckt und bei einem Commit in LF umgewandelt. Auf Linux werden Dateien mit LF eingecheckt und bleiben auch beim Checkout im LF-Format. So wird sichergestellt, dass das Projekt auf beiden Betriebssystemen konsistent bleibt und keine unerwünschten Änderungen durch abweichende Zeilenendungen entstehen.
