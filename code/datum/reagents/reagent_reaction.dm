/datum/reagent_reaction
	var/id
	var/list/products = list()
	var/volume_ratio = 1

/datum/reagent_reaction/proc/trigger_reaction(datum/component/reagent_holder/holder, volume)
	for(var/reagent_type in products)
		var/product_volume = volume * volume_ratio
		holder.add_reagent(new reagent_type(), product_volume)

/datum/reagent_reaction/explosion
	id = "boooooom"
	products = list(/datum/reagent/explosion)
	volume_ratio = 2