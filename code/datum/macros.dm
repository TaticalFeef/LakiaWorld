/macros
	var/client/owner
	var/list/macros = list(
		"W" = NORTH,
		"A" = WEST,
		"S" = SOUTH,
		"D" = EAST
	)

/macros/Destroyed()
	owner = null
	. = ..()

/macros/New(var/client/spawning_owner)
	owner = spawning_owner
	. = ..()

/macros/proc/on_pressed(button)
	if(!owner.mob.can_use_macros) return FALSE

	var/direction = macros[button]
	if(direction && !owner.mob.macro_moving)
		owner.mob.StartContinuousMove(direction)
		return TRUE
	return FALSE

/macros/proc/on_released(button)
	if(!owner.mob.can_use_macros) return FALSE

	if(macros[button] && owner.mob.macro_moving)
		owner.mob.StopContinuousMove()
		return TRUE
	return FALSE

/mob
	var/continuous_move_dir = null
	var/macro_moving = FALSE
	var/can_use_macros = TRUE

/mob/proc/StartContinuousMove(direction)
	if(macro_moving) return
	continuous_move_dir = direction
	macro_moving = TRUE
	while(macro_moving)
		Move(get_step(src, continuous_move_dir), continuous_move_dir)
		sleep(world.tick_lag)

/mob/proc/StopContinuousMove()
	macro_moving = FALSE

/mob/new_player
	can_use_macros = FALSE
