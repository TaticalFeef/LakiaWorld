/mob/living/proc/format_stat_output(stat_name)
	if(stats)
		var/base_stat = stats.stats[STAT_BASE][stat_name] ? stats.stats[STAT_BASE][stat_name] : 0
		var/additional_stat = stats.stats[STAT_ADDITIONAL][stat_name] ? stats.stats[STAT_ADDITIONAL][stat_name] : 0
		var/temp_stat = stats.stats[STAT_TEMP][stat_name] ? stats.stats[STAT_TEMP][stat_name] : 0
		var/total_additional = additional_stat + temp_stat
		return "[base_stat] (+ [total_additional])"
	return "-"