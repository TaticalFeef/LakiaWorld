/obj/item
	name = "alow"
	var/slot_state
	var/weight = 50
	var/size = "Medium"
	var/base_damage = 10
	var/damage_type = DAMAGE_PHYSICAL
	var/rarity = COMMON

	var/has_special_attack = FALSE
	icon = 'player.dmi'

/obj/item/Initialize()
	. = ..()

/obj/item/Destroyed()
	SSstats_manager.unregister_atom(src)
	return ..()

/obj/item/examine()
	var/mob/U = usr
	show_item_in_chat(U, name, "[weight]Kg", size, base_damage, damage_type, rarity)

/obj/item/proc/special_attack(mob/living/attacker, atom/target)
	return FALSE

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

	for(var/datum/modifier/mod in active_modifiers)
		mod.apply_effect(target, DI)

	return DI