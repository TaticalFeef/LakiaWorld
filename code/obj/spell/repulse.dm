/obj/spell/repulse
	cast_order = list(/datum/spell_piece/repulse)
	verb_name = "Repulse."

/obj/spell/repulse/get_targets()
	targets = list()
	var/list/L = view(9,caster) - caster
	for(var/mob/living/M in L)
		targets |= M

/datum/spell_piece/repulse
	var/obj/effect/sparkle_path = /obj/effect/temporary/spell/repulse

/datum/spell_piece/repulse/cast_targeted(var/src,var/list/atom/targets)
	for(var/tgt in targets)
		var/mob/living/target = tgt
		if(istype(target))
			var/turf/target_turf = get_turf(target)
			if(!target_turf)
				return
			new sparkle_path(target_turf)
			var/mob/living/owner = owner_spell.caster
			var/throw_direction = get_dir(owner, target)
			var/turf/throw_target = get_edge_target_turf(target, throw_direction, 5)

			if(target.throw_at(throw_target, 5, 40))
				to_chat(target, "<span class='warning'>Você é jogado pra longe por uma onda de força!</span>")
