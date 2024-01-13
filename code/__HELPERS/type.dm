proc/deg2rad(deg)
	return deg * (PI / 180)

/proc/type2parent(child)
	var/string_type = "[child]"
	var/last_slash = findlasttext(string_type, "/")
	if(last_slash == 1)
		switch(child)
			if(/datum)
				return null
			if(/obj, /mob)
				return /atom/movable
			if(/area, /turf)
				return /atom
			else
				return /datum
	return text2path(copytext(string_type, 1, last_slash))

/proc/file2list(filename, seperator="\n", trim = TRUE)
	if(trim)
		return splittext(trim(file2text(filename)),seperator)
	return splittext(file2text(filename),seperator)