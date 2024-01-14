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
	if(can_fit_item(I))
		owner << "Inventário cheio!"
		return FALSE
	for(var/datum/inventory_slot/slot in slots)
		if(slot.can_hold_item(I))
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

/datum/inventory/proc/can_fit_item(obj/item/I)
	if(I.weight + calculate_total_weight() > max_carry_weight)
		return FALSE
	return TRUE