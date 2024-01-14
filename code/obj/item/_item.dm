/obj/item
	var/weight = 50
	var/size
	var/base_damage = 10
	var/damage_type = DAMAGE_PHYSICAL
	icon = 'player.dmi'

/obj/item/on_left_clicked(var/atom/clicker, var/obj/item/holding)
	..()
	var/mob/living/M = clicker
	if(istype(M))
		M.pickup(src)

/obj/item/calculate_damage(atom/target)
	var/dmg_amount = base_damage
	var/dmg_type = DAMAGE_PHYSICAL
	var/datum/damage_instance/DI = new
	DI.amount = dmg_amount
	DI.damage_type = dmg_type
	DI.victim = target
	DI.source = src
	DI.tick_rate = 1
	DI.duration = 1

	return DI