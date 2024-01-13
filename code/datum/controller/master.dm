//o pai
var/global/datum/controller/game_controller/master_controller


var/actions_per_tick = 0
var/max_actions = 40
var/CPU_warning = 0

var/list/typepaths = list()

var/master_Processed = 0

/proc/CHECK_TICK()
	master_Processed += 1
	actions_per_tick += 1
	var/cpu_usage_factor = max(0, min(world.cpu, 100)) / 100
	var/action_threshold = max_actions - (cpu_usage_factor * (max_actions / 2) * CPU_warning)

	if(actions_per_tick > action_threshold)
		sleep(tick_lag_original)
		actions_per_tick = 0

/datum/controller/game_controller
	var/processing = 1
	var/wait = 0.5
	var/SLOW_PROCESS_TIME = 10
	var/list/subsystems = list()

datum/controller/game_controller/proc/setup()
	var/RLstart_time = world.timeofday

	if(master_controller && (master_controller != src))
		del(src)
		return

	world<<"Gerando casinhas..."
	var/datum/ruin_generator/casinhas = new("map/gen/casas/")
	casinhas.generate_ruins(1, 10, locate(/area/ruin))
	world<<"Casinha geradas!"

	for(var/ss_type in subtypesof(/subsystem))
		var/subsystem/ss = new ss_type()
		subsystems += ss
		initialize_subsystem(ss)
		spawn ss.process_loop()

	var/total_init_time = (world.timeofday - RLstart_time) / 10
	world << "Total initializations complete in [total_init_time] seconds!"

/datum/controller/game_controller/proc/initialize_subsystem(var/subsystem/SS)
	world<< "Inicializando SS-[SS.name]"
	SS.Initialize()
	SS.Finalize()   //burguer code me dando nojo e dor de cabeça
	CHECK_TICK()