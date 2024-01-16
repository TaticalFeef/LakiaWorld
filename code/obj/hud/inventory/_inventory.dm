/obj/hud/inventory
	var/datum/inventory_slot/linked_slot
	icon = 'inventory.dmi'
	icon_state = "paper"
	var/image/item_image
	var/use_slot_state = FALSE

/obj/hud/inventory/New(var/desired_loc, mob/_owner, datum/inventory/_linked_slot)
	. = ..()
	owner = _owner
	update_appearance()
	linked_slot = _linked_slot

/obj/hud/inventory/proc/update_appearance(obj/item/I)
	if(item_image)
		zDel(item_image)

	overlays.Cut()
	item_image = null

	if(I)
		var/image_icon_state
		if(I.slot_state && use_slot_state)
			image_icon_state = I.slot_state
		else
			image_icon_state = I.icon_state

		item_image = image(icon=I.icon, icon_state=image_icon_state, layer = 1000)
		item_image.screen_loc = src.screen_loc
		owner << item_image
		overlays += item_image
		name = I.name

/obj/hud/inventory/MouseEntered()
	if(linked_slot?.contained_item)
		tooltip_text = linked_slot.contained_item.name

/obj/hud/inventory/MouseDrop(atom/over_object)
	var/obj/hud/inventory/target_inventory_hud = over_object

	if(!istype(target_inventory_hud))
		return

	var/mob/living/L = owner
	var/datum/inventory_slot/source_slot = linked_slot
	var/datum/inventory_slot/target_slot = target_inventory_hud.linked_slot

	L.inventory.transfer_item_between_slots(source_slot, target_slot)

/obj/hud/inventory/on_left_clicked()
	. = ..()
	var/mob/living/L = owner
	var/datum/inventory_slot/hand/selected_hand_slot = L.selected_hand ? L.inventory.hand_slots[L.selected_hand] : null

	if(!selected_hand_slot)
		return FALSE

	var/datum/inventory_slot/source_slot = linked_slot

	if(selected_hand_slot.occupied)
		L.inventory.transfer_item_between_slots(selected_hand_slot, source_slot)
	else
		L.inventory.transfer_item_between_slots(source_slot, selected_hand_slot)
	return TRUE
