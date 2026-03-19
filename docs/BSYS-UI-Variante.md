## Optional: UI-Variante (pocketlabui)

> **Empfehlung:** Arbeiten Sie im Praktikum mit `pocketlabbase` (Terminal), nicht mit der UI-Variante.

In der professionellen Softwareentwicklung wird mit Remote-Systemen fast ausschließlich über die Kommandozeile gearbeitet – ob per SSH auf Cloud-Servern, in Docker-Containern oder bei der Verwaltung von Kubernetes-Clustern. Diese Systeme haben in der Regel keine grafische Oberfläche. Werkzeuge wie `git`, `docker`, `kubectl` und Build-Systeme sind CLI-first konzipiert und lassen sich so in automatisierte Workflows (CI/CD-Pipelines, Skripte) einbinden. Der sichere Umgang mit Terminal und Shell ist daher eine Kernkompetenz, die Sie im Praktikum gezielt trainieren sollten.

Das Image `pocketlabui` erweitert `pocketlabbase` um eine grafische Benutzeroberfläche (Xfce-Desktop), die über den Browser zugänglich ist. Es ist nur für Benutzer gedacht, die noch keine Erfahrung mit der Kommandozeile haben und einen sanfteren Einstieg benötigen.

### Container starten

#### X86 Architektur (Intel/AMD)

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui
```

#### ARM Maschinen (Apple Mac mit M1/M2/M3/...)

> **Hinweis:** Das UI-Image für ARM64 ist derzeit nicht zuverlässig verfügbar. Nutzen Sie auf ARM-Macs bevorzugt `pocketlabbase-ARM64`.

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 --name=pocketlab systemlabor/bsys:pocketlabui-ARM64
```

### GUI-Zugriff über den Browser

Öffnen Sie `localhost:40001` im Browser, um die grafische Oberfläche des Containers zu nutzen. Die Bedienung erfolgt mit Maus und Tastatur wie auf einem normalen Desktop.

### Ports

| Port | Protokoll | Beschreibung |
|------|-----------|--------------|
| 22 (→ 40405) | SSH | Terminal-Zugriff (wie bei pocketlabbase) |
| 40001 | noVNC | GUI-Zugriff über den Browser |
| 5901 | VNC | Direkter VNC-Zugriff (z.B. mit TurboVNC) |
