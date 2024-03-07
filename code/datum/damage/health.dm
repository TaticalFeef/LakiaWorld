/datum/health
	var/current_health
	var/max_health
	var/atom/owner

/datum/health/New(var/max_hp, atom/_owner)
	max_health = max_hp
	current_health = max_health
	owner = _owner

/datum/health/proc/apply_damage(datum/damage_instance/DI)
	if(DI && !DI.zdeleting)
		if(DI.source && istype(owner, /mob/living))
			var/mob/living/O = owner
			O.last_aggressor = DI.source

			var/def_divisor = 2
			var/old_health = current_health

			var/armor = owner?.stats ? owner.stats.get_stat(STAT_ARMOR) : 0

			switch(DI.damage_type)
				if(DAMAGE_PHYSICAL, DAMAGE_MAGICAL)
					var/effective_damage = (DI.amount) / (1 + (armor / def_divisor))
					current_health -= effective_damage
				if(DAMAGE_TRUE)
					current_health -= DI.amount

			if(old_health != current_health)
				create_damage_popup(DI.damage_type, old_health - current_health)
			else
				create_damage_popup(DI.damage_type, 0)

	if(current_health <= 0)
		handle_death()

/datum/health/proc/handle_death()
	return zDel(owner)

/datum/health/proc/is_alive()
	return current_health > 0

/datum/health/proc/create_damage_popup(damage_type, amount)
	var/damage_color = get_damage_color(damage_type)
	var/damage_text = "<span style='color: [damage_color];'>[amount]</span>"
	new /obj/effect/chat_text(owner, damage_text)

/datum/health/proc/get_damage_color(damage_type)
	switch(damage_type)
		if(DAMAGE_PHYSICAL)
			return DAMAGE_COLOR_PHYSICAL
		if(DAMAGE_MAGICAL)
			return DAMAGE_COLOR_MAGICAL
		if(DAMAGE_TRUE)
			return DAMAGE_COLOR_TRUE
	return DAMAGE_COLOR_TRUE