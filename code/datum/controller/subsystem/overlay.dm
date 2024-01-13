SUBSYSTEM_DEF(overlay)
    name = "Target Overlay"
    //flags = SS_BACKGROUND
    //init_order = INIT_ORDER_TARGET_OVERLAY
    var/list/mobs_with_targets = list()

/subsystem/overlay/Initialize(timeofday)
	. = ..()

/subsystem/overlay/proc/add_mob(mob/M)
	if(!M in mobs_with_targets)
		mobs_with_targets += M

/subsystem/overlay/proc/remove_mob(mob/M)
	mobs_with_targets -= M

/subsystem/overlay/process()
	for(var/mob/M in mobs_with_targets)
		M.update_target_overlay(M.last_clicked_atom)
	return TRUE