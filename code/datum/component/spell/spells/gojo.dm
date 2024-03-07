/datum/spell/teleportation
	name = "Gojo Domain"
	mana_cost = 0//50
	cooldown_duration = 1
	var/duration = 10
	var/mob/target
	var/original_z_caster
	var/original_z_target
	var/gojo_z_level
	var/width = 10
	var/height = 10
	var/obj/effect/black_ball_effect

/datum/spell/teleportation/New(atom/_caster, atom/_target)
	..()
	target = _target

/datum/spell/teleportation/cast()
	. = ..()
	for(var/mob/M in view(caster))
		if(M != caster)
			target = M
	caster.anchored = TRUE
	target.anchored = TRUE
	original_z_caster = caster.z
	original_z_target = target.z

	gojo_z_level = world.maxz + 1
	world.maxz = gojo_z_level

	flick_image('id_win.png')

	black_ball_effect = new /obj/effect(get_turf(caster))
	black_ball_effect.icon = 'black_ball.dmi'
	black_ball_effect.layer = LAYER_MOB + 1
	black_ball_effect.plane = PLANE_EFFECT
	black_ball_effect.pixel_y = -16

	target.force_move(get_step(caster, SOUTH))


	animate(black_ball_effect, transform = matrix()*2, time = 2 SECONDS)

	var/direction_to_ball = get_dir(target, black_ball_effect)
	var/cdirection_to_ball = get_dir(caster, black_ball_effect)
	animate(caster, pixel_x = caster.pixel_x + 10 * cos(cdirection_to_ball), pixel_y = caster.pixel_y + 10 * sin(cdirection_to_ball), time = 1 SECONDS)
	animate(target, pixel_x = target.pixel_x + 10 * cos(direction_to_ball), pixel_y = target.pixel_y + 10 * sin(direction_to_ball), time = 1 SECONDS)

	addtimer(CALLBACK(src, .proc/continueCasting, black_ball_effect), 1 SECONDS)

/datum/spell/teleportation/proc/continueCasting(obj/effect/black_ball_effect)
	caster.anchored = FALSE
	target.anchored = FALSE
	caster.pixel_x = 0
	caster.pixel_y = 0
	target.pixel_x = 0
	target.pixel_y = 0
	generate_gojo_realm()
	teleport_to_gojo_realm()
	zDel(black_ball_effect)

	addtimer(CALLBACK(src, .proc/teleport_back), duration * 10)


/datum/spell/teleportation/proc/generate_gojo_realm()
	for(var/x = 1 to width)
		for(var/y = 1 to height)
			new /turf/flat/floor/gojo/(locate(x, y, gojo_z_level))
			if(x == 1 || x == width || y == 1 || y == height)
				new /turf/solid/wall/r_wall(locate(x, y, gojo_z_level))

/datum/spell/teleportation/proc/teleport_to_gojo_realm()
	if(!consume_resources()) return
	caster.Move(locate(5, 5, gojo_z_level))
	target.Move(locate(6, 5, gojo_z_level))

/datum/spell/teleportation/proc/teleport_back()
	if(caster.z == gojo_z_level) caster.force_move(locate(caster.x, caster.y, original_z_caster))
	if(target.z == gojo_z_level) target.force_move(locate(target.x, target.y, original_z_target))
	target.anchored = 0
	flick_image('lost.png')

/datum/spell/teleportation/proc/flick_image(path)
	var/obj/pre_effect = new()
	var/obj/pre_effect_target
	if(target.client)
		pre_effect_target = new()
		pre_effect_target.icon = image(path)
		pre_effect_target.layer = LAYER_MOB + 1
		pre_effect_target.plane = PLANE_EFFECT
		pre_effect_target.screen_loc = "1,1"

	pre_effect.icon = image(path)
	pre_effect.layer = LAYER_MOB + 1
	pre_effect.plane = PLANE_EFFECT
	pre_effect.screen_loc = "1,1"


	caster.client << pre_effect
	caster.client.screen += pre_effect
	if(target.client)
		target.client << pre_effect_target
		target.client.screen += pre_effect_target
		animate(pre_effect_target, alpha = 0, time = 1 SECONDS)

	animate(pre_effect, alpha = 0, time = 1 SECONDS)

	sleep(1 SECONDS)
	caster << sound('screamer.ogg', volume=87)
	target << sound('screamer.ogg', volume=87)

	caster.client.images -= pre_effect
	caster.client.screen -= pre_effect
	if(target.client)
		target.client.images -= pre_effect_target
		target.client.screen -= pre_effect_target

	if(pre_effect_target)
		pre_effect_target.loc = null
		del pre_effect_target

	pre_effect.loc = null
	del pre_effect
