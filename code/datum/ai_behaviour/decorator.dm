/datum/ai_behavior/decorator
	description = "Modifies the execution of child behaviors."
	var/datum/ai_behavior/child

/datum/ai_behavior/decorator/execute(mob/owner)
	if(child)
		return child.execute(owner)
	return FALSE

/datum/ai_behavior/decorator/repeat
	description = "Repeats the child behavior a specified number of times."
	var/repeat_count = 1

/datum/ai_behavior/decorator/repeat/execute(mob/owner)
	for(var/i = 1 to repeat_count)
		if(!..())
			return FALSE
	return TRUE

/datum/ai_behavior/decorator/check_aggressor_distance
	var/distance_threshold = 3

/datum/ai_behavior/decorator/check_aggressor_distance/execute(mob/living/owner)
	if(owner.last_aggressor && get_dist(owner, owner.last_aggressor) <= distance_threshold)
		return child.execute(owner)
	return FALSE