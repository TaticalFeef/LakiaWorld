/obj/item/equipable/passive/abyssal_starshot
	icon_state = "abyssal_starshot"
	slot_state = "abyssal_starshot_slot"

/obj/item/equipable/passive/abyssal_starshot/equip(atom/wearer)
	. = ..()
	if(.)
		var/datum/modifier/abyssal_mod = new /datum/modifier/abyssal_starshot()
		wearer.add_modifier(abyssal_mod)

/obj/item/equipable/passive/abyssal_starshot/unequip(atom/wearer)
	. = ..()
	if(.)
		wearer.remove_modifier("Abyssal Starshot")
