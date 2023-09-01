module("luci.controller.alist", package.seeall)

function index()
	entry({"admin", "services"}, firstchild(), _("NAS") , 45).dependent = false
	if not nixio.fs.access("/etc/config/alist") then
		return
	end

	local page = entry({"admin", "services", "alist"}, alias("admin", "services", "alist", "basic"), _("Alist"), 20)
	page.dependent = true
	page.acl_depends = { "luci-app-alist" }

	entry({"admin", "services"}, firstchild(), "NAS", 44).dependent = false
	entry({"admin", "services", "alist", "basic"}, cbi("alist/basic"), _("Basic Setting"), 1).leaf = true
	entry({"admin", "services", "alist", "log"}, cbi("alist/log"), _("Logs"), 2).leaf = true
	entry({"admin", "services", "alist", "alist_status"}, call("alist_status")).leaf = true
	entry({"admin", "services", "alist", "get_log"}, call("get_log")).leaf = true
	entry({"admin", "services", "alist", "clear_log"}, call("clear_log")).leaf = true
	entry({"admin", "services", "alist", "admin_info"}, call("admin_info")).leaf = true
end

function alist_status()
	local sys  = require "luci.sys"
	local uci  = require "luci.model.uci".cursor()
	local port = tonumber(uci:get_first("alist", "alist", "port"))

	local status = {
		running = (sys.call("pidof alist >/dev/null") == 0),
		port = (port or 5244)
	}

	luci.http.prepare_content("application/json")
	luci.http.write_json(status)
end

function get_log()
	luci.http.write(luci.sys.exec("cat $(uci -q get alist.@alist[0].temp_dir)/alist.log"))
end

function clear_log()
	luci.sys.call("cat /dev/null > $(uci -q get alist.@alist[0].temp_dir)/alist.log")
end

function admin_info()
	local random = luci.sys.exec("/usr/bin/alist --data $(uci -q get alist.@alist[0].data_dir) admin random 2>&1")
	local username = string.match(random, "username: (%S+)")
	local password = string.match(random, "password: (%S+)")

	luci.http.prepare_content("application/json")
	luci.http.write_json({username = username, password = password})
end
