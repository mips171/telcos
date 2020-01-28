-- Copyright 2020 Nicholas Smith <nicholas.smith@telcoantennas.com.au>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.status", package.seeall)

function index()
	entry({"admin", "status", "realtime"}, alias("admin", "status", "realtime", "modemsignal"), _("Modem Signal Graph"), 8)
	
	if nixio.fs.access("/usr/bin/qmicli") then
		entry({"admin", "status", "realtime", "modemsignal"}, template("modemsignal"), _("Modem Signal"), 5).leaf = true
		entry({"admin", "status", "realtime", "modemsignal"}, call("action_modemsignal")).leaf = true
	end
end

function action_modemsignal(iface)
	luci.http.prepare_content("application/json")

	local bwc = io.popen("luci-bwc -r %s 2>/dev/null"
		% luci.util.shellquote(iface))

	if bwc then
		luci.http.write("[")

		while true do
			local ln = bwc:read("*l")
			if not ln then break end
			luci.http.write(ln)
		end

		luci.http.write("]")
		bwc:close()
	end
end
