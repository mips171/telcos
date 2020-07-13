#!/bin/sh

ZERO=0
NOSIGNAL=0
POOR=25
FAIR=50
GOOD=80
EXCELLENT=90
#MODEMINDEX="$(/usr/bin/mmcli -L -K  | grep -Eo '/org/freedesktop/.*' | tr -d "'")"

mmcli -m any --signal-setup=3
mmcli -m any >/tmp/modemstatus
SIGVALUE="$(grep quality /tmp/modemstatus | sed 's/.*: //' | tr -cd [:digit:])"

if [[ "$SIGVALUE" -eq "$ZERO" ]]; then
    echo 0 >/sys/class/leds/tel-t1\:blue\:signal1/brightness
    echo 0 >/sys/class/leds/tel-t1\:blue\:signal2/brightness
    echo 0 >/sys/class/leds/tel-t1\:blue\:signal3/brightness
else
    if [[ "$SIGVALUE" -ge "$NOSIGNAL" ]]; then
        echo 1 >/sys/class/leds/tel-t1\:blue\:signal1/brightness
    else
        echo 0 >/sys/class/leds/tel-t1\:blue\:signal1/brightness
    fi
    if [[ "$SIGVALUE" -ge "$FAIR" ]]; then
        echo 1 >/sys/class/leds/tel-t1\:blue\:signal2/brightness
    else
        echo 0 >/sys/class/leds/tel-t1\:blue\:signal2/brightness
    fi
    if [[ "$SIGVALUE" -ge "$GOOD" ]]; then
        echo 1 >/sys/class/leds/tel-t1\:blue\:signal3/brightness
    else
        echo 0 >/sys/class/leds/tel-t1\:blue\:signal3/brightness
    fi
fi
