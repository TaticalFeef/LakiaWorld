SUBSYSTEM_DEF(GLOB)
	name = "Global Vars"
	var/list/global_initializations = list()
	var/list/built_globals = list()

GLOBAL_VAR_INIT(example_var, 422)

/subsystem/GLOB/New()
	var/subsystem/exclude_these = new
	var/list/controller_vars = exclude_these.vars.Copy()
	controller_vars["vars"] = null
	built_globals = controller_vars + list(NAMEOF(src, global_initializations))
	zDel(exclude_these)
	. = ..()

/subsystem/GLOB/Initialize()
	. = ..()
	var/list/global_procs = typesof(/subsystem/GLOB/proc)
	for(var/I in global_procs)
		call(src,I)()