-- Copyright 2018 Nicholas Smith <mips171@icloud.com>
-- Adapted from luci-proto-qmi
-- Licensed to the public under the GNU GPL v2.0.

local map, section, net = ...

local apn, pincode, username, password, iptype, peerdns, dns--, device, primarysim, antenna, accesstech
local auth, ipv6


--device = section:taboption("advanced", Value, "device", translate("Modem device"))
--device.rmempty = false

--local handle = nixio.fs.glob("/sys/devices/platform/1e1c0000.xhci/usb2/2-*")
--local handle = io.popen("realpath /sys/class/net/wwan0/device", "r")
-- Supports only one modem that has already been registered by MM.  Ensures the modem is usable.

--local handle = io.popen("mmcli -m 0 | grep 'device: ' | grep -Eo '/sys/devices/.*' | tr -d \"'\"", "r")
--local device_suggestions = handle:read("*l")
--handle:close()

--if handle then
--	device:value(device_suggestions)
--end


apn = section:taboption("general", Value, "apn", translate("APN"))

apn:value("", translate("-- Automatic --"))
apn:value("internet", "Telstra: internet")
apn:value("telstra.internet", "Telstra: telstra.internet")
apn:value("connect", "Optus: connect")
apn:value("live.vodafone.com", "Vodafone: live.vodafone.com")
apn:value("mdata.net.au", "Aldi Mobile: mdata.net.au")
apn:value("yesinternet", "Amaysim: yesinternet")
apn:value("live.vodafone.com", "Kogan Mobile: live.vodafone.com")
apn:value("live.vodafone.com", "TPG Mobile: live.vodafone.com")

--primarysim = section:taboption("advanced", Value, "sim", translate("Primary SIM"))
--primarysim:value("1", "SIM 1")
--primarysim:value("2", "SIM 2")

--antenna = section:taboption("advanced", Value, "antenna", translate("Antenna optimisation"))
--antenna:value("", translate("-- Please choose --"))
--antenna:value("xpol", "Telco XPOL")
--antenna:value("xpolmimo", "Telco XPOL MIMO")
--antenna:value("yagi", "Telco 4G Yagi")

--accesstech = section:taboption("advanced", Value, "accesstech", translate("Connection Type"))
--accesstech:value("ANY", translate("-- Automatic --"))
--accesstech:value("4g", "4G Only")
--accesstech:value("3g", "3G Only")

pincode = section:taboption("advanced", Value, "pincode", translate("PIN"), 
        translate("If your SIM has a PIN lock enter your PIN here."))

pincode.datatype = "uinteger"

username = section:taboption("advanced", Value, "username", translate("PAP/CHAP username"), 
        translate("Used only if your SIM requires a username and password."))

password = section:taboption("advanced", Value, "password", translate("PAP/CHAP password"), 
        translate("Used only if your SIM requires a username and password."))

password.password = true

auth = section:taboption("advanced", Value, "auth", translate("Authentication type"))

auth:value("", translate("-- Automatic --"))
auth:value("both", "PAP/CHAP (both)")
auth:value("pap", "PAP")
auth:value("chap", "CHAP")
auth:value("none", "NONE")

iptype = section:taboption("advanced", Value, "iptype", translate("IP connection type"))

iptype:value("", translate("-- Automatic --"))
iptype:value("ipv4", "IPv4 only")
iptype:value("ipv6", "IPv6 only")
iptype:value("ipv4v6", "IPv4/IPv6 (both - with fallback to IPv4)")

metric = section:taboption("advanced", Value, "metric", translate("Gateway metric"),
	translate("Specifies the priority of the interface; the lower the value, the higher the priority.  Used here for load balancing."))

metric.datatype = "uinteger"

peerdns = section:taboption("advanced", Flag, "peerdns",
	translate("Use provider's DNS servers"),
	translate("If unticked, the provider's DNS server addresses will be ignored and you can specify custom DNS server addresses."))

peerdns.default = peerdns.enabled


dns = section:taboption("advanced", DynamicList, "dns",
	translate("Use custom DNS servers"))

dns:depends("peerdns", "")
dns.datatype = "ipaddr"
dns.cast     = "string"
