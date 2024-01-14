SUBSYSTEM_DEF(atom_initializer)
    name = "Atom Initializer"
    priority = 50
    tick_rate = 2

/subsystem/atom_initializer/process()
	var/batch_size = 100

	for(var/i = 1 to min(batch_size, length(non_initialized_atoms)))
		var/atom/A = non_initialized_atoms[i]
		if(!A || A.initialized)
			continue
		A.Initialize()

	non_initialized_atoms.Cut(1, min(batch_size + 1, length(non_initialized_atoms) + 1))

	return TRUE