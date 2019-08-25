module("luci.controller.bandlocking", package.seeall)

function index()
	entry({"admin", "network", "bandlocking"}, form("bandlocking"), _("Band Locking"), 1)
	entry({"mini", "network", "bandlocking"}, form("bandlocking"), _("Band Locking"), 1)
end
