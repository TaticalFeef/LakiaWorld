/proc/get_map_size(map_path as text)
	var/list/file_lines = file2list(map_path)
	var/map_start = FALSE
	var/width = 0
	var/height = 0

	for(var/line in file_lines)
		if(map_start && line == "\"}")
			break
		if(map_start)
			height++
			var/current_width = length(line)
			if(current_width > width)
				width = current_width
		if(findtext(line, "(1,1,1) = {\""))
			map_start = TRUE
			continue

	return list(width, height)