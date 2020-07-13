#!/bin/sh
# set_modem_in_10D_mode.sh
#
# Copyright 2019 Telco Antennas Pty Ltd.
# Nicholas Smith <nicholas.smith@telcoantennas.com.au>
#

if [ $(cat /etc/modemsettings/modem_in_10D) = "false" ]; then
	if [ $(cat /etc/modemsettings/modem_debug_mode) = "true" ]; then
		logger -t INFO "Unlocking modem bands."
		/usr/bin/mmcli -m any --set-current-bands=any
		sleep 2
		logger -t INFO "Stopping ModemManager service."
		sleep 5
		/etc/init.d/modemmanager stop
		sleep 5
		logger -t INFO "Setting modem in QMI mode"
		qmicli -p -d /dev/cdc-wdm0 --dms-swi-set-usb-composition=6
		sleep 1
		logger -t INFO "Applying changes by resetting modem."
		qmicli -p -d /dev/cdc-wdm0 --dms-set-operating-mode=offline
		sleep 2
		qmicli -p -d /dev/cdc-wdm0 --dms-set-operating-mode=reset
		sleep 15
		echo "true" >/etc/modemsettings/modem_in_10D
		logger -t INFO "Restarting ModemManager service."
		/etc/init.d/modemmanager start
	else
		echo "Cannot run required commands unless modem is in debug mode.  Use modemdebugmode_on to enable debug mode."
		logger -t INFO "Cannot run required commands unless modem is in debug mode.  Use modemdebugmode_on to enable debug mode."
	fi
else
	logger -t INFO "Modem already is in 10D mode."
fi
