/obj/spell/fireball
	cast_order = list(/datum/spell_piece/fireball)

/obj/spell/fireball/get_targets()
	targets = list()
	var/list/visible_mobs = list()
	for(var/mob/living/M in view(9,caster))
		visible_mobs[M.name] = M

	var/mob/living/selected_target = input(caster, "Select your target:", "Fireball Target", null) in visible_mobs

	if(selected_target && (selected_target in view(caster)))
		targets |= selected_target
	else
		var/list/L = view(9,caster) - caster
		for(var/mob/living/M in L)
			targets |= M

/datum/spell_piece/fireball

/datum/spell_piece/fireball/cast_targeted(var/src,var/list/atom/targets)
	for(var/tgt in targets)
		var/mob/living/target = tgt
		if(istype(target))
			//caster.shoot_projectile(caster, target, null, null, /obj/projectile/fireball, "fire", 0, 0, 0, 12, 1, "#FF4500")
			var/turf/target_turf = get_turf(target)
			if(!target_turf)
				return
			var/mob/living/owner = owner_spell.caster
			var/diff_x = target_turf.x - owner.x
			var/diff_y = target_turf.y - owner.y
			var/angle = ATAN2(diff_x, diff_y)
			var/obj/projectile/fireball/P = new /obj/projectile/fireball(owner.loc, angle, 30)
			P.set_dir(get_dir(P,target))

/obj/projectile/fireball
	name = "Fireball"
	icon_state = "fireball"
	var/explosion_radius = 2
	var/fire_damage = 20

/obj/projectile/fireball/handle_collision(turf/collision_turf)
	for(var/mob/living/M in range(explosion_radius, collision_turf))
		var/datum/damage_instance/DI = new
		DI.amount = fire_damage / 4
		DI.damage_type = DAMAGE_PHYSICAL
		DI.victim = M
		DI.source = src
		DI.tick_rate = 4
		DI.duration = 4
		M.apply_damage(DI)
	. = ..()