## SSH Client in Windows 11

SSH (Secure Shell) ist ein Protokoll für den sicheren Fernzugriff auf Server. Während Linux und macOS standardmäßig einen SSH-Client mitbringen, müssen Sie in Windows 11 diesen entweder aktivieren oder einen separaten Client installieren. Hier sind die wichtigsten Optionen:

1. **OpenSSH (Standard in Windows 11)**:  
   Windows 11 enthält OpenSSH als optionales Feature, das Sie über die **Einstellungen** unter **Apps** > **Optionale Features** aktivieren können. Alternativ können Sie auch die PowerShell verwenden:

   ```powershell
   Add-WindowsCapability -Online -Name OpenSSH.Client*
   ```

   Nach der Installation können Sie den SSH-Client über die Eingabeaufforderung oder PowerShell nutzen.

2. **PuTTY**:  
   PuTTY ist ein weit verbreiteter SSH-Client mit grafischer Benutzeroberfläche. Sie können es von der [offiziellen Webseite](https://www.putty.org/) herunterladen und installieren. PuTTY unterstützt SSH, Telnet und serielle Verbindungen.

3. **MobaXterm**:  
   MobaXterm ist ein umfassendes Tool, das neben SSH auch einen X-Server und Dateiübertragungsfunktionen bietet. Es ist ideal für Nutzer, die zusätzliche Funktionen benötigen. Sie können es von der [offiziellen Webseite](https://mobaxterm.mobatek.net/) herunterladen und installieren.

4. **Git Bash**:  
   Git Bash, das mit Git geliefert wird, enthält ebenfalls einen SSH-Client. Es ist eine gute Wahl für Entwickler, die Git unter Windows verwenden.

Mit diesen Optionen können auch Windows 11-Nutzer problemlos SSH-Verbindungen herstellen, wie es unter Linux und macOS standardmäßig möglich ist.
