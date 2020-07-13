#!/bin/sh
FILE=/root/signal_log.tsv
if [ ! -f "$FILE" ]; then
    echo $(date) >>/root/signal_log.tsv && mmcli -m any --signal-get >>/tmp/signal_log.tsv
fi

qmicli --silent -p -d /dev/cdc-wdm0 --nas-get-signal-info >/tmp/modemSignal
RSSI="$(grep RSSI /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
RSRQ="$(grep RSRQ /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
RSRP="$(grep RSRP /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
SNR="$(grep SNR /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
RSCP="$(grep RSCP /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
ECIO="$(grep ECIO /tmp/modemSignal | sed 's/^.*: //' | tr -d \"\'\")"
ACTECH="$(qmicli --silent -p -d /dev/cdc-wdm0 --wds-get-data-bearer-technology | sed 's/.*: //' | tr -d \"\'\")"

# Header
#   Date Access Technology RSSI RSRP RSRQ SNR RSCP ECIO
#printf "Date\tAccess Technology\tRSSI\tRSRP\tRSRQ\tSNR\tRSCP\tECIO\n" >> /root/signal_log.tsv
# Values
printf "$(date)\t$ACTECH\t$RSSI\t$RSRP\t$RSRQ\t$SNR\t$RSCP\t$ECIO\n" >>/root/signal_log.tsv
