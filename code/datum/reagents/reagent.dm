/datum/reagent
	var/name = "Unknown Reagent"
	var/id = "unknown"
	var/color = "#FFFFFF"
	var/state = REAGENT_STATE_LIQUID
	var/volume = 0

/datum/reagent/proc/process(datum/component/reagent_holder/holder, volume)
	return

/datum/reagent/proc/react_with_turf(turf/T, volume)
	return

/datum/reagent/proc/react_with_obj(obj/O, volume)
	return

/datum/reagent/proc/react_with_mob(mob/living/M, volume)
	return

/datum/reagent/proc/react_with_reagent(datum/reagent/other, datum/component/reagent_holder/holder, volume)
	return

/datum/reagent/water
	name = "Water"
	id = "h2o"
	color = "#0000FF"

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "h"
	color = "#CCCCCC"
	state = REAGENT_STATE_GAS

/datum/reagent/heal_potion
	name = "Heal Potion"
	color = "#FF00FF"

/datum/reagent/heal_potion/process(datum/component/reagent_holder/holder, volume)
	if(istype(holder.owner, /mob/living/human))
		var/mob/living/human/H = holder.owner
		//H.health.adjust(volume) // heal volume
		to_chat(world,"we doing!")

/datum/reagent/explosion
	name = "Explosion"
	id = "boom"

/datum/reagent/explosion/process(datum/component/reagent_holder/holder, volume)
	to_chat("world","cuziii")
	holder.remove_reagent(src)