#!/bin/bash
ip=$(hostname --ip)
rm -rf "/tmp/.X"*
rm -rf "/home/bsys/.vnc/unix:*"
cat /home/bsys/.vnc/xstartup.turbovnc
ls /home/bsys/.vnc -al
chmod -f 777 /tmp/.X11-unix
# From: https://superuser.com/questions/806637/xauth-not-creating-xauthority-file (squashes complaints about .Xauthority)
sudo -u bsys -H bash -c "touch /home/bsys/.Xauthority"
sudo -u bsys -H bash -c "xauth generate :1 . trusted"

su - bsys  -c "/opt/TurboVNC/bin/vncserver -SecurityTypes None"


if [ $? -eq 0 ] ; then
    /opt/noVNC/utils/launch.sh --vnc $ip:5901 --cert /home/bsys/.self.pem --listen 40001;
fi

