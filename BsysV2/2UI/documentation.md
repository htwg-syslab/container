### Dockerfile Documentation

#### Base Image and Arguments
```dockerfile
FROM systemlabor/bsys:pocketlabbase

ARG my_user="pocketlab"
ARG my_password="pocketlab"
```
- **Base Image**: Uses `systemlabor/bsys:pocketlabbase` as the base image.
- **Arguments**: Sets default values for `my_user` and `my_password`.

#### Install Linux Packages
```dockerfile
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl wget less sudo lsof git net-tools psmisc xz-utils nemo \
    vim net-tools iputils-ping traceroute bmon tmux sudo geany \
    xubuntu-desktop xterm zenity make cmake gcc libc6-dev dbus-x11 \
    x11-xkb-utils xauth xfonts-base xkb-data mesa-utils xvfb libgl1-mesa-dri \
    libgl1-mesa-glx libglib2.0-0 libxext6 libsm6 libxrender1 libglu1 \
    libxv1 libegl1-mesa libpython-all-dev libsuitesparse-dev \
    libgtest-dev openssl libeigen3-dev libsdl1.2-dev libsdl-image1.2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
```
- **Package Installation**: Installs various development tools, network utilities, and graphical libraries required for the setup.

#### Install Firefox
```dockerfile
RUN add-apt-repository -y ppa:mozillateam/ppa
COPY mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y firefox
```
- **PPA Addition**: Adds the Mozilla Team PPA for Firefox.
- **Preferences**: Copies preferences to prioritize Mozilla Team's Firefox version.
- **Installation**: Installs Firefox.

#### Install VSCode
```dockerfile
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) \
        curl -fsSL -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
        ;; \
        arm64) \
        curl -fsSL -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64" \
        ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    dpkg -i *.deb && \
    rm -f *.deb
```
- **Architecture Check**: Downloads the appropriate version of VSCode based on the system architecture.
- **Installation**: Installs VSCode from the downloaded package.

#### Install VirtualGL and TurboVNC
```dockerfile
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) \
            dpkg --add-architecture i386; \
            apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libxtst6:i386 libglu1 libglu1:i386 libxv1 libxv1:i386 libegl1-mesa:i386 && apt-get clean && rm -rf /var/lib/apt/lists/* ;; \
        arm64) ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac;

RUN set -eux;cd /tmp; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) \
        curl -fsSL -O "https://sourceforge.net/projects/turbovnc/files/3.0.3/turbovnc_3.0.3_amd64.deb" \
        -O "https://sourceforge.net/projects/libjpeg-turbo/files/2.1.5.1/libjpeg-turbo-official_2.1.5.1_amd64.deb" \
        -O "https://sourceforge.net/projects/virtualgl/files/3.1/virtualgl_3.1_amd64.deb" \
        ;; \
        arm64) \
        curl -fsSL -O "https://sourceforge.net/projects/turbovnc/files/3.0.3/turbovnc_3.0.3_arm64.deb" \
        -O "https://sourceforge.net/projects/libjpeg-turbo/files/2.1.5.1/libjpeg-turbo-official_2.1.5.1_arm64.deb" \
        -O "https://sourceforge.net/projects/virtualgl/files/3.1/virtualgl_3.1_arm64.deb" \
        ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
```
- **Package Installation**: Installs VirtualGL, TurboVNC, and their dependencies based on the system architecture.

#### Install noVNC
```dockerfile
RUN curl -fsSL "https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz" | tar -xzf - -C /opt && \
    curl -fsSL "https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz" | tar -xzf - -C /opt && \
    mv /opt/noVNC-* /opt/noVNC && \
    chmod -R a+w /opt/noVNC && \
    mv /opt/websockify-* /opt/websockify && \
    cd /opt/websockify && make && \
    cd /opt/noVNC/utils && \
    ln -s /opt/websockify
```
- **Download and Setup**: Downloads, extracts, and sets up noVNC and websockify.

#### Configure SSL and Desktop Files
```dockerfile
COPY xorg.conf /etc/X11/xorg.conf
COPY index.html /opt/noVNC/index.html
RUN openssl req -subj '/C=DE/ST=KN/L=KN/O=Dis/CN=unvalid.kk' -x509 -nodes -days 358000 -newkey rsa:2048 -keyout /home/"$my_user"/.self.pem -out /home/"$my_user"/.self.pem

RUN mkdir -p /home/"$my_user"/.vnc
COPY xstartup.turbovnc /home/"$my_user"/.vnc/xstartup.turbovnc
RUN chmod a+x /home/"$my_user"/.vnc/xstartup*
RUN chown -R "$my_user":"$my_user" /home/"$my_user"
RUN echo "CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage --start-maximized --user-data-dir'" > /home/"$my_user"/.chromium-browser.init
```
- **Configuration**: Copies various configuration files, sets up SSL certificates, and configures VNC startup scripts.

#### Startup Scripts and Environment Variables
```dockerfile
ENV DISPLAY=host.docker.internal:0

EXPOSE 22 5901 40001

COPY set_display.sh set_display.sh
RUN chmod +x set_display.sh

COPY launch.sh /opt/noVNC/utils/launch.sh
COPY start_desktop.sh /usr/local/bin/start_desktop.sh
COPY bashrc /home/"$my_user"/.bashrc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
```
- **Environment Setup**: Sets the `DISPLAY` variable and exposes necessary ports.
- **Scripts**: Copies and sets permissions for various startup and configuration scripts.
- **Entrypoint**: Defines the entry point for the Docker container.

### Additional Scripts Documentation

#### entrypoint.sh
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
exec "$@"
```
- **SSH Key

 Generation**: Checks if SSH keys exist for users, generates them if not, and configures permissions.
- **Supervisord**: Starts `supervisord` to manage processes.

#### supervisord.conf
```ini
[supervisord]
nodaemon=true

[program:sshd]
priority=10
command=/usr/sbin/sshd -D
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr

[program:VNC]
priority=20
command=/usr/local/bin/start_desktop.sh
stdout_logfile=/dev/stdout
stderr_logfile=/dev/stderr
```
- **Supervisord Configuration**: Manages SSH and VNC processes.

#### start_desktop.sh
```bash
#!/bin/bash

echo "$my_password" | vncpasswd -f > "$HOME"/.vnc/passwd
chmod 600 "$HOME"/.vnc/passwd

start_vnc() {
	export DISPLAY="$1"
	/opt/TurboVNC/bin/vncserver -kill "$DISPLAY"
	/opt/TurboVNC/bin/vncserver "$DISPLAY" -name VNC_DESKTOP -securitytypes otp,tlsvnc -otp -passwd "$HOME"/.vnc/passwd
}

while true; do
	python3 /opt/noVNC/utils/websockify/run 40001 localhost:5901
	sleep 1
done &

start_vnc :1

wait -n
exit $?
```
- **VNC Password**: Sets VNC password.
- **Start VNC**: Starts VNC server and noVNC websocket proxy.

### Explanation
The Docker setup consists of:
- **Base Image**: Derived from `systemlabor/bsys:pocketlabbase`.
- **Dependencies**: Installs essential tools and software (Firefox, VSCode, VirtualGL, TurboVNC, noVNC).
- **Configuration**: Sets up Xorg, SSL, VNC, and environment variables.
- **Startup Management**: Uses `supervisord` to manage SSH and VNC services.
- **Custom Scripts**: Handles VNC server startup and SSH key generation.