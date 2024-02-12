/obj/effect/temporary
	icon = 'fx_temporary.dmi'
	var/duration = 1
	var/fade = TRUE
/obj/effect/temporary/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 1)

/obj/effect/temporary/proc/fade_out()
	if(fade)
		animate(src,alpha=0,time=duration)
	addtimer(CALLBACK(src, .datum/proc/delete), duration)
	return TRUE

/obj/effect/temporary/spell/
	layer = LAYER_MOB + 0.1

/obj/effect/temporary/spell/repulse
	icon_state = "repulse"
	duration = 2

/obj/effect/temporary/spell/attract
	icon_state = "attract"
	duration = 2

/obj/effect/beam_visual
	name = "Beam"
	icon = 'fx_temporary.dmi'
	icon_state = "beam"
	light_range = 3
	light_power = 2
	light_color = "#00abec"

/obj/effect/beam_visual/Initialize()
	. = ..()
	HeatWaveEffect()

/obj/effect/beam_visual/proc/HeatWaveEffect()
	var/start = length(filters) + 1
	var/X, Y, rsq, i, f
	var/wave_count = 7


	for(i = 1, i <= wave_count, ++i)
		do
			X = 30*rand() - 15
			Y = 30*rand() - 15
			rsq = X*X + Y*Y
		while(rsq < 50 || rsq > 225)
		filters += filter(type="wave", x=X, y=Y, size=rand()*4 + 1, offset=rand())

	for(i = 1, i <= wave_count, ++i)
		f = filters[start + i - 1]
		animate(f, offset=f:offset + 1, time=0, loop=-1, flags=ANIMATION_PARALLEL)
		animate(offset=f:offset + 2, time=rand()*5+5)