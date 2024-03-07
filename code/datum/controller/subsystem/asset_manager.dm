var/list/load_on_process = list()
var/list/received = list()

SUBSYSTEM_DEF(assets)
	var/list/asset_cache = list()
	priority = 60
	tick_rate = 10

/subsystem/assets/Initialize(timeofday)
	. = ..()
	load_assets()

/subsystem/assets/process()
	for(var/i in load_on_process)
		var/list/load_info = i
		var/client/C = load_info["client"]
		var/asset_name = load_info["asset_name"]
		if(C && asset_name && asset_name in asset_cache && !(C.ckey in received[asset_name]))
			C << browse_rsc(asset_cache[asset_name], asset_name)
			if(!received[asset_name])
				received[asset_name] = list()
			received[asset_name] += C.ckey
	load_on_process = list()
	return TRUE

/subsystem/assets/proc/load_assets()
	var/base_dir = "zgui"
	var/list/html_files = list(
		"index.html",
		"chat.html"
	)

	for(var/file_path in html_files)
		asset_cache[file_path] = file2text(text2path("[base_dir]/[file_path]"))
	return TRUE


/proc/send_preloaded_asset(client/C, asset_name)
	if(SSassets && asset_name in SSassets.asset_cache && !(C.ckey in received[asset_name]))
		C << browse_rsc(SSassets.asset_cache[asset_name], asset_name)
		if(!received[asset_name])
			received[asset_name] = list()
		received[asset_name] += C.ckey
	else if(!(C.ckey in received[asset_name]))
		load_on_process += list(list("client" = C, "asset_name" = asset_name))
