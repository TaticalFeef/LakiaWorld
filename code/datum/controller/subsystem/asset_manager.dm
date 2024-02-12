SUBSYSTEM_DEF(asset_manager)

/subsystem/asset_manager
	name = "Gerente de Assets KEK"
	var/list/assets = list()
	var/list/received = list()
	priority = 60
	tick_rate = 20

/subsystem/asset_manager/Initialize(timeofday)
	. = ..()
	load_assets()

/subsystem/asset_manager/process()
	for(var/mob/C in global.player_list)
		if(!C.client.ckey in received)
			send_assets_to_user(C)
			received |= C.client.ckey
	return TRUE

/subsystem/asset_manager/proc/load_assets()
	return TRUE

/subsystem/asset_manager/proc/send_assets_to_user(mob/user)
	for(var/asset in assets)
		user << browse_rsc(file(assets[asset]), asset)
