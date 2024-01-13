/var/list/turf/turfs = list()

/turf/New()
	. = ..()
	turfs += src

/turf/Del()
	turfs -= src
	. = ..()
