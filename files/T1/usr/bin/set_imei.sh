#!/bin/sh
IMEI=$(qmicli --silent -p -d /dev/cdc-wdm0 --dms-get-ids | grep IMEI | sed 's/^.*: //' | tr -cd [:digit:])
uci set system.@system[0].imei=$IMEI
uci commit system
uci commit luci
