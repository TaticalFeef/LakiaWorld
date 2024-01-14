/atom/
	var/attack_next //Quando vai liberar o ataque
	var/attack_cooldown = 5 //cooldown do ataque

	var/datum/health/health // vida!

	var/initialized = FALSE

/atom/New()
	. = ..()
	non_initialized_atoms |= src

/atom/Destroyed()
	. = ..()
	if(health)
		ZDEL_NULL(health)

/atom/proc/Initialize()
	if(initialized)
		return FALSE
	initialized = TRUE
	return TRUE

/atom/proc/MouseDrop_T()
	return TRUE

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/proc/examine()
	return desc