SUBSYSTEM_DEF(stats_manager)
	name = "Stats"
	var/list/registered_atoms = list()

/subsystem/stats_manager/process()
	for(var/atom/A in registered_atoms)
		var/datum/atom_stats/S = A.stats
		if(!S)
			continue
		A.update_stats()
	return TRUE

/subsystem/stats_manager/proc/register_atom(atom/A)
	registered_atoms |= A

/subsystem/stats_manager/proc/unregister_atom(atom/A)
	registered_atoms -= A
