SUBSYSTEM_DEF(zaneUI)
    name = "Zanequinha Interface"
    tick_rate = 2
    var/list/uis = list()

/subsystem/zaneUI/process()
    update_ui()
    return TRUE

/subsystem/zaneUI/proc/update_ui()
	for(var/datum/zanequinha_ui/ui in uis)
		if(ui.update_ready)
			ui.check_for_updates()

/subsystem/zaneUI/proc/add_ui(datum/zanequinha_ui/ui)
	uis |= ui

/subsystem/zaneUI/proc/remove_ui(datum/zanequinha_ui/ui)
	uis -= ui