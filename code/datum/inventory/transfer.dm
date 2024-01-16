/datum/inventory/proc/transfer_hand_to_slot(mob/living/L, var/datum/inventory_slot/hand/source_hand_slot, var/datum/inventory_slot/target_slot)
	if(!source_hand_slot || !source_hand_slot.occupied)
		return FALSE
	return source_hand_slot.transfer_item(target_slot)

/datum/inventory/proc/transfer_slot_to_hand(mob/living/L, var/datum/inventory_slot/source_slot, var/datum/inventory_slot/hand/target_hand_slot)
	if(!target_hand_slot)
		return FALSE
	return source_slot.transfer_item(target_hand_slot)

/datum/inventory/proc/transfer_slot_to_slot(var/datum/inventory_slot/source_slot, var/datum/inventory_slot/target_slot)
	if(!source_slot || !source_slot.occupied)
		return FALSE
	return source_slot.transfer_item(target_slot)

/datum/inventory/proc/transfer_item_between_slots(var/datum/inventory_slot/source_slot, var/datum/inventory_slot/target_slot)
	var/mob/living/L = owner
	if(!source_slot || !target_slot)
		L << "Invalid source or target slot."
		return FALSE
	if(istype(source_slot, /datum/inventory_slot/hand) && source_slot.occupied)
		if(!transfer_hand_to_slot(L, source_slot, target_slot))
			L << "You can't transfer the item to this inventory slot."
	else if(istype(target_slot, /datum/inventory_slot/hand))
		if(!transfer_slot_to_hand(L, source_slot, target_slot))
			L << "Your hand is occupied or not compatible with the item."
	else if(!transfer_slot_to_slot(source_slot, target_slot))
		L << "You can't transfer the item to this slot."
	return TRUE