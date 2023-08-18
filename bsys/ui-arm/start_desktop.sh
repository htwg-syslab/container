#!/bin/bash
ip=$(hostname --ip)
rm -rf "/tmp/.X"*
rm -rf "/home/syslab/.vnc/unix:*"
cat /home/syslab/.vnc/xstartup.turbovnc
ls /home/syslab/.vnc -al
chmod -f 777 /tmp/.X11-unix
# From: https://superuser.com/questions/806637/xauth-not-creating-xauthority-file (squashes complaints about .Xauthority)
sudo -u syslab -H bash -c "touch /home/syslab/.Xauthority"
sudo -u syslab -H bash -c "xauth generate :1 . trusted"

su - syslab  -c "/opt/TurboVNC/bin/vncserver -SecurityTypes None"

/usr/sbin/sshd -f /etc/ssh/sshd_config

if [ $? -eq 0 ] ; then
    /opt/noVNC/utils/launch.sh --vnc $ip:5901 --cert /home/syslab/.self.pem --listen 40001;
fi

