var/global/list/occupied_turfs = list()
var/global/datum/maploader/map_loader = new()
var/global/list/ruin_map_contents = list()

/datum/ruin_generator
	var/ruin_dir
	var/list/ruin_maps = list()

/datum/ruin_generator/New(var/_ruin_dir)
	ruin_dir = _ruin_dir

	initialize_ruins()

/datum/ruin_generator/proc/initialize_ruins()
	var/list/files = flist(ruin_dir)

	for(var/filename in files)
		if(findtext(filename, ".dmm"))
			var/size = get_map_size(ruin_dir + filename)
			var/list/ruin_entry = list(ruin_dir + filename, size)
			ruin_maps += list(ruin_entry)
	cache_map_contents()

/datum/ruin_generator/proc/cache_map_contents()
	for(var/list/ruin_data in ruin_maps)
		var/map_path = ruin_data[1]
		ruin_map_contents[map_path] = file2text(map_path)

/datum/ruin_generator/proc/cache_ruin_areas(z_level, area_type)
	var/list/ruin_areas = list()

	for(var/area/A in world)
		if(istype(A, area_type) && A.z == z_level)
			ruin_areas += A
	return ruin_areas

/datum/ruin_generator/proc/generate_ruins(z_level, ruin_number, area_type)
	var/list/valid_turfs_per_size = generate_valid_turfs_list(z_level, area_type)
	var/no_valid_turfs = FALSE

	while(ruin_number > 0 && valid_turfs_per_size.len && !no_valid_turfs)
		var/list/ruin_data = pick(ruin_maps)
		var/map_path = ruin_data[1]
		var/list/size = ruin_data[2]

		var/list/valid_turfs = valid_turfs_per_size[map_path]
		if(!valid_turfs.len)
			no_valid_turfs = TRUE
			for(var/list/ruin_turfs in valid_turfs_per_size)
				if(ruin_turfs.len)
					no_valid_turfs = FALSE
					break

			if(no_valid_turfs)
				break
			else
				continue

		var/turf/random_turf = pick_n_pop(valid_turfs)
		if(random_turf && is_turf_suitable(random_turf, size))
			map_loader.load_map(map_path, random_turf.x, random_turf.y, z_level)
			update_valid_turfs(valid_turfs_per_size, random_turf, size)
			ruin_number--

	valid_turfs_per_size = null

/datum/ruin_generator/proc/generate_valid_turfs_list(z_level, area_type)
	var/list/valid_turfs_per_size = list()

	for(var/list/ruin_data in ruin_maps)
		var/map_path = ruin_data[1]
		var/list/size = ruin_data[2]
		var/list/valid_turfs = list()

		for(var/turf/T in area_type)
			if(T.z == z_level && istype(T.loc, area_type) && is_turf_suitable(T, size))
				valid_turfs += T

		valid_turfs_per_size[map_path] = valid_turfs

	return valid_turfs_per_size

/datum/ruin_generator/proc/is_turf_suitable(turf/T, list/size)
	var/width = size[1]
	var/height = size[2]

	if (T.x + width - 1 > world.maxx || T.y + height - 1 > world.maxy)
		return FALSE

	for(var/dx = 0 to width - 1)
		for(var/dy = 0 to height - 1)
			var/checked_x = T.x + dx
			var/checked_y = T.y + dy
			var/turf/checked_turf = locate(checked_x, checked_y, T.z)
			if(!checked_turf || checked_turf.loc != T.loc || occupied_turfs["[checked_x]-[checked_y]-[T.z]"])
				return FALSE
	return TRUE


/datum/ruin_generator/proc/update_valid_turfs(list/valid_turfs, turf/random_turf, list/size)
	var/width = size[1]
	var/height = size[2]

	for(var/x_offset = 0 to width - 1)
		for(var/y_offset = 0 to height - 1)
			var/turf_key = "[random_turf.x + x_offset]-[random_turf.y + y_offset]-[random_turf.z]"
			occupied_turfs[turf_key] = TRUE
			var/turf/T = locate(random_turf.x + x_offset, random_turf.y + y_offset, random_turf.z)
			valid_turfs -= T
	return valid_turfs

/datum/maploader
	var/dmm_suite/map_suite = new()

/datum/maploader/proc/load_map(map_path as text, x, y, z)
	var/map_text = ruin_map_contents[map_path]
	if (!map_text)
		map_text = file2text(map_path)
	return map_suite.read_map(map_text, x, y, z)