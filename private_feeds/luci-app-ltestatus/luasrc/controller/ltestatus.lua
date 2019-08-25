module("luci.controller.ltestatus", package.seeall)

function index()
	entry({"admin", "status", "ltestatus"}, form("ltestatus"), _("Mobile Data Status"), 1)
	entry({"mini", "status", "ltestatus"}, form("ltestatus"), _("Mobile Data Status"), 1)
end
