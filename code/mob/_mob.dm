/mob/
	//icon = 'player.dmi'
	var/tmp/obj/plane_master/floors/plane_master_floor
	var/tmp/obj/plane_master/walls/plane_master_wall
	var/tmp/obj/plane_master/mobs/plane_master_mob

	see_invisible = INVISIBILITY_DEFAULT
	invisibility = INVISIBILITY_MOBS
	light_range = 5

	//chat
	var/tmp/list/voice_modifiers
	var/tmp/list/stored_chat_text = list()

	//animação
	var/tmp/rotating = FALSE

	plane = PLANE_MOVABLE

/mob/proc/get_log_name()
	return "[name]"

/mob/proc/get_name()
	return "[name]"

/proc/CallSay(mob/M)
	var/text = input(M,"Dizer","Mensagem") as text
	M.say_something(text)

/mob/verb/say_something(speech as text)
    talk(src, speech)

/mob/verb/get_loc()
	var/turf/T = get_turf(src)
	to_chat(usr, "[T.loc]")

/mob/Login()
	. = ..()

	var/client/C = src.client

	if(!plane_master_floor)
		plane_master_floor = new(src)
	C.screen += plane_master_floor

	if(!plane_master_wall)
		plane_master_wall = new(src)
	C.screen += plane_master_wall

	if(!plane_master_mob)
		plane_master_mob = new(src)
	C.screen += plane_master_mob

/mob/post_move()
	update_rs_chat()

/mob/pre_move()
	. = ..()
	if(!rotating)
		rotating = TRUE
		var/old_transform = transform
		var/matrix/rotation_matrix = matrix()
		rotation_matrix.Turn(10)
		var/matrix/new_transform = rotation_matrix * transform
		var/_time = 2
		animate(src, transform = new_transform, time = _time, loop = 0, easing = EASE_OUT)
		spawn(_time)
			transform = old_transform
			rotating = FALSE

/mob/proc/update_rs_chat()
	for(var/k in stored_chat_text)
		var/obj/effect/chat_text/CT = k
		CT.glide_size = src.glide_size
		CT.force_move(src.loc)

/mob/
	var/datum/zanequinha_ui/stats/stats_ui
	var/datum/zanequinha_ui/chat/chat_ui

/mob/living/Login()
	. = ..()
	init_ui()

/mob/living/Logout()
	close_ui()
	. = ..()

/mob/proc/init_ui()
	stats_ui = new /datum/zanequinha_ui/stats/ (src, src)
	chat_ui = new /datum/zanequinha_ui/chat/(src, src)
	stats_ui.Open(src)
	chat_ui.Open(src)

/mob/proc/close_ui()
	stats_ui.Close(src, TRUE)
	chat_ui.Close(src, TRUE)
	stats_ui = null
	chat_ui = null