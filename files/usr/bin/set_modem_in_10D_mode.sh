#!/bin/sh
# set_modem_in_10D_mode.sh
#
# Sets the modem in 10D mode (1 wwan0 interface) if it is not already in 10D mode.
# Normal response from Sierra Wireless modem is blank, i.e. response: ''
#
# Copyright 2019 Telco Antennas Pty Ltd.
# Nicholas Smith <nicholas.smith@telcoantennas.com.au>
#

if [ $(cat /etc/modemsettings/modem_in_10D) = "false" ]; then
  mmcli -m 0 --command="AT!ENTERCND=\"A710\""
  logger -t INFO "$0: Entered admin mode."
  sleep 2
  logger -t INFO "$0: Set modem in 10D mode"
  mmcli -m 0 --command="AT!USBCOMP=1,1,10D" 
  sleep 2
  mmcli -m 0 --command="AT!RESET"
  logger -t INFO "$0: Resetting modem.  Waiting 30s"
  echo true > /etc/modemsettings/modem_in_10D
  sleep 30
  /etc/init.d/modemmanager restart
else
  logger -t INFO "$0: Modem already in 10D mode."
fi
