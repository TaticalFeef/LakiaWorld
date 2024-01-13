SUBSYSTEM_DEF(garbage)

/datum/Destroyed()
	tag = null
	var/list/dc = datum_components
	for(var/I in dc)
		var/datum/component/C = I
		zDel(C)
	if(dc)
		dc.Cut()
/datum/proc/Recycle()

//zanequinhaGariDestroyerMegazordTM
proc/zDel(datum/D, hint = ZDEL_HINT_QUEUE)
	if(!D)
		return
	switch(hint)
		if(ZDEL_HINT_QUEUE)
			if(SSgarbage)
				SSgarbage.queue_for_deletion(D, GC_QUEUE_CHECK)
			else
				del D
		if(ZDEL_HINT_LETMELIVE)
			D.Destroyed()
			return
		if(ZDEL_HINT_IWILLGC)
			D.Destroyed()
			return
		if(ZDEL_HINT_HARDDEL)
			// fila da morte
			if(SSgarbage)
				SSgarbage.queue_for_deletion(D, GC_QUEUE_HARDDELETE)
			else
				del D
		if(ZDEL_HINT_HARDDEL_NOW)
			//guilhotina
			del D

/subsystem/garbage
	name = "Zanequinha Deleter"
	var/list/garbage_queues[GC_QUEUE_COUNT]
	tick_rate = 1

/subsystem/garbage/Initialize()
	. = ..()
	for(var/i in 1 to GC_QUEUE_COUNT)
		garbage_queues[i] = list()

/subsystem/garbage/process()
	process_garbage()
	return TRUE

/subsystem/garbage/proc/queue_for_deletion(datum/D, queue_type)
	if(!D || !istype(D))
		world << "tentativa de dar vidro pro gari"
		return

	D.zdeleting = TRUE
	var/refID = "\ref[D]"

	for(var/list/entry in garbage_queues[queue_type])
		if(istype(entry, /list) && length(entry) == 2 && entry[2] == refID)
			//world << "Datum j� est� no compactador: [refID]"
			//raiva indescritivel
			return

	var/list/queue = list() //VAI TOMAR NO CU BYOND!!!!!! (Y)
	queue = garbage_queues[queue_type]
	var/list/queue_entry = list(world.time, refID)
	queue += list(queue_entry)
	garbage_queues[queue_type] = queue

/subsystem/garbage/proc/process_garbage()
	for(var/queue_type in 1 to GC_QUEUE_COUNT)
		var/list/queue = list()
		queue = garbage_queues[queue_type]
		for(var/i in length(queue) to 1 step -1)
			var/entry = queue[i]
			if(!istype(entry, /list) || length(entry) != 2)
				queue.Cut(i, i+1)
				continue
			var/queue_time = entry[1]
			var/refID = entry[2]
			var/datum/D = locate(refID)
			if(!D || D.zdeleted)
				queue.Cut(i, i+1)
				continue
			switch(queue_type)
				if(GC_QUEUE_FILTER)
					if(world.time - queue_time > GC_FILTER_QUEUE)
						if(!D.zdeleted)
							queue_for_deletion(D, GC_QUEUE_CHECK)
						queue.Cut(i, i+1)
				if(GC_QUEUE_CHECK)
					if(world.time - queue_time > GC_CHECK_QUEUE)
						if(!D.zdeleted)
							D.Destroyed()
							SEND_SIGNAL(D, COMSIG_PARENT_ZDELETED)
							D.zdeleted = TRUE
							del D
						queue.Cut(i, i+1)
				if(GC_QUEUE_HARDDELETE)
					if(world.time - queue_time > GC_DEL_QUEUE)
						del D
						queue.Cut(i, i+1)
		garbage_queues[queue_type] = queue