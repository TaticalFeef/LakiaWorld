/obj/item/equipable
	var/equipped = FALSE
	var/stats_type = /datum/atom_stats/equipable

/obj/item/equipable/Initialize()
	..()
	stats = new stats_type(src)

/obj/item/equipable/proc/equip(atom/wearer)
	if(equipped)
		return FALSE
	equipped = TRUE
	wearer.apply_stats(stats)
	return TRUE

/obj/item/equipable/proc/unequip(atom/wearer)
	if(!equipped)
		return FALSE
	equipped = FALSE
	wearer.apply_stats(stats.negate_stats())
	return TRUE
