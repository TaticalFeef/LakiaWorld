#define BEAM_ICON 'beam_icon.dmi'
#define BEAM_ICON_STATE "beam"

/obj/spell/beam
	cast_order = list(/datum/spell_piece/beam)
	verb_name = "Beam Blast!!"

/obj/spell/beam/get_targets()
	targets = list()
	var/turf/caster_turf = get_turf(caster)
	var/direction = caster.dir
	var/turf/next_turf = caster_turf

	for(var/i in 1 to 3)
		next_turf = get_step(next_turf, direction)
		if(next_turf)
			targets |= next_turf

/datum/spell_piece/beam
	var/list/beam_effects = list()
	var/duration = 70

/datum/spell_piece/beam/cast_targeted(var/src, var/list/atom/targets)
	spawn_beam_effects()

	var/expiration_time = world.time + duration
	while(world.time < expiration_time)
		update_beam_direction_and_position()
		apply_continuous_damage()
		sleep(world.tick_lag)

	remove_beam()

/datum/spell_piece/beam/proc/spawn_beam_effects()
	var/turf/current_turf = get_turf(owner_spell.caster)
	var/direction = owner_spell.caster.dir
	for(var/i in 1 to 3)
		var/turf/next_turf = get_step(current_turf, direction)
		if(next_turf)
			var/obj/effect/beam_visual/beam_effect = new /obj/effect/beam_visual(next_turf)
			beam_effects += beam_effect
			beam_effect.setDir(direction)
			current_turf = next_turf
			sleep(1)

/datum/spell_piece/beam/proc/update_beam_direction_and_position()
	clear_beam_effects()
	spawn_beam_effects()

/datum/spell_piece/beam/proc/apply_continuous_damage()
	for(var/obj/effect/beam_visual/beam_effect in beam_effects)
		var/turf/target_turf = get_turf(beam_effect)
		for(var/mob/living/target in target_turf)
			if(target != owner_spell.caster)
				var/datum/damage_instance/DI = new
				DI.amount = 10
				DI.damage_type = DAMAGE_MAGICAL
				DI.elemental_type = ELEMENT_FIRE
				DI.victim = target
				DI.source = owner_spell.caster
				DI.sourceless = FALSE
				DI.tick_rate = 8
				DI.duration = 16
				SSdamage.queue_damage(DI)

				var/throw_direction = owner_spell.caster.dir
				var/turf/throw_target = get_edge_target_turf(target, throw_direction, 2)

				if(target.throw_at(throw_target, 2, 10))
					to_chat(target, "<span class='warning'>A força do raio te jogar para longe!</span>")

/datum/spell_piece/beam/proc/clear_beam_effects()
	for(var/effect in beam_effects)
		zDel(effect)
	beam_effects = list()

/datum/spell_piece/beam/proc/remove_beam()
	clear_beam_effects()