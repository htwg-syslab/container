# Use the latest Ubuntu 24.04 image
FROM ubuntu:24.04
# Benutzername und Passwort
ARG my_user="pythonlab"
ARG my_password="pythonlab"

# Args
ENV TZ=Europe/Berlin

# Install required packages in a single RUN statement to reduce layers
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server wget vim nano man-db htop curl \
    tmux zsh git sl lolcat shellcheck \
    xsel \
    gnupg \
    supervisor \
    python3-tk\
    python-is-python3\
    dos2unix \
    bash bash-completion locales

# Configure locale
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install tzdata -y


# Add user and configure sudo
RUN adduser --disabled-password --gecos "" pythonlab && \
    echo "pythonlab:pythonlab" | chpasswd && \
    usermod -aG sudo pythonlab && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure SSH
COPY sshd_config /etc/ssh/sshd_config

RUN dos2unix /etc/ssh/sshd_config

RUN mkdir /var/run/sshd && \
    ssh-keygen -A

# Set environmental display to x server
ENV DISPLAY=host.docker.internal:0

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable public key authentication
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's/#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Add the script to set DISPLAY variable
COPY set_display.sh /usr/local/bin/set_display.sh

RUN dos2unix /usr/local/bin/set_display.sh ; \
    chmod +x /usr/local/bin/set_display.sh

# Modify the .bashrc file for the pythonlab user
RUN echo 'if [ -f /usr/local/bin/set_display.sh ]; then source /usr/local/bin/set_display.sh; fi' >> /home/pythonlab/.bashrc; \
    echo "alias gcc='clang'" >> /etc/bash.bashrc


# Expose SSH port
EXPOSE 22
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

# Create .XAuthority File
RUN touch /home/pythonlab/.Xauthority
RUN chown pythonlab:pythonlab /home/pythonlab/.Xauthority && chmod 600 /home/pythonlab/.Xauthority
RUN echo "xauth generate $DISPLAY . trusted" >> /home/pythonlab/.bashrc


# Make entrypoint.sh executable on every Platfrom
RUN dos2unix /etc/supervisor/conf.d/supervisord.conf ; \
    dos2unix entrypoint.sh ; \
    chmod +x entrypoint.sh ;

CMD ["/entrypoint.sh"]
