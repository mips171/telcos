#!/bin/sh

# Log the signal

echo $(date) >> /tmp/signal.log && qmicli -p -d /dev/cdc-wdm0 --nas-get-signal-info >> /tmp/signal.log && qmicli -p -d /dev/cdc-wdm0 --nas-get-serving-system | grep cell >> /tmp/signal.log
