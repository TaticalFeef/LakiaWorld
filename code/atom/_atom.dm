/atom/
	var/attack_next //Quando vai liberar o ataque
	var/attack_cooldown = 5 //cooldown do ataque

	var/datum/health/health // vida!

	var/datum/atom_stats/stats

	var/list/datum/modifier/active_modifiers = list()

	var/initialized = FALSE

/atom/New()
	. = ..()
	non_initialized_atoms |= src

/atom/Destroyed()
	. = ..()
	if(health)
		ZDEL_NULL(health)
	if(stats)
		ZDEL_NULL(stats)

/atom/proc/Initialize()
	if(initialized)
		return FALSE
	initialized = TRUE
	return TRUE

/atom/proc/MouseDrop_T()
	return TRUE

/atom/proc/setDir(newdir)
	dir = newdir

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/proc/examine()
	return desc