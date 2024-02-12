/datum/ai_behavior/action
  description = "A specific action to be performed by the AI."

/datum/ai_behavior/action/move_randomly
  description = "Se move a um turf adjacente."

/datum/ai_behavior/action/move_randomly/execute(mob/owner)
	var/list/possible_moves = get_adjacent_open_tiles(owner)
	if(possible_moves.len)
		move_mob_to(owner, pick(possible_moves))
		return TRUE
	return FALSE

/datum/ai_behavior/action/flee_from_aggressor
	description = "Corre do ultimo agressor."

/datum/ai_behavior/action/flee_from_aggressor/execute(mob/living/owner)
	if(!owner.last_aggressor)
		return FALSE

	var/turf/escape_target = get_step_away(owner, owner.last_aggressor, 100)//find_flee_target(owner, owner.last_aggressor)

	if(escape_target)
		move_mob_to(owner, escape_target)
		return TRUE

	return FALSE


proc/get_adjacent_open_tiles(mob/m)
	var/list/turfs = list()
	for(var/turf/t in view(m,1))
		if(!t.density)
			turfs += t
		continue
	return turfs

proc/move_mob_to(mob/m, turf/t)
	walk_towards(m, t)

proc/find_flee_target(mob/fleeing_mob, mob/aggressor)
	return get_step_away(fleeing_mob, aggressor, 1)

	var/turf/safe_turf = null

	for(var/i = 1, i <= 8, i++)
		var/turf/possible_safe_turf = get_step_away(fleeing_mob, aggressor, i)
		if(possible_safe_turf && !possible_safe_turf.density)
			safe_turf = possible_safe_turf
			break

	return safe_turf

/mob/living/proc/can_see(atom/target)
	return TRUE

	var/max_sight_range = 10
	if(get_dist(src, target) > max_sight_range)
		return FALSE

	var/turf/start = get_turf(src)
	var/turf/end = get_turf(target)
	var/list/ray = getline(start, end)

	for(var/turf/T in ray)
		if(T.density)
			return FALSE

	return TRUE

proc/getline(turf/start, turf/end)
	var/list/line = list()
	var/dx = abs(end.x - start.x)
	var/dy = abs(end.y - start.y)
	var/sx = start.x < end.x ? 1 : -1
	var/sy = start.y < end.y ? 1 : -1
	var/err = (dx>dy ? dx : -dy)/2
	var/e2

	var/current_x = start.x
	var/current_y = start.y

	while (current_x != end.x || current_y != end.y)
		line += locate(current_x, current_y, start.z)
		e2 = err
		if (e2 > -dx)
			err -= dy
			current_x += sx
		if (e2 < dy)
			err += dx
			current_y += sy

	line += end
	return line
