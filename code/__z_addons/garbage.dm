/proc/qdel(var/datum/thing)
	zDel(thing)

/datum/proc/Destroy()
	return TRUE

/datum/Destroyed()
	Destroy()
	. = ..()

/datum/proc/deleted()
	return 0
