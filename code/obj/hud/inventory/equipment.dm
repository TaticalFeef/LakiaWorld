/obj/hud/inventory/equipment
	icon_state = "equipment"
	use_slot_state = TRUE

/obj/hud/inventory/New(var/desired_loc, mob/_owner, datum/inventory/_linked_slot)
	. = ..()
	owner = _owner
	update_appearance()
	linked_slot = _linked_slot