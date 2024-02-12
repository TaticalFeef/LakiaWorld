/mob/living
	var/list/limbs = list()

/mob/living/proc/initialize_limbs()
	limbs["left arm"] = new /datum/limb(src, "left arm", 50)
	limbs["right arm"] = new /datum/limb(src, "right arm", 50)

/mob/living/proc/apply_damage_to_limb(limb_name, amount)
	var/datum/limb/target_limb = limbs[limb_name]
	if(target_limb)
		target_limb.apply_damage(amount)
		update_health()

/mob/living/proc/update_health()
	var/total_damage = 0
	for(var/datum/limb/L in limbs)
		total_damage += L.max_health - L.health
	health.current_health = health.max_health - total_damage

/mob/living/Initialize()
	. = ..()
	initialize_limbs()