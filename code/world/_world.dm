var/tick_lag_original = 0

/world/
	fps = 25
	icon_size = 32
	view = VIEW_RANGE

	name = "Zanequinha 13"
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"

	mob = /mob/new_player // /mob/living/human
	map_format = TOPDOWN_MAP
	movement_mode = TILE_MOVEMENT_MODE

	sleep_offline = FALSE

/world/New()
	. = ..()
	tick_lag_original = tick_lag

	createtypecache(/datum)
	createtypecache(/turf)
	createtypecache(/turf/solid)
	createtypecache(/turf/solid/wall)
	createtypecache(/turf/flat)
	createtypecache(/turf/flat/floor)

	master_controller = new /datum/controller/game_controller()
	spawn()
		master_controller.setup()
	return .