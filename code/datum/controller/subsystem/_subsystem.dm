/subsystem/
	var/name = "Base Subsystem"
	var/desc = "Subsystem for base functions. This message should not be visible."

	var/tick_rate = -1 // Tick delay for the subsystem, in frames. -1 to disable, 0 for custom behavior.
	var/priority = 0 // High number = runs later.
	var/next_run = 0 // When the subsystem should run next.
	var/life_time = 0 // Time it takes to complete a life cycle.

	var/tick_usage_max = DEFAULT_TICK_USAGE

	var/debug = FALSE

	var/overtime_count = 0
	var/overtime_max = 10

	var/use_time_dilation = TRUE

	var/initialized = FALSE
	var/generated = FALSE
	var/finalized = FALSE

	var/run_failures = 0

	var/bypass_single_life_limit = FALSE

/subsystem/proc/Initialize()
	if(initialized)
		CRASH("Error: [src.get_debug_name()] was initialized twice!")
		return TRUE
	return TRUE

/subsystem/proc/Generate()
	if(generated)
		CRASH("Error: [src.get_debug_name()] was generated twice!")
		return TRUE
	return TRUE

/subsystem/proc/Finalize()
	if(finalized)
		CRASH("Error: [src.get_debug_name()] was finalized twice!")
		return TRUE
	all_subsystems += src
	return TRUE

/subsystem/proc/unclog(var/mob/caller)
	if(caller.ckey)
		world << "Notice: Subsystem [name] has been restarted by [caller.ckey]."
	else
		world << "Notice: Subsystem [name] has been restarted automatically by the server's safety system."
	return TRUE

/subsystem/New(var/desired_loc)
	if(tick_rate > 0)
		tick_rate = FLOOR(tick_rate,1)
		if(!tick_rate)
			tick_rate = 1
	return ..()

/subsystem/proc/PreInitialize()

/subsystem/proc/process()
	return FALSE

/subsystem/proc/Recover()
	return TRUE

/subsystem/proc/on_shutdown()
	return TRUE

/subsystem/proc/process_loop()
	set background = TRUE
	while(tick_rate > 0 && master_controller.processing)
		if(tick_rate > 0 && overtime_count < overtime_max)
			if(master_controller.processing && tick_usage_max > 0 && world.tick_usage > tick_usage_max)
				overtime_count++
				sleep(TICK_LAG)
				continue
		overtime_count = 0
		var/result = process()
		if(result == null)
			run_failures++
			if(run_failures >= 3)
				run_failures = 0
				unclog()
			sleep(10)
			continue
		else if(result == FALSE || tick_rate <= 0)
			tick_rate = 0
			break
		run_failures = 0
		sleep(TICKS_TO_DECISECONDS(tick_rate))