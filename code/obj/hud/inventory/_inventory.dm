/obj/hud/inventory
	var/datum/inventory_slot/linked_slot
	icon = 'inventory.dmi'
	icon_state = "paper"
	var/image/item_image

/obj/hud/inventory/New(var/desired_loc, mob/_owner)
	. = ..()
	owner = _owner
	update_appearance()

/obj/hud/inventory/proc/update_appearance(obj/item/I)
	if(item_image)
		zDel(item_image)
	overlays.Cut()
	item_image = null
	if(I)
		item_image = image(icon=I.icon, icon_state=I.icon_state, layer = 1000)
		item_image.screen_loc = src.screen_loc
		owner << item_image
		overlays += item_image
		name = I.name

/obj/hud/inventory/MouseEntered()
	if(linked_slot?.contained_item)
		tooltip_text = linked_slot.contained_item.name

/obj/hud/inventory/MouseDrop(atom/over_object)
	var/obj/hud/inventory/target = over_object
	if(!istype(target))
		return

	var/mob/living/L = owner

	if(L.selected_hand && L.inventory.hand_slots[L.selected_hand]?.occupied)
		var/datum/inventory_slot/hand/source_hand_slot = L.inventory.hand_slots[L.selected_hand]

		if(target.linked_slot.occupied == FALSE && target.linked_slot.is_item_compatible(source_hand_slot.contained_item))
			world << "alalallalaararara"
			if(source_hand_slot.transfer_item(target.linked_slot))
				L << "You transfer the item from your [L.selected_hand] hand to the inventory slot."
			else
				L << "You can't transfer the item to this inventory slot."
		else
			L << "The inventory slot is occupied or not compatible with the item."
	else
		L << "You have no item in your selected hand."

/obj/hud/inventory/Click()
	if(linked_slot?.contained_item)
		world << linked_slot.contained_item.name