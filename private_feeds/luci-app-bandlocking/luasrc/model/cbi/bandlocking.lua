-- Copyright 2019 Nicholas Smith <mips171@icloud.com>
-- Copyright 2019 Telco Antennas Pty Ltd <nicholas.smith@telcoantennas.com.au>
-- Licensed to the public under the GPL v2 License.

local utl = require "luci.util"
local sys = require "luci.sys"
local ipc = require "luci.ip"
local fs  = require "nixio.fs"

m = SimpleForm("bandlocking", translate("Band Locking"), "Select which bands you want to restrict the modem to using. Please check that the desired service is available in your area before locking.")
m.reset = false
m.submit = "Lock Bands"

local has_mmcli = fs.access("/usr/bin/mmcli")

if has_mmcli then

s = m:section(SimpleSection, nil, "Here you can restrict the modem to use only the specified bands. <br><br><b>Note: </b>MobileData connection will restart after changing bands.")
        ltebands = m:field(MultiValue, "ltebands", "4G LTE-A Bands", "4G LTE-A bands provide higher data capacity.")
        ltebands.delimiter = "|" 
        ltebands:value("eutran-1", "B1")
        ltebands:value("eutran-3", "B3")
        ltebands:value("eutran-5", "B5")
        ltebands:value("eutran-7", "B7")
        ltebands:value("eutran-8", "B8")
        ltebands:value("eutran-18", "B18")
        ltebands:value("eutran-19", "B19")
        ltebands:value("eutran-21", "B21")
        ltebands:value("eutran-28", "B28")
        ltebands:value("eutran-38", "B38")
        ltebands:value("eutran-39", "B39")
        ltebands:value("eutran-40", "B40")
        ltebands:value("eutran-41", "B41")

        umtsbands = m:field(MultiValue, "umtsbands", "3G Bands", "3G bands may have greater availability under some circumstances.")
        umtsbands.delimiter = "|"
        umtsbands:value("utran-1", "B1")
        umtsbands:value("utran-5", "B5")
        umtsbands:value("utran-6", "B6")
        umtsbands:value("utran-8", "B8")
        umtsbands:value("utran-9", "B9")
        umtsbands:value("utran-19", "B19")

        default = m:field(Flag, "default", "Reset to Default", "Reset the modem to use default bands (all bands).")

c = m:section(SimpleSection, nil, "Currently allowed bands <a href='https://" .. luci.sys.exec('uci get network.lan.ipaddr') .. "/cgi-bin/luci/admin/network/bandlocking" .. "'>[update]</a>" .. "<br><br>" ..

	luci.sys.exec("mmcli -m 0 -K | grep modem.generic.current-bands.value | sed 's/^.*: //'"):gsub("eutran","<br>4G"):gsub("utran","<br>3G"):gsub("-", " band "))

else
        msg = translate("This device's modem was not detected.  Please reinstall the firmware without keeping settings or reset to factory defaults.")
        m.message = msg
end

function m.handle(self, state, data)
	if state == FORM_VALID and FORM_CHANGED then
		umtswarning = " "
		-- If bands are selected, construct a string from the bands to set, then send it to ModemManager for processing.
		-- Display some messages to the user dynamically.
	if (not (data.umtsbands == nil) or (not (data.ltebands == nil))) then
		if data.umtsbands == nil then
				bands_to_set = data.ltebands
			elseif data.ltebands == nil then
				bands_to_set = data.umtsbands
				umtswarning = "<b>Note: </b>You have locked to 3G only.  You may need to set the correct APN in the MobileData interface settings and restart the connection."
			else
				data.ltebands = data.ltebands .. "|"
				bands_to_set = data.ltebands .. data.umtsbands
		end

	local stat = luci.sys.exec('mmcli -m 0 --set-current-bands="' .. bands_to_set .. '" && /etc/init.d/modemmanager restart ') == 0

	if stat then
			m.errmessage = translate("Unknown error.")
		else
			m.message = translate("<font color='#20BF55'><b>Successfully locked to bands: </b></font> " .. bands_to_set .. "<br>Click update to refresh the list of currently allowed bands.<br><br>" .. umtswarning)
		end

	end

	if (data.default) then
		bands_to_set = "utran-1|utran-6|utran-5|utran-8|utran-9|eutran-1|eutran-3|eutran-5|eutran-7|eutran-18|eutran-19|eutran-21|eutran-28|eutran-38|eutran-39|eutran-40|eutran-41|utran-19"
		local stat = luci.sys.exec('mmcli -m 0 --set-current-bands="' .. bands_to_set .. '" && /etc/init.d/modemmanager restart') == 0
		if stat then
			m.errmessage = translate("Unknown error.")
		else
			m.message = translate("<font color='#20BF55'><b>Successfully reset to default bands: </b></font> " .. bands_to_set .. "<br>Click update to refresh the list of currently allowed bands.<br><br>")
		end
	end


	return true
	end
end
return m
