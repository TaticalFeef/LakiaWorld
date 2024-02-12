/obj/spell/attract
    cast_order = list(/datum/spell_piece/attract)
    verb_name = "Attract."

/obj/spell/attract/get_targets()
    targets = list()
    var/list/L = view(9, caster) - caster
    for(var/mob/living/M in L)
        targets |= M

/datum/spell_piece/attract
    var/obj/effect/sparkle_path = /obj/effect/temporary/spell/attract

/datum/spell_piece/attract/cast_targeted(var/src,var/list/atom/targets)
	for(var/tgt in targets)
		var/mob/living/target = tgt
		if(istype(target))
			var/turf/target_turf = get_turf(target)
			if(!target_turf)
				continue
			new sparkle_path(target_turf)
			var/mob/living/owner = owner_spell.caster

			if(target.throw_at(owner, 5, 40))
				to_chat(target, "<span class='warning'>Você é puxado por uma força misteriosa!</span>")
