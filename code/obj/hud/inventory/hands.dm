/obj/hud/inventory/hand
	icon_state = HAND_LEFT
	var/hand_type = HAND_LEFT
	var/image/selected_overlay

/obj/hud/inventory/hand/New(var/desired_loc, mob/_owner, datum/inventory_slot/_linked_slot, var/_hand_type)
	. = ..()
	hand_type = _hand_type
	icon_state = hand_type
	selected_overlay = image(icon = src.icon, icon_state = "hand_selected", layer = FLOAT_LAYER)
	owner << selected_overlay

/obj/hud/inventory/hand/on_left_clicked(var/atom/clicker)
	if(!istype(clicker, /mob/living))
		return

	var/mob/living/L = clicker

	var/datum/inventory_slot/hand/current_hand_slot = L.inventory.hand_slots[L.selected_hand]
	var/datum/inventory_slot/hand/clicked_hand_slot = L.inventory.hand_slots[hand_type]

	if(L.selected_hand == hand_type)
		L.selected_hand = null
	else
		if(current_hand_slot && current_hand_slot.occupied)
			if(current_hand_slot.transfer_item(clicked_hand_slot))
				L.selected_hand = hand_type
				L << "You transfer the item to your [hand_type] hand."
			else
				L << "You can't transfer the item to your [hand_type] hand."
		else
			L.selected_hand = hand_type

	clicked_hand_slot.linked_hud.update_appearance(clicked_hand_slot.contained_item)
	current_hand_slot.linked_hud.update_appearance(current_hand_slot.contained_item)

/obj/hud/inventory/hand/update_appearance(obj/item/I)
	..()
	var/mob/living/L = owner
	if(L?.selected_hand == hand_type)
		if(!(selected_overlay in overlays))
			overlays += selected_overlay
	else
		if(selected_overlay in overlays)
			overlays -= selected_overlay