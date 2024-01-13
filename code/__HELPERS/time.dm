var/global/last_time = 0
var/global/midnight_rollovers = 0

/proc/true_time()
	if(world.timeofday < last_time)
		midnight_rollovers++
	last_time = world.timeofday
	return (midnight_rollovers*10*60*60*24) + world.timeofday