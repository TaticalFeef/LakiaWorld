/mob/living/human/ai
	var/datum/ai_behavior/behavior_tree

/mob/living/human/ai/Initialize()
	. = ..()
	/*
	var/datum/ai_behavior/sequence/ai_behaviors = new()

	ai_behaviors.children += new /datum/ai_behavior/sequence/flee_when_low_health()
	ai_behaviors.children += new /datum/ai_behavior/action/move_randomly()
	behavior_tree = ai_behaviors
	*/
	behavior_tree = new /datum/ai_behavior/selector/main_ai_behavior()

	SSai_processor.register_ai(src)