//GLOBAL_VAR_INIT(datum/chunk_manager/X, new)

/datum/chunk_manager/
	var/list/chunks = list() // cahve: "chunk_x-chunk_y-z", valor: datum/chunk

/datum/chunk_manager/proc/get_chunk(x,y, z)
	var/chunk_x = CEILING(x / 16, 1)
	var/chunk_y = CEILING(y / 16, 1)
	var/key = "[chunk_x]-[chunk_y]-[z]"

	if(!chunks[key])
		chunks[key] = new /datum/chunk(chunk_x, chunk_y, z)
		chunks[key].initialize_turfs()

	return chunks[key]

/datum/chunk_manager/proc/remove_chunk(datum/chunk/chunk)
    var/key = "[chunk.chunk_x]-[chunk.chunk_y]-[chunk.z_level]"
    chunks -= key
