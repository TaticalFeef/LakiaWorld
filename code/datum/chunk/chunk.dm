/datum/chunk
	var/list/turfs = list()
	var/chunk_x
	var/chunk_y
	var/z_level

/datum/chunk/proc/update_atmosphere()

/datum/chunk/proc/initialize_turfs()
	for(var/i = (chunk_x - 1) * 16 + 1, i <= chunk_x * 16, i++)
		for(var/j = (chunk_y - 1) * 16 + 1, j <= chunk_y * 16, j++)
			var/turf/current = locate(i, j, z_level)
			if(current)
				turfs += current