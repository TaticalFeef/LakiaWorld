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
		switch(DI.damage_type)
			if(DAMAGE_PHYSICAL)
				current_health -= DI.amount
			if(DAMAGE_MAGICAL)
				current_health -= DI.amount / 2 //meme
	if(current_health <= 0)
		handle_death()

/datum/health/proc/handle_death()
	return zDel(owner)

/datum/health/proc/is_alive()
	return current_health > 0