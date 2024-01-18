/datum/atom_stats
	var/strength = 0
	var/agility = 0
	var/intelligence = 0
	var/dexterity = 0
	var/charisma = 0

	var/expiration_time

	var/temporary = FALSE

	var/atom/owner

/datum/atom_stats/New(var/atom/_owner)
	owner = _owner
	SSstats_manager.register_atom(owner)

/datum/atom_stats/Destroyed()
	. = ..()
	SSstats_manager.unregister_atom(owner)
	owner = null

/datum/atom_stats/proc/set_stat(name, value)
	switch(name)
		if(STAT_STRENGTH)
			strength = max(0, value)
		if(STAT_AGILITY)
			agility = max(0, value)

/datum/atom_stats/proc/get_stat(name)
	switch(name)
		if(STAT_STRENGTH)
			return strength
		if(STAT_AGILITY)
			return agility
	return 0

/datum/atom_stats/proc/increment_stat(name, value)
	set_stat(name, get_stat(name) + value)

/datum/atom_stats/proc/decrement_stat(name, value)
	set_stat(name, get_stat(name) - value)

/datum/atom_stats/proc/combine_with(datum/atom_stats/other)
	strength += other.strength
	agility += other.agility
	intelligence += other.intelligence

/datum/atom_stats/proc/is_valid()
	if(expiration_time && world.time > expiration_time)
		return FALSE
	return TRUE

/datum/atom_stats/proc/negate_stats()
	var/datum/atom_stats/N = new /datum/atom_stats()
	N.strength = -src.strength
	N.agility = -src.agility
	N.intelligence = -src.intelligence
	N.temporary = TRUE
	return N

/datum/atom_stats/proc/log_stat_change(name, value)
	world.log << "[world.time]: Stat [name] changed to [value] in [src]"
