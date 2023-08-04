#!/bin/bash

GPIO="17"
WORK_SPACE="/dev/shm/"

# init pins in root crontab
#echo $GPIO > "/sys/class/gpio/export"
#echo out > "/sys/class/gpio/gpio$GPIO/direction"

function enable_pi {
	if $1;then
		echo 0 > "/sys/class/gpio/gpio$GPIO/value"
		echo "Pi is now enabled."
	else
		echo 1 > "/sys/class/gpio/gpio$GPIO/value"
		echo "Pi is now disabled."
	fi
}

enable_pi $1
