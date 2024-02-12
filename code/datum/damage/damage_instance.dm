/proc/calculate_damage(amount, type, tick_rate, duration, atom/source, atom/target, list/modifiers)
	var/dmg_amount = amount
	var/dmg_type = type
	var/datum/damage_instance/DI = new
	DI.amount = dmg_amount
	DI.damage_type = dmg_type
	DI.victim = target
	DI.source = source
	DI.tick_rate = tick_rate
	DI.duration = duration

	for(var/datum/modifier/mod in modifiers)
		mod.apply_effect(target, DI)

	return DI

/proc/create_damage_instance(atom/source, atom/attacker, atom/target, list/modifiers)
	var/amount = 0
	var/type = DAMAGE_PHYSICAL
	var/tick_rate = 1
	var/duration = 1

	if(istype(source, /obj/item))
		var/obj/item/source_item = source
		amount = source_item.base_damage
		type = source_item.damage_type

		if(istype(source_item, /obj/item/equipable))
			var/obj/item/equipable/equipable_item = source_item
			if(equipable_item && equipable_item.stats)
				if(type == DAMAGE_PHYSICAL)
					amount = calculate_physical_damage(amount, equipable_item.stats, attacker)

	return calculate_damage(amount, type, tick_rate, duration, source, target, modifiers)

// base_damage + (base_damage * strength stat * multiplier)
/proc/calculate_physical_damage(base_damage, datum/atom_stats/item_stats, atom/attacker)
	var/mul_str = 0.2
	var/mul_agi = 0.1
	var/extra_damage = base_damage * (item_stats?.get_stat(STAT_STRENGTH) ? item_stats?.get_stat(STAT_STRENGTH) : 0) * mul_str

	if(istype(attacker, /mob/living))
		var/mob/living/living_attacker = attacker
		extra_damage += (living_attacker.stats?.get_stat(STAT_AGILITY) ? living_attacker.stats?.get_stat(STAT_AGILITY) : 0) * mul_agi

	return base_damage + extra_damage

/datum/damage_instance
	var/amount
	var/damage_type    // Physical, Magical, True, etc.
	var/elemental_type // Fire, Ice, etc.,
	var/critical

	var/atom/victim    // Pessoa recebendo o dano
	var/atom/source    // Quem ou oque causou o dano
	var/sourceless = FALSE

	var/status_effect  // Stun, Poison, etc.

	var/tick_rate      // De quando em quando aplicar o dano
	var/duration       // Duração total do dano
	var/tick_count     // Contador interno
	var/next_tick      // Próximo tick de dano

/datum/damage_instance/proc/damage_victim()
	if(victim && !victim.zdeleting && victim.health)
		victim.health.apply_damage(src)
	else
		return
