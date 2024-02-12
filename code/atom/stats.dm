/atom/proc/update_stats()
	return TRUE

/atom/proc/apply_stats(datum/atom_stats/new_stats)
	if(!stats)
		stats = new /datum/atom_stats(src)
	stats.combine_with(new_stats)
	update_stats()
	return TRUE

/atom/proc/remove_stats(datum/atom_stats/old_stats)
	if(stats && old_stats)
		stats.combine_with(old_stats.negate_stats(STAT_ADDITIONAL))
		update_stats()
		return TRUE
	return FALSE

/atom/proc/steal_stats(atom/target, list/stat_names)
	if(!istype(target))
		return FALSE
	for(var/stat_name in stat_names)
		var/stat_value = target.stats.get_stat(stat_name)
		target.stats.decrement_stat(stat_name, stat_value)
		stats.increment_stat(stat_name, stat_value)

/atom/proc/reduce_stats(atom/target, list/stat_reductions)
	if(!istype(target))
		return FALSE
	for(var/stat_name in stat_reductions)
		var/reduction_amount = stat_reductions[stat_name]
		target.stats.decrement_stat(stat_name, reduction_amount)
