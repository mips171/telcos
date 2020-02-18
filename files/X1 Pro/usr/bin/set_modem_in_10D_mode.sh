#!/bin/sh
# set_modem_in_10D_mode.sh
#
# Sets the modem in 10D mode, 000010D (1 wwan0 interface) if it is not already in 10D mode.
# Modem needs a little extra time after AT!RESET to initialise.
#
# Copyright 2019 Telco Antennas Pty Ltd.
# Nicholas Smith <nicholas.smith@telcoantennas.com.au>
#

if [ $(cat /etc/modemsettings/modem_in_10D) = "false" ]; then

	logger -t INFO "Stopping ModemManager service."
	ifdown mobiledata
	sleep 5
	/etc/init.d/modemmanager stop
	sleep 5
	logger -t INFO "Entering Sierra Wireless admin mode."
	printf "AT!ENTERCND=\"A710\"\r" > /dev/ttyUSB2
	sleep 1
	logger -t INFO "Unlocking modem bands."
	printf "AT!BAND=00\r" > /dev/ttyUSB2
	sleep 1
	logger -t INFO "Issuing command."
	qmicli -p -d /dev/cdc-wdm0 --dms-swi-set-usb-composition=6
	sleep 1

	logger -t INFO "Resetting modem."
	qmicli -p -d /dev/cdc-wdm0 --dms-set-operating-mode=offline
	sleep 2
	qmicli -p -d /dev/cdc-wdm0 --dms-set-operating-mode=reset
	echo "true" > /etc/modemsettings/modem_in_10D
	logger -t INFO "Restarting ModemManager service."
	/etc/init.d/modemmanager restart && ifup mobiledata
	
else
	logger -t INFO "Modem already is in 10D mode."
fi
