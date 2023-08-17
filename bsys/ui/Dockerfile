FROM bsys:base

# changes here are not supported just jet
ARG iUSER="syslab"
ARG iPW="syslab"

#---------------------------------------------------------------------
# Install Linux stuff
#---------------------------------------------------------------------
RUN dpkg --add-architecture i386
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates curl wget less sudo lsof git net-tools psmisc xz-utils nemo vim net-tools iputils-ping traceroute htop bmon tmux sudo geany openssh-server \
    xubuntu-desktop xterm zenity make cmake gcc libc6-dev dbus-x11 chromium-browser\
    x11-xkb-utils xauth xfonts-base xkb-data \
    mesa-utils xvfb libgl1-mesa-dri libgl1-mesa-glx libglib2.0-0 libxext6 libsm6 libxrender1 \
    libglu1 libglu1:i386 libxv1 libxv1:i386 libegl1-mesa:i386 libegl1-mesa\
    python2 libpython-all-dev libsuitesparse-dev libgtest-dev openssl \
    libeigen3-dev libsdl1.2-dev libsdl-image1.2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir /run/sshd

#---------------------------------------------------------------------
# Install VirtualGL and TurboVNC
#---------------------------------------------------------------------
RUN apt-get update && apt-get install -y libxtst6:i386
RUN cd /tmp && \
    curl -fsSL -O "https://sourceforge.net/projects/turbovnc/files/3.0/turbovnc_3.0_amd64.deb" \
    -O "https://sourceforge.net/projects/libjpeg-turbo/files/2.1.3/libjpeg-turbo-official_2.1.3_amd64.deb" \
    -O "https://sourceforge.net/projects/virtualgl/files/3.0.1/virtualgl_3.0.1_amd64.deb" \
    -O "https://sourceforge.net/projects/virtualgl/files/3.0.1/virtualgl32_3.0.1_amd64.deb" && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

#---------------------------------------------------------------------
# Install noVNC
#---------------------------------------------------------------------
RUN curl -fsSL "https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz" | tar -xzf - -C /opt && \
    curl -fsSL "https://github.com/novnc/websockify/archive/v0.10.0.tar.gz" | tar -xzf - -C /opt && \
    mv /opt/noVNC-* /opt/noVNC && \
    chmod -R a+w /opt/noVNC && \
    mv /opt/websockify-* /opt/websockify && \
    cd /opt/websockify && make && \
    cd /opt/noVNC/utils && \
    ln -s /opt/websockify

COPY xorg.conf /etc/X11/xorg.conf
COPY index.html /opt/noVNC/index.html

RUN adduser $iUSER
RUN usermod -aG sudo $iUSER
RUN usermod --password $iPW $iUSER
RUN usermod -s /bin/bash $iUSER
RUN sudo -u syslab -H bash -c "source /etc/environment;rustup default stable"
RUN openssl req -subj '/C=DE/ST=KN/L=KN/O=Dis/CN=unvalid.kk' -x509 -nodes -days 358000 -newkey rsa:2048 -keyout /home/$iUSER/.self.pem -out /home/$iUSER/.self.pem

#---------------------------------------------------------------------
# Install desktop files for this user
#---------------------------------------------------------------------
RUN mkdir -p /home/$iUSER/.vnc
COPY xstartup.turbovnc /home/$iUSER/.vnc/xstartup.turbovnc
RUN chmod a+x /home/$iUSER/.vnc/xstartup*
RUN chown -R $iUSER.$iUSER /home/$iUSER
RUN echo $iUSER:$iPW | chpasswd
RUN echo "CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage --start-maximized --user-data-dir'" > /home/$iUSER/.chromium-browser.init

#---------------------------------------------------------------------
# Startup
#---------------------------------------------------------------------
COPY launch.sh /opt/noVNC/utils/launch.sh
COPY start_desktop.sh /usr/local/bin/start_desktop.sh
COPY bashrc /home/$iUSER/.bashrc

CMD /usr/local/bin/start_desktop.sh
