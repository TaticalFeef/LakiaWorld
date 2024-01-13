/client/
	var/last_control
	var/next_global_click

	var/button_tracker/button_tracker
	var/macros/macros

/client/New()
	. = ..()
	if(!macros)
		macros = new(src)

	if(!button_tracker)
		button_tracker = new(src)