/datum/atom_stats/equipable/initialize_base_stats()
	. = ..()
	increment_stat(STAT_STRENGTH, 10, STAT_ADDITIONAL)
	increment_stat(STAT_AGILITY, 10, STAT_ADDITIONAL)
	increment_stat(STAT_ARMOR, 15, STAT_ADDITIONAL)