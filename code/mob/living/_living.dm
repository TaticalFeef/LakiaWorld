/mob/living/var/obj/hud/mood/mood_button
/mob/living/var/datum/inventory/inventory
/mob/living/
	var/image/attack_effect

/mob/living/Initialize()
	. = ..()
	AddComponent(/datum/component/mood)
	initialize_inventory(10)
	health = new /datum/health(100, src) //hihe

/mob/living/Login()
	. = ..()
	src.gender = input("Select a gender for your character.","Your Gender", usr.gender) in list("male","female")
	if(inventory)
		inventory.position_slots()
	if(mood_button)
		client.screen += mood_button

/mob/living/proc/Life()
	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE, src)