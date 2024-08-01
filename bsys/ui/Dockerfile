FROM tmp-tmp

# set to the same as in the base image (unsupport start_desktop.sh at name change)
ARG my_user="bsys"
ARG my_password="bsys"


#---------------------------------------------------------------------
# Install Linux stuff
#---------------------------------------------------------------------
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl wget less sudo lsof git net-tools psmisc xz-utils nemo \
    vim net-tools iputils-ping traceroute htop bmon tmux sudo geany \
    xubuntu-desktop xterm zenity make cmake gcc libc6-dev dbus-x11 \
    x11-xkb-utils xauth xfonts-base xkb-data mesa-utils xvfb libgl1-mesa-dri \
    libgl1-mesa-glx libglib2.0-0 libxext6 libsm6 libxrender1 libglu1 \
    libxv1 libegl1-mesa python2 libpython-all-dev libsuitesparse-dev \
    libgtest-dev openssl libeigen3-dev libsdl1.2-dev libsdl-image1.2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install firefox
RUN add-apt-repository -y ppa:mozillateam/ppa
COPY mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y firefox

# install vscode
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

#---------------------------------------------------------------------
# Install VirtualGL and TurboVNC
#---------------------------------------------------------------------
# amd64 GL acceleration deps    
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


#---------------------------------------------------------------------
# Install noVNC
#---------------------------------------------------------------------
RUN curl -fsSL "https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.tar.gz" | tar -xzf - -C /opt && \
    curl -fsSL "https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.tar.gz" | tar -xzf - -C /opt && \
    mv /opt/noVNC-* /opt/noVNC && \
    chmod -R a+w /opt/noVNC && \
    mv /opt/websockify-* /opt/websockify && \
    cd /opt/websockify && make && \
    cd /opt/noVNC/utils && \
    ln -s /opt/websockify

COPY xorg.conf /etc/X11/xorg.conf
COPY index.html /opt/noVNC/index.html


RUN openssl req -subj '/C=DE/ST=KN/L=KN/O=Dis/CN=unvalid.kk' -x509 -nodes -days 358000 -newkey rsa:2048 -keyout /home/"$my_user"/.self.pem -out /home/"$my_user"/.self.pem

#---------------------------------------------------------------------
# Install desktop files for this user
#---------------------------------------------------------------------
RUN mkdir -p /home/"$my_user"/.vnc
COPY xstartup.turbovnc /home/"$my_user"/.vnc/xstartup.turbovnc
RUN chmod a+x /home/"$my_user"/.vnc/xstartup*
RUN chown -R "$my_user":"$my_user" /home/"$my_user"
RUN echo "CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage --start-maximized --user-data-dir'" > /home/"$my_user"/.chromium-browser.init

#---------------------------------------------------------------------
# Startup
#---------------------------------------------------------------------


# ssh:22 xserver:5901 noVNC:40001
EXPOSE 22 5901 40001

COPY launch.sh /opt/noVNC/utils/launch.sh
COPY start_desktop.sh /usr/local/bin/start_desktop.sh
COPY bashrc /home/"$my_user"/.bashrc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
