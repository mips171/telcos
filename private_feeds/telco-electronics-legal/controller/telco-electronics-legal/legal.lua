module("luci.controller.telco-electronics-legal.legal",package.seeall)
function index()
entry({"admin","system","legal"},template("telco-electronics-legal/legal"),"License Agreement",20).dependent=false
end
