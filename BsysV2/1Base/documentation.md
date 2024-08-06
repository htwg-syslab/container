# Dokumentation für Docker-Image

## Übersicht

Dieses Docker-Image basiert auf Ubuntu 22.04 und ist für die Entwicklungs- und Testumgebung von "pocketlab" konfiguriert. Es enthält mehrere Tools und Konfigurationen, um eine komfortable und sichere Entwicklungsumgebung zu gewährleisten.

## Dockerfile

### Basis-Image

```dockerfile
FROM ubuntu:22.04
```
Das Basis-Image ist Ubuntu 22.04.

### Benutzername und Passwort

```dockerfile
ARG my_user="pocketlab"
ARG my_password="pocketlab"
```
Standard-Benutzername und Passwort. Hinweis: Bei Änderungen müssen auch die entsprechenden Anpassungen in Layer2 (UI) vorgenommen werden (siehe: `./2 UI./Dockerfile`).

### Umgebungsvariablen

```dockerfile
ENV CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    TZ=Europe/Berlin
```
Setzen von Umgebungsvariablen für Cargo, Pfad und Zeitzone.

### Pakete installieren

```dockerfile
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        openssh-server wget vim nano man-db htop curl \
        tmux zsh netcat-openbsd git sl lolcat indent bats shellcheck gcc cmake \
        xsel \
        gdb \
        gnupg \
        valgrind \
        gettext \
        supervisor \
        build-essential \
        python3-tk\
        python-is-python3\
        sudo \
        x11-apps -y \
        bash bash-completion locales
```
Installation notwendiger Pakete in einem einzigen RUN-Befehl zur Reduktion von Layern.

### Zeitzone konfigurieren

```dockerfile
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install tzdata -y
```
Installation und Konfiguration der Zeitzone.

### Benutzer hinzufügen und sudo konfigurieren

```dockerfile
RUN adduser --disabled-password --gecos "" pocketlab && \
    echo "pocketlab:pocketlab" | chpasswd && \
    usermod -aG sudo pocketlab && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
Erstellen eines neuen Benutzers "pocketlab" und Konfiguration von sudo ohne Passwortabfrage.

### SSH konfigurieren

```dockerfile
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && \
    ssh-keygen -A
```
Kopieren der SSH-Konfigurationsdatei und Generierung der SSH-Schlüssel.

### Root-Login und Public Key Authentication

```dockerfile
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
```
Erlauben des Root-Logins via SSH und Aktivierung der Public Key Authentication.

### Display-Variable setzen

```dockerfile
COPY set_display.sh /usr/local/bin/set_display.sh
RUN chmod +x /usr/local/bin/set_display.sh
RUN echo 'if [ -f /usr/local/bin/set_display.sh ]; then source /usr/local/bin/set_display.sh; fi' >> /home/pocketlab/.bashrc
```
Skript zur Setzung der Display-Variable hinzufügen und ausführbar machen.

### SSH-Port freigeben

```dockerfile
EXPOSE 22
```
Freigabe des SSH-Ports 22.

### Supervisor-Konfiguration und Entrypoint

```dockerfile
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /
CMD ["/entrypoint.sh"]
```
Kopieren der Supervisor-Konfigurationsdatei und des Entrypoint-Skripts.

## Entrypoint-Skript

```bash
#!/bin/bash

if ! test -f /home/*/.ssh/id_rsa; then
	for _user in /home/*; do
		_user="${_user##*/}"
		cd "/home/$_user" || continue
		echo "genkey for $_user"
        echo "Display = $DISPLAY"
		mkdir -p .ssh
		ssh-keygen -N '' -f .ssh/id_rsa
		cp -v .ssh/id_rsa.pub .ssh/authorized_keys
		chown -R "$_user":"$_user" "/home/$_user"
		chmod 700 .ssh
		chmod 600 .ssh/authorized_keys
		chmod 600 .ssh/id_rsa
		chmod 644 .ssh/id_rsa.pub
		echo "user: $_user rsa:"
		echo ""
		cat  "/home/$_user/.ssh/id_rsa"
		echo ""
		cd - || exit
	done
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
```
Skript zur Generierung von SSH-Schlüsseln für Benutzer und Start von Supervisor.

## set_display.sh

```bash
#!/bin/bash
export DISPLAY=host.docker.internal:0
```
Skript zur Setzung der Display-Variable.

## sshd_config

Konfigurationsdatei für den SSH-Server:

```plaintext
# Port und Protokolleinstellungen
Port 22
Protocol 2

# HostKeys
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Authentifizierungseinstellungen
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
PubkeyAuthentication yes
PasswordAuthentication no

# Weiteres
X11Forwarding yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
AllowAgentForwarding yes
AllowTcpForwarding yes
UsePAM no
```

## supervisord.conf

Konfigurationsdatei für Supervisor:

```plaintext
[supervisord]
nodaemon=true

[program:sshd]
command=/usr/sbin/sshd -D
autostart=true
autorestart=true
redirect_stderr=true
```

Diese Dokumentation sollte Ihnen helfen, das Docker-Image und seine Konfiguration zu verstehen und gegebenenfalls anzupassen.