## Optional: UI-Variante (bsys-ui)

> **Empfehlung:** Arbeiten Sie im Praktikum mit `bsyslab` (Terminal), nicht mit der UI-Variante.

In der professionellen Softwareentwicklung wird mit Remote-Systemen fast ausschließlich über die Kommandozeile gearbeitet – ob per SSH auf Cloud-Servern, in Docker-Containern oder bei der Verwaltung von Kubernetes-Clustern. Diese Systeme haben in der Regel keine grafische Oberfläche. Werkzeuge wie `git`, `docker`, `kubectl` und Build-Systeme sind CLI-first konzipiert und lassen sich so in automatisierte Workflows (CI/CD-Pipelines, Skripte) einbinden. Der sichere Umgang mit Terminal und Shell ist daher eine Kernkompetenz, die Sie im Praktikum gezielt trainieren sollten.

Das Image `bsys-ui` erweitert `bsyslab` um eine grafische Benutzeroberfläche (Xfce-Desktop), die über den Browser zugänglich ist. Es ist nur für Benutzer gedacht, die noch keine Erfahrung mit der Kommandozeile haben und einen sanfteren Einstieg benötigen.

### Container starten

```bash
docker run -d -p 127.0.0.1:40405:22 -p 127.0.0.1:40001:40001 -p 127.0.0.1:5901:5901 --name=bsyslab ghcr.io/htwg-syslab/container/bsys-ui:latest
```

> **Hinweis:** Das UI-Image ist Multi-Arch, jedoch für ARM64 derzeit nicht zuverlässig verfügbar. Nutzen Sie auf ARM-Macs bevorzugt `bsyslab`.

### GUI-Zugriff über den Browser

Öffnen Sie `localhost:40001` im Browser, um die grafische Oberfläche des Containers zu nutzen. Die Bedienung erfolgt mit Maus und Tastatur wie auf einem normalen Desktop.

### Ports

| Port | Protokoll | Beschreibung |
|------|-----------|--------------|
| 22 (→ 40405) | SSH | Terminal-Zugriff (wie bei bsyslab) |
| 40001 | noVNC | GUI-Zugriff über den Browser |
| 5901 | VNC | Direkter VNC-Zugriff (z.B. mit TurboVNC) |
