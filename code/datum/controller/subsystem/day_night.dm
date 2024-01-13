/turf/proc/set_light_properties(_light_color, _light_intensity)
	set_light(_light_intensity * 5, _light_intensity, light_color)

SUBSYSTEM_DEF(daynight)
	name = "NOITEDIADIANOITEDIANOITEDIA"
	var/is_night = FALSE
	var/obj/sun/the_sun
	var/map_width
	var/map_height
	var/list/outdoor_turfs = list()
	var/current_batch = 1
	//var/datum/grid_system/grid
	tick_rate = 30

/subsystem/daynight/Initialize(timeofday)
	. = ..()
	var/map_size = get_map_size("map/map1.dmm")
	map_width = map_size[1]
	map_height = map_size[2]
	the_sun = new /obj/sun(locate(map_width,map_height,1))
	//grid = new /datum/grid_system(map_width,map_height)
	cache_outdoor_turfs()
	return TRUE

/subsystem/daynight/process()
	toggle_day_night()
	update_turf_lighting_batch()
	//update_turf_lighting_near_players()
	return TRUE

/subsystem/daynight/proc/toggle_day_night()
	var/day_length = 24000
	var/sped_time = world.timeofday * SUN_SPEED
	var/angle = (sped_time % day_length) / day_length * 360
	var/radius = min(map_width, map_height) / 2.3
	var/center_x = map_width / 2
	var/center_y = map_height / 2

	var/new_x = center_x + cos(angle) * radius
	var/new_y = center_y + sin(angle) * radius

	var/turf/destination = locate(new_x, new_y, 1)

	while(destination && (destination.density || destination.opacity))
		new_x += sign(center_x - new_x)
		new_y += sign(center_y - new_y)
		new_x = clamp(new_x, 1, map_width)
		new_y = clamp(new_y, 1, map_height)
		destination = locate(new_x, new_y, 1)

	if(sped_time % day_length > day_length / 2)
		is_night = TRUE
	else
		is_night = FALSE
	the_sun.update_sun(is_night, new_x, new_y)
	return TRUE

/mob/verb/jumpt_to_sun()
	var/obj/sun/S = locate(/obj/sun)
	usr.force_move(locate(S.x,S.y,S.z))

//turfs update
/subsystem/daynight/proc/get_light_color()
	if(is_night)
		return LIGHT_COLOR_NIGHT
	else if(is_dawn())
		return LIGHT_COLOR_DAWN
	else if(is_dusk())
		return LIGHT_COLOR_DUSK
	else
		return LIGHT_COLOR_DAY

/subsystem/daynight/proc/get_light_intensity()
	if(is_night)
		return LIGHT_INTENSITY_NIGHT
	return LIGHT_INTENSITY_DAY

/subsystem/daynight/proc/is_dawn()
	return FALSE

/subsystem/daynight/proc/is_dusk()
	return FALSE

/subsystem/daynight/proc/cache_outdoor_turfs()
	for(var/area/O in world)
		if(O.outside)
			for(var/turf/T in O.contents)
				if(!T.opacity && !T.density)
					outdoor_turfs += T
					//grid.add_turf(T)
					CHECK_TICK()

//meh, teria que aumentar a tick_rate. quero nao
/*/subsystem/daynight/proc/update_turf_lighting_near_players()
	var/nearby_cells = grid.get_cells_near_players()
	var/light_color = get_light_color()
	var/light_intensity = get_light_intensity()

	for(var/datum/grid_cell/cell in nearby_cells)
		for(var/turf/T in cell.turfs)
			T.set_light_properties(light_color, light_intensity)
			CHECK_TICK()*/

/subsystem/daynight/proc/update_turf_lighting_batch()
	var/light_color = get_light_color()
	var/light_intensity = get_light_intensity()

	var/total_turfs = length(outdoor_turfs)
	var/turfs_to_update = round(total_turfs * TURFS_UPDATE_PERCENT)
	var/start_index = (current_batch - 1) * turfs_to_update + 1
	var/end_index = min(start_index + turfs_to_update - 1, total_turfs)

	for(var/i = start_index; i <= end_index; i++)
		var/turf/T = outdoor_turfs[i]
		T.set_light_properties(light_color, light_intensity)
		CHECK_TICK()

	if(end_index == total_turfs)
		current_batch = 1
	else
		current_batch += turfs_to_update