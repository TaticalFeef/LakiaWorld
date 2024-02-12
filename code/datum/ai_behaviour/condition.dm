/datum/ai_behavior/condition
	description = "Evaluates a condition."

/datum/ai_behavior/condition/execute(mob/owner)
	return check(owner)

/datum/ai_behavior/condition/proc/check(mob/owner)
	return FALSE

/datum/ai_behavior/condition/low_health
	description = "Checa se a vida do mob está abaixo de um certo nível."
	var/health_divisor = 2

/datum/ai_behavior/condition/low_health/check(mob/owner)
	return (owner.health.current_health <= (owner.health.max_health / health_divisor))