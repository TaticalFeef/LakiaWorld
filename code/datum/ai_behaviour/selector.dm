/datum/ai_behavior/selector
  description = "Executes child behaviors until one succeeds."

/datum/ai_behavior/selector/execute(mob/owner)
	for(var/datum/ai_behavior/child in children)
		if(child.execute(owner))
			return TRUE
	return FALSE

/datum/ai_behavior/selector/main_ai_behavior/New()
	children += new /datum/ai_behavior/sequence/advanced_flee()
	children += new /datum/ai_behavior/action/move_randomly()