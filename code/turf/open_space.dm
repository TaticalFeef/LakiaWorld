//cair pro inferno
/turf/open_space/
	name = "Open Space"

/turf/open_space/Enter(atom/movable/A)
	if(!..())
		return FALSE
	var/z_below = z - 1 
	if(z_below < 1)
		return TRUE
	var/turf/below = locate(x, y, z_below)
	if(below && is_type_in_list(below, typesof(/turf/open_space)))
		A.Move(below)
	else if(below)
		A.Move(below)
	return TRUE 
