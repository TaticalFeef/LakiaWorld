/datum/component/reagent_holder
	var/mob/living/owner
	var/list/datum/reagent/reagents = list()
	var/max_volume = 100

/datum/component/reagent_holder/proc/add_reagent(datum/reagent/R, volume)
	if(get_total_volume() + volume > max_volume)
		return FALSE

	if(!reagents[R.type])
		reagents[R.type] = new R.type()
		reagents[R.type].volume = 0

	reagents[R.type].volume += volume
	SSreagents.register_holder(src)
	return TRUE

/datum/component/reagent_holder/proc/remove_reagent(datum/reagent/R)
	if(R.type in reagents)
		reagents[R.type].volume -= R.volume
		if(reagents[R.type].volume <= 0)
			reagents -= R.type
	if(!reagents.len)
		SSreagents.unregister_holder(src)
	return TRUE

/datum/component/reagent_holder/proc/get_total_volume()
	var/total = 0
	for(var/datum/reagent/R in reagents)
		total += R.volume
	return total

/datum/component/reagent_holder/proc/process_reagents()
	for(var/reagent_type in reagents)
		var/datum/reagent/R = reagents[reagent_type]
		R.process(src, R.volume)

	var/list/reagent_types = reagents.Copy()
	for(var/reagent_type1 in reagent_types)
		for(var/reagent_type2 in reagent_types)
			if(reagent_type1 == reagent_type2) continue
			var/datum/reagent/R1 = reagents[reagent_type1]
			var/datum/reagent/R2 = reagents[reagent_type2]
			check_and_trigger_reaction(R1, R2, R1.volume)

/datum/component/reagent_holder/proc/react_with_reagent(datum/reagent/R, volume)
	return

/datum/component/reagent_holder/proc/empty(turf/target)
	for(var/datum/reagent/R in reagents)
		R.react_with_turf(target, R.volume)
	reagents = list()
	SSreagents.unregister_holder(src)

/datum/component/reagent_holder/proc/check_and_trigger_reaction(datum/reagent/R1, datum/reagent/R2, volume)
	var/reaction_id = "[R1.id]-[R2.id]"
	var/datum/reagent_reaction/r = SSreagents.reactions[reaction_id]

	if(r)
		var/limiting_volume = min(R1.volume, R2.volume)
		r.trigger_reaction(src, limiting_volume)
		src.remove_reagent(R1)
		src.remove_reagent(R2)

// -- human stomach
/datum/component/reagent_holder/stomach
	max_volume = 20

/mob/living/human/New()
	. = ..()
	AddComponent(/datum/component/reagent_holder/stomach)

/mob/living/human/proc/drink(datum/component/reagent_holder/source)
	GET_COMPONENT_FROM(stomach, /datum/component/reagent_holder/stomach, src)
	if(stomach)
		for(var/datum/reagent/R in source.reagents)
			if(stomach.add_reagent(R, R.volume))
				source.remove_reagent(R)
			else
				break