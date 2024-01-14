/datum/inventory_slot/hand
	var/hand_type
	slot_type = SLOT_TYPE_HAND

/datum/inventory_slot/hand/New(mob/__owner, datum/inventory/_manager, var/_hand_type)
	owner = __owner
	manager = _manager
	linked_hud = new /obj/hud/inventory/hand(_owner = __owner, _hand_type = hand_type, _linked_slot = src)

/datum/inventory_slot/hand/can_hold_item(obj/item/I) //não considerar peso
	if(!occupied && I && is_item_compatible(I))
		return TRUE
	return FALSE

/datum/inventory_slot/hand/left/
	hand_type = HAND_LEFT

/datum/inventory_slot/hand/right/
	hand_type = HAND_RIGHT