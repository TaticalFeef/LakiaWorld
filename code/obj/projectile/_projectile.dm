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

	// fisica
	pixel_x_float_physical += movement_x_per_tick
	pixel_y_float_physical += movement_y_per_tick

	// visoual
	pixel_x_float_visual += movement_x_per_tick
	pixel_y_float_visual += movement_y_per_tick

	if (!start_time)
		start_time = world.time
	start_time += TICKS_TO_DECISECONDS(tick_rate)

	var/rounded_x = CEILING(pixel_x_float_visual, 1)
	var/rounded_y = CEILING(pixel_y_float_visual, 1)

	if (pixel_x != rounded_x || pixel_y != rounded_y)
		var/pixel_offset_x = vel_x
		var/pixel_offset_y = vel_y
		var/norm = max(abs(pixel_offset_x), abs(pixel_offset_y))
		pixel_offset_x = round((pixel_offset_x / norm) * TILE_SIZE)
		pixel_offset_y = round((pixel_offset_y / norm) * TILE_SIZE)

		if (world.tick_usage < 90 && max(abs(vel_x), abs(vel_y)) < TILE_SIZE * TICKS_TO_SECONDS(SSprojectiles.tick_rate))
			animate(src, pixel_x = rounded_x + pixel_offset_x, pixel_y = rounded_y + pixel_offset_y, time = tick_rate)
		else
			pixel_x = rounded_x + pixel_offset_x
			pixel_y = rounded_y + pixel_offset_y

	check_turf_transition()

/obj/projectile/proc/check_turf_transition()
	var/max_normal = max(abs(vel_x), abs(vel_y))
	var/x_normal = vel_x / max_normal
	var/y_normal = vel_y / max_normal

	var/current_loc_x = x + FLOOR(((TILE_SIZE / 2) + pixel_x_float_physical + x_normal * TILE_SIZE) / TILE_SIZE, 1)
	var/current_loc_y = y + FLOOR(((TILE_SIZE / 2) + pixel_y_float_physical + y_normal * TILE_SIZE) / TILE_SIZE, 1)

	if ((last_loc_x != current_loc_x) || (last_loc_y != current_loc_y))
		if ((last_loc_x != current_loc_x) && (last_loc_y != current_loc_y))
			if (intercardinal_fix_switch)
				pixel_x_float_physical -= vel_x
				current_loc_x = x + FLOOR(((TILE_SIZE / 2) + pixel_x_float_physical + x_normal * TILE_SIZE) / TILE_SIZE, 1)
			else
				pixel_y_float_physical -= vel_y
				current_loc_y = y + FLOOR(((TILE_SIZE / 2) + pixel_y_float_physical + y_normal * TILE_SIZE) / TILE_SIZE, 1)

			intercardinal_fix_switch = !intercardinal_fix_switch

		current_loc = locate(current_loc_x, current_loc_y, z)
		if (!on_enter_tile(previous_loc, current_loc))
			return FALSE
		previous_loc = current_loc
		last_loc_x = current_loc_x
		last_loc_y = current_loc_y
	else if (steps_current == 0 && !on_enter_tile(loc, loc))
		return FALSE

/obj/projectile/proc/animate_proj_movement(var/tick_rate)
	var/new_pixel_x = round(pixel_x_float_visual)
	var/new_pixel_y = round(pixel_y_float_visual)

	if(pixel_x != new_pixel_x || pixel_y != new_pixel_y)
		var/animation_time = max(1, tick_rate)
		animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = animation_time, flags = ANIMATION_RELATIVE)

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
/*
/mob/var/atom/last_clicked_atom
/mob/var/image/target_overlay

/mob/proc/update_target_overlay(atom/new_target)
	if(!new_target)
		if(target_overlay)
			client.screen -= target_overlay
			zDel(target_overlay)
			target_overlay = null
			SSoverlay.remove_mob(src)
	return

	var/turf/T = locate(new_target.x, new_target.y, new_target.z)
	if(!target_overlay)
		target_overlay = image('target.dmi', T, "target_icon", layer = 1000)
		src << target_overlay
		SSoverlay.add_mob(new_target)
	else
		target_overlay.loc = T

/mob/verb/fire()
	set name = "Fire"
	set category = "Actions"

	var/clicked_atom = last_clicked_atom
	if(!clicked_atom)
		return

	var/turf/target_turf = get_turf(clicked_atom)
	if(!target_turf)
		return

	var/diff_x = target_turf.x - src.x
	var/diff_y = target_turf.y - src.y
	var/angle = ATAN2(diff_x, diff_y)

	var/obj/projectile/P = new /obj/projectile(loc, angle, 10)
	P.name = "alow"

/atom/Click(atom/clicked, location, control, params)
	..()
	if(ismob(usr))
		var/mob/M = usr
		M.last_clicked_atom = clicked
		M.update_target_overlay(clicked)
*/