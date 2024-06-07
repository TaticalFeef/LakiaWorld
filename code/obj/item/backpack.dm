/obj/item/backpack
	name = "Mochila"
	desc = "Uma mochila resistente para carregar seus pertences."
	icon = 'storage.dmi'
	icon_state = "backpack"

	var/datum/inventory/backpack_inventory
	var/open = FALSE

/obj/item/backpack/New()
	. = ..()
	backpack_inventory = new /datum/inventory(10, 0, src) // 10 slots, sem slot de equip
	return .

/obj/item/backpack/proc/OpenInventory(mob/user)
	//if (user != src.loc) return FALSE // so quem usa abre
	open = TRUE
	backpack_inventory.position_slots()
	return TRUE

/obj/item/backpack/proc/CloseInventory(mob/user)
	if (user != src.loc) return FALSE
	open = FALSE
	return TRUE