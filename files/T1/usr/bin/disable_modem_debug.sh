#!/bin/sh
# rma_modem.sh
#
# Copyright 2020 Telco Antennas Pty Ltd.
# Nicholas Smith <nicholas.smith@telcoantennas.com.au>
#

if [ "$(cat /etc/modemsettings/modem_needs_rma)" = "false" ] && [ "$(cat /etc/modemsettings/modem_in_10D)" = "true" ]; then
    echo "false" >/etc/modemsettings/modem_debug_mode
    echo "Successfully disabled Modem DEBUG mode."
    logger -t INFO "Successfully disabled Modem DEBUG mode."
else
    echo "Modem either not RMA'd or in 10D mode."
    logger -t INFO "Modem either not RMA'd or in 10D mode."
fi