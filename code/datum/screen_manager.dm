#define HUD_SLOT_SIZE 1
#define HUD_SLOT_PADDING 0
#define HUD_GRID_COLUMNS 2

/datum/screen_manager
	var/mob/owner
	var/list/occupied_positions = list()

/datum/screen_manager/New(mob/_owner)
	owner = _owner

/datum/screen_manager/proc/add_to_screen(obj/hud_element,x,y)
	if(owner.client)
		owner.client.screen += hud_element
		if(x && y)
			hud_element.screen_loc = "[x],[y]"
			mark_position_occupied(x,y)

/datum/screen_manager/proc/position_element(obj/hud_element, var/index)
	var/row = (index - 1) / HUD_GRID_COLUMNS
	var/column = (index - 1) % HUD_GRID_COLUMNS

	var/x_offset = round((HUD_SLOT_SIZE + HUD_SLOT_PADDING) * column)
	var/y_offset = round((HUD_SLOT_SIZE + HUD_SLOT_PADDING) * row)

	var/screen_x = "WEST+[x_offset]"
	var/screen_y = "SOUTH+[y_offset]"

	while(is_position_occupied(screen_x, screen_y))
		x_offset += 1
		y_offset += 1
		screen_x = "WEST+[x_offset]"
		screen_y = "SOUTH+[y_offset]"

	hud_element.screen_loc = "[screen_x],[screen_y]"
	mark_position_occupied(screen_x, screen_y)

/datum/screen_manager/proc/is_position_occupied(var/screen_x, var/screen_y)
	return "[screen_x]-[screen_y]" in occupied_positions

/datum/screen_manager/proc/mark_position_occupied(var/screen_x, var/screen_y)
	occupied_positions += "[screen_x]-[screen_y]"