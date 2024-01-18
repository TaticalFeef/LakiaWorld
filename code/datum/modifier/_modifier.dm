#define MODIFIER_PASSIVE "mod_passive"
#define MODIFIER_ACTIVE "mod_active"
#define MODIFIER_TRIGGERED "mod_triggered"

/datum/modifier
	var/name
	var/description
	var/icon
	var/effect_type  // Passive, Active, Triggered, etc.
	var/duration
	var/active = FALSE

/datum/modifier/proc/apply_effect(mob/living/target)
	return

/datum/modifier/proc/remove_effect(mob/living/target)
	return
