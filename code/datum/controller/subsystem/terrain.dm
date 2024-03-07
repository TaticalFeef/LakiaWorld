var/global/list/multi_z_terrain = list()
#define Z_WATER_LEVEL 5
SUBSYSTEM_DEF(terrain_generator)
	var/max_z_level = 10
	var/map_width = 50
	var/map_height = 50

/subsystem/terrain_generator/Initialize()
	. = ..()
	world.maxz = max_z_level
	generate_terrain()

/subsystem/terrain_generator/proc/generate_terrain()
	for(var/z = 1, z <= max_z_level, z++)
		var/list/z_level_terrain = generate_z_level_terrain(z)
		multi_z_terrain += list(z_level_terrain)
		place_terrain_on_map(z_level_terrain)

/subsystem/terrain_generator/proc/generate_z_level_terrain(z_level)
	var/list/z_level_terrain = list()
	for(var/x = 1, x <= map_width, x++)
		for(var/y = 1, y <= map_height, y++)
			var/noise_value = text2num(rustg_noise_get_at_coordinates("[z_level]","[x]", "[y]"))
			var/terrain_type = determine_terrain_type(noise_value)
			if(z_level > Z_WATER_LEVEL && terrain_type != "mountain")
				terrain_type = "open"
			z_level_terrain += list(list("x" = x, "y" = y, "z" = z_level, "type" = terrain_type))
	return z_level_terrain

/subsystem/terrain_generator/proc/determine_terrain_type(noise_value)
	if(noise_value < 0.3)
		return "water"
	else if(noise_value < 0.6)
		return "land"
	else if (noise_value < 0.8)
		return "mountain"
	else
		return "open"

var/shownG = 0
/subsystem/terrain_generator/proc/place_terrain_on_map(list/z_level_terrain)
	var/list/land_positions_above = list()
	var/_z = 0
	for(var/terrain_info in z_level_terrain)
		var/x = terrain_info["x"]
		var/y = terrain_info["y"]
		var/z = terrain_info["z"]
		var/type = terrain_info["type"]
		_z = z
		var/placement_turf
		switch(type)
			if("water")
				placement_turf = /turf/flat/floor/grass/
			if("land")
				placement_turf = /turf/flat/floor/grass/
			if("mountain")
				placement_turf = /turf/solid/wall
			else
				placement_turf = /turf/open_space/

		var/turf/T = locate(x, y, z)
		//if(T)
			//T.ChangeTurf(placement_turf)
		//else
		if(shownG <= 20)
			shownG = shownG + 1
			world.log << "[x],[y],[z],[type]"
		if(type == "land" && z > Z_WATER_LEVEL)
			land_positions_above += list(list("x" = x, "y" = y))
		new placement_turf(locate(x,y,z))

	for(var/list/pos in land_positions_above)
		var/x = pos["x"]
		var/y = pos["y"]
		var/z_below = _z - 1
		if(z_below > Z_WATER_LEVEL && z_below >= 1)
			var/turf/below_turf = locate(x, y, z_below)
			if(below_turf && !istype(below_turf, /turf/solid/wall))
				below_turf.ChangeTurf(/turf/solid/wall)

/mob/verb/change_z()
	var/_z = input(usr,"a","a",1, "num" )
	usr.z = _z