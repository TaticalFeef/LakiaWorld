/datum/spell
	var/name = "Generic Spell"
	var/mob/caster
	var/cooldown_duration = 10
	var/mana_cost = 0
	var/last_cast_time

/datum/spell/New(atom/_caster)
	caster = _caster

/datum/spell/proc/is_active()
	return FALSE

/datum/spell/proc/cast()
	last_cast_time = world.time

/datum/spell/proc/can_cast()
	if(world.time < last_cast_time + cooldown_duration * 10)
		return FALSE
	return TRUE

/datum/spell/proc/consume_resources()
	if(caster.mana >= mana_cost)
		caster.mana -= mana_cost
		return TRUE
	return FALSE

/atom/
	var/mana = 100

