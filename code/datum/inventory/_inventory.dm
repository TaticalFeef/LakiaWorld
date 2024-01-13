#define SLOT_TYPE_HAND "hand"
#define SLOT_TYPE_BACKPACK "backpack"
#define SLOT_TYPE_RING "ring"

/datum/inventory
	var/list/datum/inventory_slot/slots = list()
	var/list/hand_slots = list()

	var/mob/owner
	var/max_carry_weight = 100

/datum/inventory/New(var/slot_count, mob/_owner)
	owner = _owner
	slots = list()
	initialize_hand_slots()
	initialize_inventory_slots(slot_count)
	position_slots()

/datum/inventory/proc/initialize_hand_slots()
	hand_slots[HAND_LEFT] = new /datum/inventory_slot/hand/left(owner, src)
	hand_slots[HAND_RIGHT] = new /datum/inventory_slot/hand/right(owner, src)

/datum/inventory/proc/initialize_inventory_slots(var/slot_count)
	for(var/i = 1; i <= slot_count; i++)
		var/datum/inventory_slot/new_slot = new(owner, src)
		slots += new_slot

/datum/inventory/proc/position_slots()
	var/datum/screen_manager/screen_mgr = new(owner)
	var/index = 1
	screen_mgr.add_to_screen(hand_slots[HAND_LEFT].linked_hud,9,1)
	screen_mgr.add_to_screen(hand_slots[HAND_RIGHT].linked_hud,10,1)
	//screen_mgr.position_element(hand_slots[HAND_LEFT].linked_hud, index)
	//screen_mgr.position_element(hand_slots[HAND_RIGHT].linked_hud, index + 1)
	index += 2

	for(var/datum/inventory_slot/slot in slots)
		screen_mgr.add_to_screen(slot.linked_hud)
		screen_mgr.position_element(slot.linked_hud, index)
		index++

/datum/inventory/proc/add_item(obj/item/I)
	if(I.weight + calculate_total_weight() > max_carry_weight)
		owner << "Inventário cheio! Item pesado!"
		return FALSE
	for(var/datum/inventory_slot/slot in slots)
		if(!slot.occupied && slot.is_item_compatible(I))
			return slot.add_item(I)
	return FALSE

/datum/inventory/proc/find_item_by_name(name)
	for(var/datum/inventory_slot/slot in slots)
		if(slot.occupied && slot.contained_item.name == name)
			return slot
	return null

/datum/inventory/proc/calculate_total_weight()
	var/total_weight = 0
	for(var/datum/inventory_slot/slot in slots)
		if(slot.occupied)
			total_weight += slot.contained_item.weight
	return total_weight

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
	linked_hud = new(_owner = __owner)

/datum/inventory_slot/proc/is_item_compatible(obj/item/I)
	return TRUE

/datum/inventory_slot/proc/add_item(obj/item/I)
	if(occupied || !I)
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
	if(target_slot.occupied)
		return FALSE
	target_slot.contained_item = contained_item
	target_slot.occupied = TRUE
	target_slot.update_hud()

	contained_item = null
	occupied = FALSE
	update_hud(null)
	return TRUE

/datum/inventory_slot/proc/update_hud()
	if(linked_hud)
		linked_hud.update_appearance(contained_item)