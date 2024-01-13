/proc/dir_to_angle(dir)
	switch(dir)
		if(NORTH)
			return 90
		if(SOUTH)
			return 270
		if(EAST)
			return 0
		if(WEST)
			return 180
		if(NORTHEAST)
			return 45
		if(NORTHWEST)
			return 135
		if(SOUTHEAST)
			return 315
		if(SOUTHWEST)
			return 225
	return 0