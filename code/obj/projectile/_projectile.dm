#define PIXELS_PER_TURF 32
#define TILE_SIZE PIXELS_PER_TURF
#define RAD_TO_DEG (180 / PI)
#define RAD_TO_DEG_RATIO (PI / 180)

/obj/projectile
	name = "Projetil Mistico"
	icon = 'projectiles.dmi'
	plane = PLANE_MOVABLE
	layer = LAYER_OBJ
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_ID

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
	vel_x   = cos(angle) * float_speed
	vel_y   = sin(angle) * float_speed

	pixel_x_float_visual = vel_x
	pixel_y_float_visual = vel_y
	pixel_x_float_physical = vel_x
	pixel_y_float_physical = vel_y

	SSprojectiles.add_projectile(src)

/obj/projectile/Destroyed()
	. = ..()
	SSprojectiles.remove_projectile(src)

/obj/projectile/proc/update_position(var/tick_rate)
	var/movement_x_per_tick = vel_x * tick_rate
	var/movement_y_per_tick = vel_y * tick_rate

	for (var/i = 1; i <= max(abs(movement_x_per_tick), abs(movement_y_per_tick)); i++)
		pixel_x_float_physical += sign(movement_x_per_tick)
		pixel_y_float_physical += sign(movement_y_per_tick)

		if (check_collision())
			return
	var/max_normal = max(abs(pixel_x_float_physical), abs(pixel_y_float_physical))
	update_visual_position(tick_rate, max_normal)

/obj/projectile/proc/check_collision()
	var/new_x = x + round(pixel_x_float_physical / TILE_SIZE)
	var/new_y = y + round(pixel_y_float_physical / TILE_SIZE)
	var/turf/new_turf = locate(new_x, new_y, z)

	if (new_turf && new_turf.density)
		handle_collision(new_turf)
		return TRUE

	return FALSE

/obj/projectile/proc/handle_collision(turf/collision_turf)
	zDel(src)

/obj/projectile/proc/update_visual_position(var/tick_rate, var/max_normal)
	pixel_x_float_visual = pixel_x_float_physical
	pixel_y_float_visual = pixel_y_float_physical

	var/rounded_x = CEILING(pixel_x_float_visual, 1)
	var/rounded_y = CEILING(pixel_y_float_visual, 1)

	if (pixel_x != rounded_x || pixel_y != rounded_y)
		var/pixel_offset_x = round((vel_x / max_normal) * TILE_SIZE)
		var/pixel_offset_y = round((vel_y / max_normal) * TILE_SIZE)

		if (world.tick_usage < 90 && max(abs(vel_x), abs(vel_y)) < TILE_SIZE * TICKS_TO_SECONDS(SSprojectiles.tick_rate))
			animate(src, pixel_x = rounded_x + pixel_offset_x, pixel_y = rounded_y + pixel_offset_y, time = tick_rate)
		else
			pixel_x = rounded_x + pixel_offset_x
			pixel_y = rounded_y + pixel_offset_y

/obj/projectile/proc/on_enter_tile(atom/old_loc, atom/new_loc)
	// quando o projetil entra num tile
	// return TRUE  continua movimento
	// return FALSE pra parar
	// da pra zdeletar, fazer lazer atravessar parede, etc
	var/turf/T = new_loc
	if(T && T.density)
		vel_x = -0.01
		vel_y = -0.01
		zDel(src)
		return FALSE
	if(!T) //fora do map eu acho
		zDel(src)
	return TRUE

/obj/machine/gun/icon = 'gun.dmi'

/mob/verb/test_shoot()
	set name = "Test Shoot"
	set category = "Test"

	var/angle = 90
	var/float_speed = 30
	var/obj/projectile/P = new /obj/projectile(loc, angle, float_speed)
	P.name = "Test Projectile"