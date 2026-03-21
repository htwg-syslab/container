#!/bin/bash
ip=$(hostname --ip)
rm -rf "/tmp/.X"*
rm -rf "/home/pocketlab/.vnc/unix:*"
cat /home/pocketlab/.vnc/xstartup.turbovnc
ls /home/pocketlab/.vnc -al
chmod -f 777 /tmp/.X11-unix
# From: https://superuser.com/questions/806637/xauth-not-creating-xauthority-file (squashes complaints about .Xauthority)
sudo -u pocketlab -H bash -c "touch /home/pocketlab/.Xauthority"
sudo -u pocketlab -H bash -c "xauth generate :1 . trusted"

su  pocketlab  -c "/opt/TurboVNC/bin/vncserver -SecurityTypes None"


if [ $? -eq 0 ] ; then
    /opt/noVNC/utils/launch.sh --vnc $ip:5901 --cert /home/pocketlab/.self.pem --listen 40001;
fi

