#define GLOBAL_CLICK_DELAY \
    if(last_control + TICK_LAG >= world.time) \
        return TRUE; \
    var/true_time_of_day = true_time(); \
    if(next_global_click > true_time_of_day) \
        return TRUE; \
    next_global_click = true_time_of_day + 1; \
    last_control = world.time;

/client/Click(atom/object, location, control, params)
	GLOBAL_CLICK_DELAY
	var/list/click_params = params2list(params)
	click_params[PARAM_ICON_X] = text2num(click_params[PARAM_ICON_X])
	click_params[PARAM_ICON_Y] = text2num(click_params[PARAM_ICON_Y])

	var/mouse_button
	if("left" in click_params)
		mouse_button = "left"
	else if("right" in click_params)
		mouse_button = "right"
	else if("middle" in click_params)
		mouse_button = "middle"

	switch(mouse_button)
		if("left")
			mob.on_left_click(object)
		if("right")
			mob.on_right_click(object)
		if("middle")
			mob.on_middle_click(object)

	return ..()
