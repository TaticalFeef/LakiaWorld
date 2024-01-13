#define GRID_CELL_SIZE 10

// grid cell
/datum/grid_cell
	var/list/turfs = list()

// spatial grid
/datum/grid_system
    var/list/grid_cells = list()

/datum/grid_system/New(map_width, map_height)
	var/cell_count_x = ceil(map_width / GRID_CELL_SIZE)
	var/cell_count_y = ceil(map_height / GRID_CELL_SIZE)
	for(var/x = 1 to cell_count_x)
		for(var/y = 1 to cell_count_y)
			grid_cells["[x]-[y]"] = new /datum/grid_cell()

/datum/grid_system/proc/add_turf(turf/T)
	var/cell_x = ceil(T.x / GRID_CELL_SIZE)
	var/cell_y = ceil(T.y / GRID_CELL_SIZE)
	var/datum/grid_cell/cell = grid_cells["[cell_x]-[cell_y]"]
	cell.turfs += T

/datum/grid_system/proc/get_cells_near_players()
	var/list/nearby_cells = list()
	for(var/mob/P in SSliving.mobs_with_client)
		var/cell_x = ceil(P.x / GRID_CELL_SIZE)
		var/cell_y = ceil(P.y / GRID_CELL_SIZE)
		nearby_cells += grid_cells["[cell_x]-[cell_y]"]
	return nearby_cells