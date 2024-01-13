/turf/
	plane = PLANE_FLOOR
	layer = LAYER_FLOOR

/turf/flat/
	plane = PLANE_FLOOR
	layer = LAYER_FLOOR
	density = FALSE

/turf/flat/floor/grass/
	icon = 'floors.dmi'
	icon_state = "grass1"

/turf/flat/floor/grass/New()
	. = ..()
	icon_state = "grass[rand(1,4)]"

/turf/flat/floor
	icon = 'floors.dmi'
	icon_state = "floor"

/turf/solid/
	density = TRUE
	opacity = TRUE

/turf/solid/wall
	icon = 'transfer.dmi'
	plane = PLANE_WALL
	var/smooth_type = "none"
	var/joinable = FALSE

/turf/solid/wall/metal
	icon_state = "metal0"
	smooth_type = "metal"
	joinable = TRUE

/turf/solid/wall/r_wall
	icon_state = "rwall0"
	smooth_type = "rwall"
	joinable = TRUE

/turf/solid/wall/New()
	..()
	if(joinable) AutoJoin()
	spawn(1)
		for(var/turf/solid/wall/g in orange(1, src))
			if(((src.x == g.x) || (src.y == g.y)) && g.joinable)
				g.AutoJoin()

/turf/solid/wall/proc/AutoJoin()
	var/junction = 0
	var/my_x = src.x
	var/my_y = src.y

	for(var/turf/solid/wall/W in orange(1, src))
		if((my_x == W.x) || (my_y == W.y))
			junction |= get_dir(src, W)

	icon_state = "[smooth_type][junction]"
	return