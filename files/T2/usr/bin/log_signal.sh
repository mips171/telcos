#!/bin/sh

# Log the signal

echo $(date) >> /tmp/signal.log && mmcli -m 0 --signal-get >> /tmp/signal.log
