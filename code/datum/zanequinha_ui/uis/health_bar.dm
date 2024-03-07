/datum/zanequinha_ui/health_display
	html_view = 'zgui/computer.html'
	window_name = "zanequinha_ui_health_bar"
	show_top_bar = FALSE
	width = 200
	height = 100
	resize = 0

/datum/zanequinha_ui/health_display/New(atom/source, mob/user)
	. = ..(source, user, list("health.current_health"))

/datum/zanequinha_ui/health_display/update_interface(mob/user)
	..()
	var/health = interface_arguments["health.current_health"]
	user << output(list2params(list(health)), "[window_id].browser:updateHealthBar")

/datum/zanequinha_ui/health_display/ui_act(action, list/h)
	if(action == "world_log")
		world << h["value"]
	. = ..()

/mob/living/verb/openHealthUI()
	var/datum/zanequinha_ui/health_display/S = new (src, src)
	S.Open(src)