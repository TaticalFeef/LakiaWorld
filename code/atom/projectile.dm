#define RAND_PRECISE(Low, High) (Low + (rand() * ((High - Low) / 1.0)))

/atom/proc/shoot_projectile(atom/caller, atom/target, atom/location, params, obj/projectile/projectile_to_use, var/damagetype/damage_type_to_use, var/icon_pos_x=0, var/icon_pos_y=0, var/accuracy_loss=0, var/projectile_speed_to_use=12, var/bullet_count_to_use=1, var/bullet_color="#FFFFFF", var/view_punch=0, var/damage_multiplier=1, var/desired_iff_tag, var/desired_loyalty_tag, var/desired_inaccuracy_modifier=1, var/base_spread = 1, var/penetrations_left=0)
	if(!target && !location)
		CRASH("shoot_projectile called without a target or location.")

	var/turf/T = get_turf(caller ? caller : src)
	var/target_x = (target ? target.x : location.x) * TILE_SIZE + icon_pos_x
	var/target_y = (target ? target.y : location.y) * TILE_SIZE + icon_pos_y

	var/diff_x = target_x - (T.x * TILE_SIZE)
	var/diff_y = target_y - (T.y * TILE_SIZE)

	var/new_angle = ATAN2(diff_x, diff_y)
	new_angle += RAND_PRECISE(-accuracy_loss, accuracy_loss) * 90

	var/list/projectiles = list()
	for(var/i = 1; i <= bullet_count_to_use; i++)
		var/x_offset = cos(new_angle)
		var/y_offset = sin(new_angle)

		var/obj/projectile/P = new projectile_to_use(T, x_offset, y_offset)
		P.angle = new_angle
		P.float_speed = projectile_speed_to_use
		//P.damage_type = damage_type_to_use
		P.color = bullet_color
		//P.blamed = caller
		//P.damage_multiplier = damage_multiplier
		//P.penetrations_left = penetrations_left

		projectiles += P

	return projectiles
