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

		var/damage_reduction = 0
		var/old_health = current_health

		if(owner?.stats)
			damage_reduction = owner.stats.get_stat(STAT_ARMOR)

		switch(DI.damage_type)
			if(DAMAGE_PHYSICAL, DAMAGE_MAGICAL)
				var/effective_damage = max(0, DI.amount - damage_reduction)
				current_health -= effective_damage
			if(DAMAGE_TRUE)
				current_health -= DI.amount

		if(old_health != current_health)
			create_damage_popup(DI.damage_type, old_health-current_health)
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