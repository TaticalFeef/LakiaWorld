/mob/living/
	var/selected_hand = HAND_RIGHT

/mob/living/proc/initialize_inventory(var/slot_count)
	inventory = new /datum/inventory(slot_count, src)

/mob/living/proc/pickup(obj/item/I, var/hand_type)
	hand_type = hand_type ? hand_type : selected_hand
	if(!I || !hand_type)
		return FALSE

	var/datum/inventory_slot/hand_slot = inventory.hand_slots[hand_type]
	if(!hand_slot)
		return FALSE

	if(hand_slot.occupied)
		src << "Your [hand_type] hand is already holding something."
		return FALSE

	return hand_slot.add_item(I)
