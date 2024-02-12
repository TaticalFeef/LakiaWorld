/datum/ai_behavior
	var/description = "Base AI Behavior"
	var/list/children = list()

/datum/ai_behavior/proc/execute(mob/owner)
	return FALSE