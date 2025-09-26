#!/bin/bash


if ! test -f /home/*/.ssh/id_rsa; then
	_user="pocketlab"
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
fi
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

