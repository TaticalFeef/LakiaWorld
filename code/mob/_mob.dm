/mob/
	icon = 'player.dmi'
	var/obj/plane_master/floors/plane_master_floor
	var/obj/plane_master/walls/plane_master_wall
	var/obj/plane_master/mobs/plane_master_mob

	see_invisible = INVISIBILITY_DEFAULT
	invisibility = INVISIBILITY_MOBS
	light_range = 5

	//chat
	var/list/voice_modifiers
	var/list/stored_chat_text = list()

	//animação
	var/rotating = FALSE

	plane = PLANE_MOVABLE

/mob/proc/get_log_name()
	return "[name]"

/mob/proc/get_name()
	return "[name]"

/mob/verb/say_something(speech as text)
    talk(src, speech)

/mob/verb/get_loc()
	var/turf/T = get_turf(src)
	world << "[T.loc]"

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
		var/matrix/rotation_matrix = matrix()
		rotation_matrix.Turn(10)
		var/_time = 2
		animate(src, transform = rotation_matrix, time = _time, loop = 0, easing = EASE_OUT)
		spawn(_time)
			transform = matrix()
			rotating = FALSE

/mob/proc/update_rs_chat()
	for(var/k in stored_chat_text)
		var/obj/effect/chat_text/CT = k
		CT.glide_size = src.glide_size
		CT.force_move(src.loc)