/atom/proc/attack(atom/target)
	if(!can_attack(target))
		return FALSE

	face_atom(target)
	var/datum/damage_instance/DI = calculate_damage(target)
	if(DI)
		SSdamage.queue_damage(DI)
	apply_special_effects(target)
	update_attack_cooldown()
	return TRUE

/atom/proc/can_attack(atom/target)
	if(attack_next > world.time || !target)
		return FALSE
	return TRUE

//calcular o dano causado por esse atom para target
//tem que retornar uma damage_instance
/atom/proc/calculate_damage(atom/target)
	var/damage_amount = 0             // quantidade do dano
	var/damage_type = DAMAGE_PHYSICAL // tipo de dano
	var/datum/damage_instance/DI = new
	DI.amount = damage_amount
	DI.damage_type = damage_type
	DI.victim = target
	DI.source = src

	return DI

/atom/proc/apply_damage(datum/damage_instance/DI)
	DI.victim.take_damage(DI)

/atom/proc/apply_special_effects(atom/target)

/atom/proc/update_attack_cooldown()
	attack_next = world.time + attack_cooldown

/atom/proc/take_damage(datum/damage_instance/DI)
	if(health)
		health.apply_damage(DI)
		return TRUE
	return FALSE

/atom/proc/is_alive()
	if(health)
		return health.is_alive()
	return TRUE