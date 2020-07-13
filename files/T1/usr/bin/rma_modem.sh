#!/bin/sh
# rma_modem.sh
#
# Copyright 2020 Telco Antennas Pty Ltd.
# Nicholas Smith <nicholas.smith@telcoantennas.com.au>
#

if [ $(cat /etc/modemsettings/modem_needs_rma) = "true" ]; then
    if [ $(cat /etc/modemsettings/modem_debug_mode) = "true" ]; then

        logger -t INFO "Performing RMA of modem. DO NOT interrupt this process."
        printf "\nPerforming RMA of modem. DO NOT interrupt this process.\n"
        echo "Authenticating with modem"
        logger -t INFO "Authenticating with modem"
        mmcli -m any --command="AT!ENTERCND=\"A710\""
        sleep 2

        echo "Issuing RMARESET=1"
        logger -t INFO "Issuing RMARESET=1"
        mmcli -m any --command="AT!RMARESET=1"
        sleep 2

        echo "Issuing AT!RESET command."
        logger -t INFO "Issuing AT!RESET command."
        mmcli -m any --command="AT!RESET"
        sleep 5

        echo "Setting modem offline."
        logger -t INFO "Setting modem offline."
        echo 0 >/sys/class/gpio/gpio14/value
        sleep 5

        echo "Restarting modem then waiting 20s for it to boot."
        logger -t INFO "Restarting modem then waiting 20s for it to boot."
        echo 1 >/sys/class/gpio/gpio14/value
        sleep 20

        echo "Starting ModemManager service."
        logger -t INFO "Starting ModemManager service."
        /etc/init.d/modemmanager restart && ifup mobiledata
        echo "false" >/etc/modemsettings/modem_needs_rma

    else
        echo "Cannot perform RMA modem unless modem is in debug mode.  Use modemdebugmode_on to enable debug mode."
        logger -t INFO "Cannot perform RMA modem unless modem is in debug mode.  Use modemdebugmode_on to enable debug mode."

    fi
else
    echo "Doing nothing. RMA modem flag in /etc/modemsettings/modem_needs_rma is false. To RMA modem set it to true then re-run this command or perform a factory reset of this device."
    logger -t INFO "Doing nothing. RMA modem flag in /etc/modemsettings/modem_needs_rma is false. To RMA modem set it to true then re-run this command, or perform a factory reset of this device."

fi
