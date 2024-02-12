/datum/ai_behavior/sequence
	description = "Executes child behaviors in sequence, stops on first failure."

/datum/ai_behavior/sequence/execute(mob/owner)
	//. = TRUE
	for(var/datum/ai_behavior/child in children)
		if(!child.execute(owner))
			//. = FALSE
			//break
			return FALSE
	//return .
	return TRUE

/datum/ai_behavior/sequence/flee_when_low_health
	description = "Flees when health is low."

/datum/ai_behavior/sequence/flee_when_low_health/New()
	children += new /datum/ai_behavior/condition/low_health()
	children += new /datum/ai_behavior/action/flee_from_aggressor()

/datum/ai_behavior/sequence/advanced_flee
	description = "(Advanced) Flees when health is low."

/datum/ai_behavior/sequence/advanced_flee/New()
	var/datum/ai_behavior/condition_low_health = new /datum/ai_behavior/condition/low_health()
	var/datum/ai_behavior/decorator/decorator_distance_check = new /datum/ai_behavior/decorator/check_aggressor_distance()
	decorator_distance_check.child = new /datum/ai_behavior/action/flee_from_aggressor()
	children += condition_low_health
	children += decorator_distance_check