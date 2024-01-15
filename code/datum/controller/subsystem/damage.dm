SUBSYSTEM_DEF(damage)
	name = "Damage"
	tick_rate = 1
	var/internal_tick_count = 0
	var/list/queued_damage = list()

/subsystem/damage/process()
	internal_tick_count++
	for(var/datum/damage_instance/DI in queued_damage)
		if(!DI || !DI.source || !DI.source.is_alive())
			queued_damage -= DI
			zDel(DI)
			continue
		DI.tick_count++
		if(DI.tick_count > DI.duration)
			queued_damage -= DI
			zDel(DI)
			continue
		if(DI.tick_count % DI.tick_rate == 0)
			DI.damage_victim()
			DI.next_tick = world.time + DI.tick_rate
	return TRUE

/subsystem/damage/proc/queue_damage(datum/damage_instance/DI)
	DI.tick_count = 0
	DI.next_tick = world.time + DI.tick_rate
	queued_damage |= DI