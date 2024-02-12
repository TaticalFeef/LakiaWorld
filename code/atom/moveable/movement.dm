/atom/movable
	var/base_speed = 1
	var/next_move_time = 0

/atom/movable/Move(NewLoc, Dir=0, step_x=0, step_y=0)
	if(world.time < next_move_time)
		return FALSE
	var/atom/_new_loc = NewLoc
	var/atom/_old_loc = loc

	if(!can_move())
		SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_MOVE, FALSE)
		return FALSE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CAN_MOVE, TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, _new_loc)
	if(!pre_move(_new_loc))
		return FALSE

	. = ..(NewLoc,Dir,step_x,step_y)

	if(.)
		next_move_time = world.time + compute_movement_delay()
		post_move(_old_loc)
		SEND_SIGNAL(src, COMSIG_MOVABLE_POST_MOVE, _new_loc)

/atom/movable/proc/compute_movement_delay()
	return 1 / base_speed

/atom/movable/proc/can_move()
	switch(anchored)
		if(0)
			return TRUE
		if(1)
			return FALSE
		if(2)
			return FALSE
	return FALSE

/atom/movable/proc/pre_move(var/new_loc)
	// Lógica antes de se mover
	// Da pra por checks, eventos, triggers aqui
	// return FALSE pra cancelar o movimento
	// return TRUE  pra continuar o movimento
	return TRUE

/atom/movable/proc/post_move(var/old_loc)
	// Mesmo que pre_move mas depois q se mexe

/atom/movable/proc/force_move(var/atom/new_loc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_FORCE_MOVE, new_loc)

	var/atom/old_loc = loc
	var/turf/old_loc_as_turf = is_turf(old_loc) ? old_loc : null
	var/turf/new_loc_as_turf = is_turf(new_loc) ? new_loc : null

	if(old_loc)
		old_loc.Exited(src, new_loc)
		if(old_loc && src.density && !old_loc_as_turf)
			for(var/k in old_loc.contents)
				var/atom/movable/M = k
				if(M == src)
					continue
				if(!M.density)
					continue
				M.Uncrossed(src)

	/*if(is_turf(new_loc) && new_loc.density)
		handle_turf_collision(new_loc)
	else
		loc = new_loc
		process_move(old_loc, new_loc)*/
	loc = new_loc

	if(new_loc)
		new_loc.Entered(src, old_loc)
		if(new_loc && src.density && !new_loc_as_turf)
			for(var/k in new_loc.contents)
				var/atom/movable/M = k
				if(M == src)
					continue
				if(!M.density)
					continue
				M.Crossed(src)

	return TRUE

/atom/movable/proc/handle_turf_collision(var/turf/dense_loc)

/atom/movable/proc/process_move(var/atom/old_loc, var/atom/new_loc)