/mob/living/var/obj/hud/mood/mood_button
/mob/living/var/datum/inventory/inventory
/mob/living/
	var/image/attack_effect

/mob/living/Initialize()
	. = ..()
	AddComponent(/datum/component/mood)
	initialize_inventory(10,6)
	health = new /datum/health(100, src) //hihe
	contents += new /obj/spell/fireball(src)
	stats = new /datum/atom_stats(src)

/mob/living/Login()
	. = ..()
	src.gender = input("Select a gender for your character.","Your Gender", usr.gender) in list("male","female")
	if(inventory)
		inventory.position_slots()
	if(mood_button)
		client.screen += mood_button

/mob/living/proc/Life()
	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE, src)

/mob/living/Stat()
	. = ..()
	statpanel("Status")
	if(health)
		stat("HEALTH:","[health.current_health]/[health.max_health]")
	if(stats)
		stat("STR:","[stats.strength]")
		stat("AGI:","[stats.agility]")
		stat("INT:","[stats.intelligence]")
		stat("DEX:","[stats.dexterity]")
		stat("CHA:","[stats.charisma]")