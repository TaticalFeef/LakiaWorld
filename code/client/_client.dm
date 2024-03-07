/client/
	var/last_control
	var/next_global_click

	var/button_tracker/button_tracker
	var/macros/macros

	preload_rsc = 2

/client/New()
	. = ..()
	if(!macros)
		macros = new(src)

	if(!button_tracker)
		button_tracker = new(src)

/client/New()
	. = ..()
	receive_assets()

/client/proc/receive_assets()
	send_preloaded_asset(src, "index.html")