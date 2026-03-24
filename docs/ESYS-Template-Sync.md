## Fork mit Template synchronisieren

Wenn Sie sich über GitHub Classroom für das ESYS-Labor anmelden, wird automatisch ein Repository für Ihre Gruppe erstellt. Dieses Repository basiert auf einem **Template-Repository**, das die Aufgabenstellungen, CI-Tests und Grundstruktur enthält.

Falls das Template im Laufe des Semesters aktualisiert wird (z.B. Korrekturen, neue Aufgaben), müssen Sie diese Änderungen in Ihr Repository übernehmen. Das geht mit wenigen Git-Befehlen.

### Übersicht

```
Template-Repository (Dozent)
        │
        │  GitHub Classroom erstellt Kopie
        ▼
Ihr Gruppen-Repository (Fork)
        │
        │  Sie arbeiten hier
        ▼
Ihre lokale Kopie (git clone)
```

### 1. Template als Remote hinzufügen (einmalig)

Prüfen Sie zuerst, welche Remotes konfiguriert sind:

```bash
git remote -v
```

Sie sehen vermutlich nur `origin` — das ist Ihr Gruppen-Repository. Fügen Sie nun das Template als zusätzliches Remote hinzu:

```bash
git remote add template <TEMPLATE-URL>
```

Die Template-URL erhalten Sie vom Dozenten. Sie hat typischerweise die Form:

```
git@github.com:htwg-syslab-esys/<semester>-classroom-template.git
```

Prüfen Sie mit `git remote -v`, ob beide Remotes vorhanden sind:

```
origin    git@github.com:htwg-syslab-esys/...-<ihr-gruppenname>.git (fetch)
origin    git@github.com:htwg-syslab-esys/...-<ihr-gruppenname>.git (push)
template  git@github.com:htwg-syslab-esys/...-classroom-template.git (fetch)
template  git@github.com:htwg-syslab-esys/...-classroom-template.git (push)
```

### 2. Template-Änderungen holen

```bash
git fetch template
```

Dieser Befehl lädt die neuesten Änderungen des Templates herunter, ohne Ihr lokales Repository zu verändern.

### 3. Änderungen in Ihren Branch mergen

Stellen Sie sicher, dass Sie auf Ihrem Arbeitsbranch sind (üblicherweise `main`):

```bash
git checkout main
git merge template/main
```

### 4. Merge-Konflikte lösen

Wenn Sie und das Template dieselbe Datei geändert haben, entsteht ein **Merge-Konflikt**. Git markiert die betroffenen Stellen in der Datei:

```
<<<<<<< HEAD
Ihre Änderung
=======
Änderung aus dem Template
>>>>>>> template/main
```

So lösen Sie den Konflikt:

1. Öffnen Sie die betroffene Datei (z.B. in VSCode — dort gibt es eine grafische Hilfe)
2. Entscheiden Sie, welche Version korrekt ist, oder kombinieren Sie beide
3. Entfernen Sie die Konfliktmarker (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Speichern Sie die Datei

Danach den Merge abschließen:

```bash
git add <konflikt-datei>
git commit
```

**Tipp:** Falls Sie unsicher sind, können Sie den Merge jederzeit abbrechen:

```bash
git merge --abort
```

### 5. Änderungen pushen

```bash
git push origin main
```

### Zusammenfassung

| Schritt | Befehl | Wann |
|---|---|---|
| Template hinzufügen | `git remote add template <URL>` | Einmalig |
| Änderungen holen | `git fetch template` | Bei Aktualisierung |
| Mergen | `git merge template/main` | Bei Aktualisierung |
| Pushen | `git push origin main` | Nach dem Merge |
