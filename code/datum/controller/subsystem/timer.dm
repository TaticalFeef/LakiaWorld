SUBSYSTEM_DEF(timers)

/subsystem/timers
	name = "Timers"
	var/list/timer_queue = list()
	tick_rate = 1

/subsystem/timers/process()
	process_timers()
	return TRUE

/subsystem/timers/proc/process_timers()
	var/current_time = world.time
	while(timer_queue.len)
		var/datum/timer/next_timer = timer_queue[1]
		if(next_timer.trigger_time > current_time)
			break
		// rodar o timer
		next_timer.execute()
		// remover da queue
		timer_queue.Cut(1, 2)

// colocar timer na queue
/subsystem/timers/proc/add_timer(datum/timer/t)
	var/position = 1
	for(var/datum/timer/existing_timer in timer_queue)
		if(t.trigger_time < existing_timer.trigger_time)
			break
		position++
	timer_queue.Insert(position, t)

datum/timer
	var/delay
	var/trigger_time
	var/datum/callback/callback

	New(datum/callback/cb, delay)
		callback = cb
		trigger_time = world.time + delay

datum/timer/proc/execute()
	if(callback && callback.object && istype(callback.object, /datum) && !callback.object.zdeleted)
		callback.Invoke()

/proc/addtimer(datum/callback/callback, wait = 0)
	if(!callback)
		return
	if(wait < 0)
		wait = world.tick_lag
	var/datum/timer/t = new(callback, wait)
	SStimers.add_timer(t)
