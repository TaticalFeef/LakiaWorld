/atom/proc/add_modifier(datum/modifier/new_modifier)
	if(istype(new_modifier))
		active_modifiers += new_modifier
		new_modifier.apply_effect(src)

/atom/proc/remove_modifier(modifier_name)
	for(var/datum/modifier/M in active_modifiers)
		if(M.name == modifier_name)
			M.remove_effect(src)
			active_modifiers -= M
			zDel(M)
			break