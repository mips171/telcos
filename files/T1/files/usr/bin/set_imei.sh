#!/bin/sh
IMEI=$(mmcli -m 0 |  grep "equipment id" |  tr -cd [:digit:])
uci set system.@system[0].imei=$IMEI
uci commit system
uci commit luci
