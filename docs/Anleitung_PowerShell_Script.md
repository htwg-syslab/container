# Anleitung: PowerShell-Script erstellen und ausführen

Folgende Schritte erklären, wie Sie ein PowerShell-Script anlegen und
ausführen.

## 1. Datei erstellen

1.  Öffnen Sie einen Editor (z. B. VS Code).
2.  Erstellen Sie eine neue Datei mit der Endung `.ps1`.\
    Beispielname und -pfad:\
    `C:\Users\<Ihr_User>\get_pocket_lab_key.ps1`

> Ersetzen Sie `<Ihr_User>` durch Ihren tatsächlichen
> Windows-Benutzernamen.

## 2. Code einfügen

Kopieren Sie den Script-Code in die Datei und speichern Sie diese.

## 3. Ausführen (Optionen)

### A --- Aus dem Terminal (empfohlen)

1.  Öffnen Sie PowerShell oder das integrierte Terminal in VS Code.

2.  Wechseln Sie in das Verzeichnis, das die Datei enthält, z. B.:

    ```powershell
    cd C:\Users\<Ihr_User>
    ```

3.  Führen Sie das Script aus mit:

    ```powershell
    ./get_pocket_lab_key.ps1
    ```

    Alternativ:

    ```powershell
    powershell -File .\get_pocket_lab_key.ps1
    ```

### B --- Doppelklick (nicht immer zuverlässig)

Ein Doppelklick auf die `.ps1`-Datei öffnet diese häufig im Editor (z.
B. Notepad oder VS Code). Ob das Script dadurch ausgeführt wird, hängt
von Ihrer Standard-Dateizuordnung und den Systemeinstellungen ab.
Deshalb ist das Starten aus PowerShell zuverlässiger.

## Hinweis zur Ausführungsrichtlinie

Windows-PowerShell kann Scripts blockieren, wenn die
Ausführungsrichtlinie restriktiv ist. Falls Sie beim Ausführen eine
Fehlermeldung zur Ausführungsrichtlinie erhalten, können Sie temporär
für die aktuelle Sitzung die Richtlinie lockern (nur wenn Sie dem Script
vertrauen):

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\get_pocket_lab_key.ps1
```

Diese Änderung gilt nur für die laufende PowerShell-Sitzung.
