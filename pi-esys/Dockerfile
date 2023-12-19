FROM ubuntu:22.04

ARG my_user="esys" 
ARG my_password="esys"
WORKDIR "/"

RUN apt-get update && apt-get install -y openssh-server libncurses-dev uml-utilities libssl-dev libelf-dev flex bison shellcheck python2 unzip gnupg2 tftpd-hpa supervisor tmux minicom sudo vim bmon htop mc build-essential rsyslog

# user
RUN useradd --create-home --shell /bin/bash "$my_user"
RUN echo "$my_user:$my_password" | chpasswd
RUN usermod -aG systemd-journal "$my_user"
RUN usermod -aG dialout "$my_user"
RUN usermod -aG sudo "$my_user"

# syslog
## Meldungen lokaler Systemdienste
RUN echo "local0.* /var/log/syslog" >> /etc/rsyslog.d/50-default.conf


## ssh
## genkey @entrypoint
COPY sshd_config /etc/ssh/sshd_config
RUN mkdir -p /run/sshd

# tftp
RUN usermod -aG tftp "$my_user"
RUN mkdir -p /srv/tftp
RUN chown tftp:tftp /srv/tftp
RUN chmod g+w /srv/tftp
RUN echo 'TFTP_OPTIONS="--secure --verbose"' > /etc/default/tftpd-hpa

# scripts
## pi ctrl
COPY enable_pi.sh "/home/$my_user/enable_pi.sh"
RUN chmod +x "/home/$my_user/enable_pi.sh"
RUN chown "$my_user":"$my_user" "/home/$my_user/enable_pi.sh"

# pi firmware
RUN wget -q https://github.com/raspberrypi/firmware/archive/master.zip && unzip -q master.zip && cp -vr firmware-master/boot/* /srv/tftp/ && rm -r firmware-master master.zip
## working example
COPY config.txt /srv/tftp/
COPY cmdline.txt /srv/tftp/
COPY rootfs.cpio.gz /srv/tftp/
RUN chown -R "$my_user":tftp /srv/tftp

# ssh:22 tftp:69
EXPOSE 22 69/udp

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /

CMD ["/entrypoint.sh"]
