-- Copyright 2010 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local utl = require "luci.util"
local sys = require "luci.sys"
local ipc = require "luci.ip"
local fs  = require "nixio.fs"

m = SimpleForm("ltestatus", translate("Mobile Data Status"))

local has_mmcli = fs.access("/usr/bin/mmcli")

if has_mmcli then
        function m:filter(value)
                return value == "mobiledata" and value -- Only show mobiledata connections
        end

        local br = "</br>"
        local bold = "<b>"
        local nbold = "</b>"
        local sp = ": "
	    local lanIPNumber = luci.sys.exec("uci get network.lan.ipaddr")
	    local modemstatus   = luci.sys.exec("mmcli -m 0 > /tmp/modemstatus")

        function checkInternet()
                luci.sys.exec("while ! ping -c1 www.telcoantennas.com.au >/dev/null; do echo '<font color='red'>disconnected</font>. If signal is good, please check that the correct APN and other mobile data settings are in use.' > /tmp/internetstatus && exit 0; done ; echo '<font color='#20BF55'>connected</font>' > /tmp/internetstatus && exit 0")
                return tostring(luci.sys.exec("cat /tmp/internetstatus"))
        end

        local internetStatus = ""

        internetStatus = translate("Internet is") .. " " .. checkInternet() .. br

        local modemsignal   = luci.sys.exec("mmcli -m 0 --signal-setup=3 && mmcli -m 0 --signal-get > /tmp/modemsignal")
        local sim_status    = luci.sys.exec("cat /tmp/modemstatus | grep missing")
        local imei          = luci.sys.exec("cat /tmp/modemstatus | grep \"equipment id\" | sed 's/.*: //' | tr -cd [:digit:] | tr -c [:digit:]")
        local access_tech   = string.upper(luci.sys.exec("cat /tmp/modemstatus | grep access | sed 's/.*: //' | tr -d \"'\""))
        local operator_name = luci.sys.exec("cat /tmp/modemstatus | grep 'operator name' | sed 's/.*: //' | tr -d \"'\"")
        local mobile_rssi   = luci.sys.exec("grep 'rssi:' /tmp/modemsignal | sed 's/^.*: //'")
        local mobile_rsrq   = luci.sys.exec("grep 'rsrq:' /tmp/modemsignal | sed 's/^.*: //'")
        local mobile_rsrp   = luci.sys.exec("grep 'rsrp:' /tmp/modemsignal | sed 's/^.*: //'")
        local mobile_snr    = luci.sys.exec("grep 's/n:' /tmp/modemsignal | sed 's/^.*: //'")
        local mobile_rscp    = luci.sys.exec("grep 'rscp:' /tmp/modemsignal | sed 's/^.*: //'")
        local mobile_ecio    = luci.sys.exec("grep 'ecio:' /tmp/modemsignal | sed 's/^.*: //'")
	    local mobile_percentage = luci.sys.exec("grep quality /tmp/modemstatus | sed 's/.*: //' | tr -cd [:digit:] ")

        local sim_missing   = luci.sys.exec("grep 'sim-missing' /tmp/modemstatus | sed 's/.*: //' | tr -d \"'\"")

        local ab = luci.sys.exec("qmicli -p -d /dev/cdc-wdm0 --nas-get-rf-band-info")
        local ab_strip = ab:gsub("\n", "<br>")
        local ab_title = ab_strip:gsub("%[%/dev%/cdc%-wdm0%] Successfully got RF band info", "<h3>Active Band</h3>")
        local ab_strip_quotes = ab_title:gsub("'", "")
        local ab_cleanup = ab_strip_quotes:gsub("Radio Interface\:", "")
        local ab_s_lte = ab_cleanup:gsub("lte<br>", "")
        local ab_s_umts = ab_s_lte:gsub("umts<br>", "")
        local eutran = ab_s_umts:gsub("eutran%-", "LTE Band ")
        local wcdma = eutran:gsub("wcdma%-", "WCDMA-")
        local strip_br = wcdma:gsub("<h3>Active Band</h3><br>", "<h3>Active Band</h3>")
        local active_band = strip_br

        local castatus = luci.sys.exec("qmicli -p -d /dev/cdc-wdm0 --nas-get-lte-cphy-ca-info")
        local strip = castatus:gsub("\n", "<br>")
        local ch_title = strip:gsub("%[%/dev%/cdc%-wdm0%] Successfully got carrier aggregation info", "<h3>Carrier Aggregation Information</h3>Note: Secondary cell is activated only durring network activity. Bandwidth is shown in MHz.")
        local x = ch_title:gsub("Primary Cell Info", "<br><h4>Primary Cell Info</h4>")
        local y = x:gsub("Secondary Cell Info", "<br><h4>Secondary Cell Info</h4>")
        local strip_sq = y:gsub("'", "")
        local strip_eutran = strip_sq:gsub("eutran%-", "")
        local adv_mobile_info = strip_eutran

        local modemlocation = luci.sys.exec("mmcli -m 0 --location-get -K > /tmp/modemlocation")
        local mcc = luci.sys.exec("grep 'mcc' /tmp/modemlocation | sed 's/^.*: //'")
        local mnc = luci.sys.exec("grep 'mnc' /tmp/modemlocation | sed 's/^.*: //'")
        local lac = luci.sys.exec("grep 'lac' /tmp/modemlocation | sed 's/^.*: //'")
        local cid = luci.sys.exec("grep 'cid' /tmp/modemlocation | sed 's/^.*: //'")

        local msg_loc_header = "<h3>Cell Location Information</h3>"
        local msg_mcc = bold .. translate("MCC") .. sp .. nbold .. mcc .. br
        local msg_mnc = bold .. translate("MNC") .. sp .. nbold .. mnc .. br
        local msg_lac = bold .. translate("3GPP Location Area Code") .. sp .. nbold .. tostring(tonumber("0x"..lac, 10)) .. br
        local msg_cid = bold .. translate("Cell ID") .. sp .. nbold .. tostring(tonumber("0x"..cid, 10)) .. br
        local msg_location = msg_loc_header .. msg_lac .. msg_cid .. msg_mcc .. msg_mnc

        local msg_imei = bold .. translate("IMEI") .. sp .. nbold .. imei .. br
        local msg_access_tech = bold .. translate("Access Technology") .. sp .. nbold .. access_tech .. br
        local msg_operator_name = bold .. translate("Operator Name") .. sp ..nbold ..operator_name .. br

        -- signal information
		local msg_percent = bold .. translate("Percentage") .. sp .. nbold .. mobile_percentage .."%" .. br .. br .. "<hr>"
		local msg_rssi = bold .. translate("RSSI") .. sp .. nbold .. mobile_rssi .. br
        local msg_rsrq = bold .. translate("RSRQ") .. sp .. nbold .. mobile_rsrq .. br
        local msg_rsrp = bold .. translate("RSRP") .. sp .. nbold .. mobile_rsrp .. br
        local msg_snr  = bold .. translate("SNR")  .. sp .. nbold .. mobile_snr  .. br
        local msg_rscp  = bold .. translate("RSCP") .. sp .. nbold .. mobile_rscp .. br
        local msg_ecio  = bold .. translate("EC/IO").. sp .. nbold .. mobile_ecio .. br

	local internet_header = "<h3>" .. translate("Internet Connection") .. "</h3>"
	local minfo_header = "<h3>" .. translate("Modem Details") .. "</h3>"
	local signal_header = "<h3>" .. translate("Signal Information") .. "</h3>"
	local mfailed_header = "<h3>" .. translate("Connection Failed") .. "</h3>"
	local msg_sim_missing = translate("The SIM card could not be detected.  Please check that it is installed correctly and that it is has been activated. <br>Tip: If the SIM card works in a mobile phone, please check whether there is PIN lock on the SIM card.  You can enter a PIN and other SIM authentication details when editing the Mobile Data interface settings in the Advanced Settings section.<br><br><br><a href='https://" .. lanIPNumber .. "/cgi-bin/luci/admin/network/network/mobiledata'>Go to Mobile Data network settings</a>")
	local msg_no_signal = translate("No signal could be detected.  Please ensure that the antennas are connected, and that suitable signal is available in your area.")
	local internet_info = internet_header .. internetStatus
	local modem_info = minfo_header .. msg_access_tech .. msg_operator_name .. msg_imei

	local signal_info = ""

	if mobile_percentage == "0" then
		signal_info = signal_header .. "" .. msg_no_signal .. "<br>"
		else
	if string.match(access_tech, "LTE") then
	        signal_info = signal_header ..  msg_rssi .. msg_rsrq .. msg_rsrp .. msg_snr .. msg_percent .. msg_location .. active_band .. adv_mobile_info
	    elseif string.match(access_tech, "UMTS") then
	        signal_info = signal_header ..  msg_rssi .. msg_rscp .. msg_ecio .. msg_percent .. msg_location .. active_band
	    elseif string.match(access_tech, "UNKNOWN") then
			modem_info = minfo_header .. msg_imei
			signal_info = signal_header .. msg_rssi .. msg_percent .. msg_location .. active_band
		end
	end

	if string.match(sim_status, "missing") then
		modem_info = minfo_header .. msg_imei .. "<br><b>SIM card is missing</b><br><p>" .. msg_sim_missing .. "</p><br>"
		signal_info = ""
	end

	local msg = ""
	msg = internet_info .. modem_info .. signal_info
	msg = msg .. "</p>"
	m.message = msg
else

        msg = translate("This device's modem was not detected.  Please reinstall the firmware without keeping settings or reset to factory defaults.  You can perform either of these actions <a href='https://" .. lanIPNumber .. "/cgi-bin/luci/admin/system/flashops'>on this page</a>.")
        m.message = msg
end

m.reset = false
m.submit = false
return m

