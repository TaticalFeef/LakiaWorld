/obj/item/equipable
	var/equipped = FALSE
	var/stats_type = /datum/atom_stats/equipable

/obj/item/equipable/Initialize()
	..()
	stats = new stats_type(src)

/obj/item/equipable/proc/equip(atom/wearer)
	if(equipped || !wearer)
		return FALSE
	if(wearer.apply_stats(stats))
		equipped = TRUE
		return TRUE
	return FALSE

/obj/item/equipable/proc/unequip(atom/wearer)
	if(!equipped || !wearer)
		return FALSE
	if(wearer.remove_stats(stats))
		equipped = FALSE
		return TRUE
	return FALSE
