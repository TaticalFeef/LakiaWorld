SUBSYSTEM_DEF(living)

/subsystem/living
	name = "Vivos"
	var/list/mobs_list = list()
	var/list/mobs_with_client = list()
	tick_rate = 5

/subsystem/living/process()
	process_mobs()
	return TRUE

/subsystem/living/proc/process_mobs()
	for(var/mob/living/M in mobs_list)
		if(M)
			M.Life()

/subsystem/living/proc/add_mob(mob/living/M)
	if(istype(M))
		mobs_list |= M
		if(M.client)
			mobs_with_client |= M

/subsystem/living/proc/remove_mob(mob/living/M)
	mobs_list -= M
	if(M.client)
		mobs_with_client -= M

/mob/living/New()
	. = ..()
	SSliving.add_mob(src)

/mob/living/Destroyed()
	. = ..()
	SSliving.remove_mob(src)
