SUBSYSTEM_DEF(reagents)
	name = "Reagent Processor"
	tick_rate = 5
	var/list/datum/component/reagent_holder/registered_holders = list()
	var/list/reactions = list(
		"h2o-h" = /datum/reagent_reaction/explosion/
	)
	var/a

/subsystem/reagents/Initialize()
	. = ..()
	for(var/id in reactions)
		var/datum/reagent_reaction/b = reactions[id]
		reactions[id] = new b

/subsystem/reagents/process()
	for(var/datum/component/reagent_holder/holder in registered_holders)
		if(holder)
			holder.process_reagents()
	return TRUE

/subsystem/reagents/proc/register_holder(datum/component/reagent_holder/holder)
	if(holder && !registered_holders[holder])
		registered_holders += holder

/subsystem/reagents/proc/unregister_holder(datum/component/reagent_holder/holder)
	registered_holders -= holder
