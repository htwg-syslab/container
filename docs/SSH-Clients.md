## SSH Client in Windows 11

Linux und macOS bringen standardmäßig einen SSH-Client mit. Unter Windows 11 müssen Sie einen SSH-Client aktivieren oder installieren.

### Empfehlung: Git Bash

Git Bash wird mit [Git](https://git-scm.com/) mitgeliefert und enthält einen vollständigen SSH-Client. Git werden Sie im Studium ohnehin benötigen, und mit Git Bash können Sie Linux-Befehle wie `chmod` direkt unter Windows ausführen – das wird später für die SSH-Key-Konfiguration gebraucht.

→ Download: [https://git-scm.com/](https://git-scm.com/)

### Alternativen

- **OpenSSH** (in Windows 11 integriert): Aktivierung über **Einstellungen** > **Apps** > **Optionale Features** oder per PowerShell:

  ```powershell
  Add-WindowsCapability -Online -Name OpenSSH.Client*
  ```

- **PuTTY**: SSH-Client mit grafischer Oberfläche. Download: [putty.org](https://www.putty.org/)

- **MobaXterm**: Umfassendes Tool mit SSH, X-Server und Dateiübertragung. Download: [mobaxterm.mobatek.net](https://mobaxterm.mobatek.net/)
