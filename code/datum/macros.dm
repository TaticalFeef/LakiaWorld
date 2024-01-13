/macros/
	var/client/owner
	var/list/macros = QWERTY_MACROS

/macros/Destroyed()
	owner = null
	. = ..()

/macros/New(var/client/spawning_owner)
	owner = spawning_owner
	. = ..()

/macros/proc/on_pressed(button)
	var/command = macros[button]

	switch(command)
		if("move_up")
			//world << "coolio"
			return TRUE

	return TRUE

/macros/proc/on_released(button)
	var/command = macros[button]

	switch(command)
		if("move_up")
			//world << "cool"
			return TRUE

	return TRUE