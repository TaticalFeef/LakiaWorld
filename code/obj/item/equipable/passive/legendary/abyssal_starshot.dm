/obj/item/equipable/passive/abyssal_starshot
	icon_state = "abyssal_starshot"
	slot_state = "abyssal_starshot_slot"
	name = "Abyssal StarShot"
	rarity = LEGENDARY

/obj/item/equipable/passive/abyssal_starshot/equip(atom/wearer)
	. = ..()
	if(.)
		var/datum/modifier/abyssal_mod = new /datum/modifier/abyssal_starshot()
		wearer.add_modifier(abyssal_mod)
		GET_COMPONENT_FROM(buff_manager, /datum/component/buff_manager, wearer)
		if(buff_manager)
			var/datum/buff/speed_buff/abyssal_speed = new /datum/buff/speed_buff(2, 5)
			buff_manager.add_buff(abyssal_speed)

/obj/item/equipable/passive/abyssal_starshot/unequip(atom/wearer)
	. = ..()
	if(.)
		wearer.remove_modifier("Abyssal Starshot")
		GET_COMPONENT_FROM(buff_manager, /datum/component/buff_manager, wearer)
		if(buff_manager)
			buff_manager.remove_buff(/datum/buff/speed_buff)
