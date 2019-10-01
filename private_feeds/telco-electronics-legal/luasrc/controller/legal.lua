module("luci.controller.legal",package.seeall)                  

function index()
        entry({"admin", "system", "legal"}, template("legal"), "License Agreements", 20).dependent=false                                      

end
