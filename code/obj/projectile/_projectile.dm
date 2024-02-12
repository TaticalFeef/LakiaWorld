#define PIXELS_PER_TURF 32
#define TILE_SIZE PIXELS_PER_TURF
#define RAD_TO_DEG (180 / PI)
#define RAD_TO_DEG_RATIO (PI / 180)

/obj/projectile
	name = "Projetil"
	icon = 'projectiles.dmi'
	plane = PLANE_MOVABLE
	layer = LAYER_OBJ
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_ID

	var/list/collision_types = list() //com quem colidir

	var/float_speed = 1    // velocidade em pixels por tick
	var/angle = 0          // direçao

	// posiçao visual
	var/pixel_x_float_visual = 0
	var/pixel_y_float_visual = 0

	// posiçao fisica
	var/pixel_x_float_physical = 0
	var/pixel_y_float_physical = 0

	var/vel_x = 0          // X velocity: pixels por tick
	var/vel_y = 0          // Y velocity: pixels por tick

	var/start_time

	var/last_loc_x = 0
	var/last_loc_y = 0
	var/intercardinal_fix_switch = FALSE
	var/current_loc = null
	var/previous_loc = null
	var/steps_current = 0

/obj/projectile/New(_loc, _angle, _float_speed)
	. = ..()
	loc = _loc
	angle = normalize_angle(_angle)
	float_speed = _float_speed || 1

	//var/rad = angle    * RAD_TO_DEG_RATIO
	//é em degree kkkkkkkkkkkkkkkkkkkkkkkkk
	vel_x   = sin(angle) * float_speed
	vel_y   = cos(angle) * float_speed

	pixel_x_float_visual = vel_x
	pixel_y_float_visual = vel_y
	pixel_x_float_physical = vel_x
	pixel_y_float_physical = vel_y

	SSprojectiles.add_projectile(src)

/obj/projectile/Destroyed()
	. = ..()
	SSprojectiles.remove_projectile(src)

/obj/projectile/proc/update_position(var/tick_rate)
	if(ZDELING(src))
		return FALSE
	var/movement_x_per_tick = vel_x * tick_rate
	var/movement_y_per_tick = vel_y * tick_rate

	for (var/i = 1; i <= max(abs(movement_x_per_tick), abs(movement_y_per_tick)); i++)
		pixel_x_float_physical += sign(movement_x_per_tick)
		pixel_y_float_physical += sign(movement_y_per_tick)

		var/new_x = x + round(pixel_x_float_physical / TILE_SIZE)
		var/new_y = y + round(pixel_y_float_physical / TILE_SIZE)
		var/turf/new_turf = locate(new_x, new_y, z)

		if (check_collision(new_x, new_y, new_turf))
			handle_collision(new_turf)
			return
		on_enter_tile(loc, new_turf)
	var/max_normal = max(abs(pixel_x_float_physical), abs(pixel_y_float_physical))
	update_tile_position()

/obj/projectile/proc/check_collision(var/new_x, var/new_y, var/turf/new_turf)
	if (new_x < 1 || new_x > world.maxx || new_y < 1 || new_y > world.maxy)
		zDel(src)
		return TRUE

	if (new_turf)
		if(new_turf.density)
			return TRUE
		for(var/type in collision_types)
			for(var/atom/A in new_turf.contents)
				if(istype(A, type))
					return TRUE
		return FALSE
	return TRUE

/obj/projectile/proc/on_enter_tile(atom/old_loc, atom/new_loc)
	// quando o projetil entra num tile
	// return TRUE  continua movimento
	// return FALSE pra parar
	// da pra zdeletar, fazer lazer atravessar parede, etc
	var/turf/T = new_loc
	if(T && T.density || !T)
		vel_x = -0.01
		vel_y = -0.01
		zDel(src)
		return FALSE
	return TRUE

/obj/projectile/proc/handle_collision(turf/collision_turf)
	return zDel(src)

/obj/projectile/proc/update_tile_position()
	var/old_x = x
	var/old_y = y
	var/new_loc_x = x + round(pixel_x_float_physical / TILE_SIZE)
	var/new_loc_y = y + round(pixel_y_float_physical / TILE_SIZE)
	var/turf/new_turf = locate(new_loc_x, new_loc_y, z)

	if (new_turf && (new_loc_x != old_x || new_loc_y != old_y))
		loc = new_turf
		reset_visual_offsets(old_x, old_y, new_loc_x, new_loc_y)

/obj/projectile/proc/reset_visual_offsets(var/old_x, var/old_y, var/new_x, var/new_y)
	var/delta_x = new_x - old_x
	var/delta_y = new_y - old_y

	if (delta_x > 0)
		pixel_x = (-TILE_SIZE / 2) // pra direita
	else if (delta_x < 0)
		pixel_x = (TILE_SIZE / 2)  // pra esquerda
	else
		pixel_x = 0              // sem movimento horizontal

	if (delta_y > 0)
		pixel_y = - (TILE_SIZE / 2) // pra cima
	else if (delta_y < 0)
		pixel_y = (TILE_SIZE / 2)  // pra baixo
	else
		pixel_y = 0              // sem movimento vertical

/obj/machine/gun/icon = 'gun.dmi'

/mob/verb/test_shoot()
	set name = "Test Shoot"
	set category = "Test"

	var/angle = 90
	var/float_speed = 30
	var/obj/projectile/P = new /obj/projectile(loc, angle, float_speed)
	P.name = "Test Projectile"