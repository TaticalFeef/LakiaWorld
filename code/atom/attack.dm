/atom/proc/attack(atom/target)
	if(!can_attack(target))
		return FALSE

	face_atom(target)
	var/damage = calculate_damage(target)
	apply_damage(target, damage)
	apply_special_effects(target)
	update_attack_cooldown()
	return TRUE

/atom/proc/can_attack(atom/target)
	if(attack_next > world.time || !target)
		return FALSE
	return TRUE

/atom/proc/calculate_damage(atom/target)
	var/damage = 0
	return damage

/atom/proc/apply_damage(atom/target, var/damage)
	target.take_damage(damage)

/atom/proc/apply_special_effects(atom/target)

/atom/proc/update_attack_cooldown()
	attack_next = world.time + attack_cooldown

/atom/proc/take_damage(damage, damage_type) // usar /datum/damage_instance