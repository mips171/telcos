module("luci.controller.ltestatus", package.seeall)

function index()
	entry({"admin", "status", "ltestatus"}, template("ltestatus"), _("Mobile Data Status"), 1)
	entry({"mini", "status", "ltestatus"}, template("ltestatus"), _("Mobile Data Status"), 1)
end
