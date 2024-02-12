/datum/atom_stats
    var/list/stats = list(STAT_BASE = list(), STAT_ADDITIONAL = list(), STAT_TEMP = list())

/datum/atom_stats/New()
	. = ..()
	initialize_base_stats()

/datum/atom_stats/proc/initialize_base_stats()
	set_stat(STAT_STRENGTH, 0, STAT_BASE)
	set_stat(STAT_AGILITY, 0, STAT_BASE)
	set_stat(STAT_INTELLIGENCE, 0, STAT_BASE)
	set_stat(STAT_DEXTERITY, 0, STAT_BASE)
	set_stat(STAT_CHARISMA, 0, STAT_BASE)
	set_stat(STAT_ARMOR, 0, STAT_BASE)

/datum/atom_stats/proc/set_stat(stat_name, value, stat_type = STAT_BASE)
	stats[stat_type][stat_name] = max(0, value)

/datum/atom_stats/proc/get_stat(stat_name, stat_type = STAT_BASE, sum = TRUE)
	if(sum)
		var/total = 0
		for(var/_stat_type in stats)
			total += stats[_stat_type][stat_name] ? stats[_stat_type][stat_name] : 0
		return total
	return stats[stat_type][stat_name] 

/datum/atom_stats/proc/increment_stat(stat_name, value, stat_type = STAT_BASE)
	stats[stat_type][stat_name] = get_stat(stat_name) + value

/datum/atom_stats/proc/decrement_stat(stat_name, value, stat_type = STAT_BASE)
	stats[stat_type][stat_name] = max(0, get_stat(stat_name) - value)

/datum/atom_stats/proc/combine_with(datum/atom_stats/other, stat_type = STAT_ADDITIONAL)
	for(var/stat_name in other.stats[STAT_BASE])
		stats[stat_type][stat_name] = get_stat(stat_name, stat_type, FALSE) + other.get_stat(stat_name)

/datum/atom_stats/proc/negate_stats(stat_type = STAT_TEMP)
	var/datum/atom_stats/N = new
	for(var/stat_name in stats[stat_type])
		N.stats[stat_type][stat_name] = -get_stat(stat_name, stat_type, FALSE)
	return N