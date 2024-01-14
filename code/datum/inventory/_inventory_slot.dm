/datum/inventory_slot
	var/occupied = FALSE
	var/slot_type
	var/obj/item/contained_item
	var/obj/hud/inventory/linked_hud
	var/mob/owner
	var/datum/inventory/manager

/datum/inventory_slot/New(mob/__owner, datum/inventory/_manager)
	owner = __owner
	manager = _manager
	linked_hud = new(_owner = __owner, _linked_slot = src)

/datum/inventory_slot/proc/is_item_compatible(obj/item/I)
	return TRUE

/datum/inventory_slot/proc/can_hold_item(obj/item/I)
	if(!occupied && I && manager.can_fit_item(I) && is_item_compatible(I))
		return TRUE
	return FALSE

/datum/inventory_slot/proc/add_item(obj/item/I)
	if(!can_hold_item(I))
		return FALSE
	I.loc = src
	contained_item = I
	occupied = TRUE
	update_hud()
	return TRUE

/datum/inventory_slot/proc/remove_item()
	if(!occupied)
		return null
	var/obj/item/I = contained_item
	I.loc = owner.loc
	contained_item = null
	occupied = FALSE
	update_hud()
	return I

/datum/inventory_slot/proc/transfer_item(datum/inventory_slot/target_slot)
	if(!occupied || !target_slot)
		return FALSE

	if(target_slot.can_hold_item(contained_item))
		contained_item.loc = target_slot
		target_slot.contained_item = contained_item
		target_slot.occupied = TRUE
		target_slot.update_hud()

		contained_item = null
		occupied = FALSE
		update_hud()

		return TRUE

	return FALSE

/datum/inventory_slot/proc/update_hud()
	if(linked_hud)
		linked_hud.update_appearance(contained_item)