/datum/inventory_slot/equipment
	var/obj/item/equipable/contained_equipable

/datum/inventory_slot/equipment/New(mob/__owner, datum/inventory/_manager, var/_slot_type)
	owner = __owner
	manager = _manager
	slot_type = _slot_type
	linked_hud = new /obj/hud/inventory/equipment(_owner = __owner, _linked_slot = src)

/datum/inventory_slot/equipment/is_item_compatible(obj/item/I)
	if(istype(I, /obj/item/equipable))
		return TRUE
	return FALSE

/datum/inventory_slot/equipment/can_hold_item(obj/item/I)
	if(!occupied && is_item_compatible(I))
		return TRUE
	return FALSE

/datum/inventory_slot/equipment/on_receive_item(datum/inventory_slot/source_slot, obj/item/I)
	if(istype(I, /obj/item/equipable))
		var/obj/item/equipable/E = I
		contained_equipable = E
		E.equip(owner)
	return TRUE

/datum/inventory_slot/equipment/pre_transfer_actions(datum/inventory_slot/target_slot)
	if(src == target_slot)
		return TRUE
	if(istype(contained_equipable, /obj/item/equipable))
		var/obj/item/equipable/E = contained_equipable
		E.unequip(owner)
	return TRUE

/datum/inventory_slot/equipment/on_add_item(obj/item/I)
	if(istype(I, /obj/item/equipable))
		contained_equipable = I
	return ..()

/datum/inventory_slot/equipment/on_item_added(obj/item/I)
	if(istype(I, /obj/item/equipable))
		var/obj/item/equipable/E = I
		E.equip(owner)
	return

/datum/inventory_slot/equipment/on_remove_item(obj/item/I)
	if(istype(I, /obj/item/equipable))
		var/obj/item/equipable/E = I
		E.unequip(owner)
		contained_equipable = null
	return
