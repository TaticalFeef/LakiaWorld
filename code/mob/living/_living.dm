/mob/living/var/obj/hud/mood/mood_button
/mob/living/var/datum/inventory/inventory

/mob/living/New()
	. = ..()
	spawn()
		SSliving.add_mob(src)
		AddComponent(/datum/component/mood)
		src.gender = input("Select a gender for your character.","Your Gender", usr.gender) in list("male","female")
		initialize_inventory(10)

/mob/living/Login()
	. = ..()

	if(inventory)
		inventory.position_slots()
	if(mood_button)
		client.screen += mood_button

/mob/living/proc/Life()
	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE, src)

/mob/living/verb/add_item_to_inventory()
	var/item_name = input("Enter the name of the item to add:", "Add Item") as text
	var/obj/item/new_item = new /obj/item
	new_item.name = item_name
	var/success = inventory.slots[1].add_item(new_item) // Add to the first slot for simplicity
	if(success)
		usr << "Item [item_name] added to inventory."
	else
		usr << "Failed to add item to inventory."