#!/bin/sh
# Assumes that the modem has already been set up to get the current signal values
	zero=0
	nosignal=0
	poor=25
	fair=50
	good=80
	excellent=90
MODEMINDEX="$(/usr/bin/mmcli -L -K  | grep -Eo '/org/freedesktop/.*' | tr -d "'")"

mmcli -m $MODEMINDEX --signal-setup=3

while :
	do
		mmcli -m $MODEMINDEX > /tmp/modemstatus
		sigvalue=$(grep quality /tmp/modemstatus | sed 's/.*: //' | tr -cd [:digit:])
		if [[ "$sigvalue" -eq "$(cat /tmp/lastSigValue)" ]]
		then
			echo "Signal value was the same. Skipping led run."
		else
	                if [[ "$sigvalue" -eq "$zero" ]];
	                then
		                echo 0 > /sys/class/leds/tel-t1\:blue\:signal1/brightness
		                echo 0 > /sys/class/leds/tel-t1\:blue\:signal2/brightness
		                echo 0 > /sys/class/leds/tel-t1\:blue\:signal3/brightness
	                else
		                if [[ "$sigvalue" -ge "$nosignal" ]]
		                then
		                        echo 1 > /sys/class/leds/tel-t1\:blue\:signal1/brightness
		                else
		                        echo 0 > /sys/class/leds/tel-t1\:blue\:signal1/brightness
		                fi
		                if [[ "$sigvalue" -ge "$fair" ]]
		                then
			                echo 1 > /sys/class/leds/tel-t1\:blue\:signal2/brightness
		                else
			                echo 0 > /sys/class/leds/tel-t1\:blue\:signal2/brightness
		                fi
		                if [[ "$sigvalue" -ge "$good" ]]
		                then
		                        echo 1 > /sys/class/leds/tel-t1\:blue\:signal3/brightness
		                else
		                        echo 0 > /sys/class/leds/tel-t1\:blue\:signal3/brightness
		                fi
	                echo $sigvalue > /tmp/lastSigValue
		        fi
		fi
		sleep 5
done
