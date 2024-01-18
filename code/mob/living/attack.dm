/mob/living/proc/is_attack_mode()
	return TRUE

/mob/living/attack(atom/target)
	var/obj/item/held_item = get_held_item()

	if(!can_attack(target))
		return FALSE

	if(!held_item || !istype(target, /mob/living))
		return //..()

	if(!can_attack_target(target))
		return FALSE

	face_atom(target)

	var/datum/damage_instance/DI = held_item.calculate_damage(target)

	for(var/datum/modifier/mod in active_modifiers)
		mod.apply_effect(target, DI)

	if(DI)
		DI.victim = target
		DI.source = src
		SSdamage.queue_damage(DI)
		animate_attack_effect(held_item, target)
		apply_special_effects(target)
		update_attack_cooldown()
		attack_animation(target)
	return TRUE

/mob/living/proc/can_attack_target(atom/target)
	if(!istype(target, /mob/living))
		return FALSE
	if(get_dist(src, target) > 1)
		return FALSE
	return TRUE

/mob/living/proc/animate_attack_effect(obj/item/held_item, atom/target)
	if(!held_item || !target)
		return

	attack_effect = image(held_item.icon, src, held_item.icon_state)
	attack_effect.layer = LAYER_EFFECT
	attack_effect.plane = PLANE_EFFECT

	var/end_x = target.pixel_x
	var/end_y = target.pixel_y
	var/direction = get_dir(src, target)

	if(direction & NORTH)
		end_y += 32
	else if(direction & SOUTH)
		end_y -= 32

	if(direction & EAST)
		end_x += 32
	else if(direction & WEST)
		end_x -= 32

	src.client.images += attack_effect
	animate(attack_effect, pixel_x = end_x, pixel_y = end_y, time = 4, alpha = 0)
	addtimer(CALLBACK(src, .proc/clear_effect, attack_effect), 4)

/mob/living/proc/clear_effect(image/attack_effect)
	if(client)
		client.images -= attack_effect
		ZDEL_NULL(attack_effect)

/mob/living/proc/attack_animation(atom/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)