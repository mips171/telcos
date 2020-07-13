#!/bin/sh

modemReady="no"
SIMINDEX=0

checkModem() {
	echo "Checking modem service."
	mmcli -m any >/dev/null

	if [ $? -eq 0 ]; then
		echo "Modem is ready. Proceeding with SIM switch."
		modemReady="yes"
	else
		echo "Giving the modem an extra 5 seconds."
		sleep 5
		checkModem
	fi
}

checkModem

if [[ "$modemReady" = "yes" ]]; then
	echo "Bringing mobiledata interface down."
	ifdown mobiledata
	sleep 2
	echo "Disabling the modem."
	mmcli -m any -d
	sleep 2
	echo "Checking which SIM is currently in use."
	SIMINDEX=$(mmcli -m 0 --command=AT!UIMS? | grep -Eo [0,1]{1})
	sleep 1
	echo "Currently used SIM is: $SIMINDEX"
	if [[ "$SIMINDEX" -eq "0" ]]; then
		mmcli -m any --command=AT!UIMS=1
		echo "Switching from SIM 1 to SIM 2."
		sleep 1
		uci set network.mobiledata.sim=2
		NEWAPN=$(uci get network.mobiledata.sim2apn) && uci set network.mobiledata.apn=$NEWAPN
	fi

	if [[ "$SIMINDEX" -eq "1" ]]; then
		mmcli -m any --command=AT!UIMS=0
		uci set network.mobiledata.apn=0
		echo "Switching from SIM 2 to SIM 1."
		sleep 1
		uci set network.mobiledata.sim=1
		NEWAPN=$(uci get network.mobiledata.sim1apn) && uci set network.mobiledata.apn=$NEWAPN
	fi
	echo "Commiting configuration changes."
	uci commit network
	echo "Restarting modem service."
	/etc/init.d/modemmanager restart
	echo "30 seconds remaining."
	sleep 15
	echo "15 seconds remaining."
	sleep 15
	checkModem
	echo "Attempting to connect using the new SIM to the APN named $NEWAPN."
	mmcli -m any --signal-setup=5
	sleep 2
	ifup mobiledata

	unset NEWAPN
	unset simindex
	sleep 5
	mmcli -m any --simple-status

fi
