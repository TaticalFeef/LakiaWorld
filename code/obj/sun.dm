/obj/sun
	name = "Corpo Celestial Artificial"
	desc = "Criado pela Emperatriz para iluminar o bairro."
	icon = 'sun_icon.dmi'
	light_range = 1000
	light_power = 100
	light_color = "#FFFFFF"
	var/daytime_power = 1000
	var/nighttime_power = 4
	var/transition_duration = 1
	var/last_update = 0
	var/is_night = FALSE
	var/last_bool = TRUE

/obj/sun/New()
	. = ..()
	is_night = SSdaynight.is_night
	last_bool = !is_night
	light_color = is_night ? "#e9f5f8" :"#FFFFFF"
	icon_state = is_night ? "moon" : "sun"
	name = is_night ? "Moon" : "Sun"

/obj/sun/proc/update_sun(is_night, new_x, new_y)
	var/current_time = world.timeofday * SUN_SPEED
	var/time_since_last = current_time - last_update
	last_update = current_time

	var/target_power = is_night ? nighttime_power : daytime_power
	var/amount = time_since_last / transition_duration
	light_power = approach(light_power, target_power, amount)
	var/l_color = light_color
	l_color = is_night ? "#e9f5f8" :"#FFFFFF"
	icon_state = is_night ? "moon" : "sun"
	name = is_night ? "Moon" : "Sun"
	last_bool = is_night
	set_light(is_night ? 20 : round((light_power+1) * 25), round(light_power), l_color)
	force_move(locate(new_x, new_y, 1))