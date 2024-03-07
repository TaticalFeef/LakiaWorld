/mob/living
	var/tmp/datum/inventory/inventory
	var/tmp/obj/hud/mood/mood_button
	var/tmp/last_aggressor = null
	var/tmp/image/attack_effect

/mob/living/Initialize()
	. = ..()
	initialize_inventory(10,6)
	health = new /datum/health(100, src) //hihe
	initialize_components()
	initialize_spells()
	setup_stats()

/mob/living/proc/initialize_components()
	AddComponent(/datum/component/mood)
	AddComponent(/datum/component/buff_manager)
	AddComponent(/datum/component/spell_manager)

/mob/living/proc/initialize_spells()
	/*var/obj/spell/fireball/FB = new(src)
	var/obj/spell/repulse/RP = new(src)
	var/obj/spell/beam/BM = new(src)
	var/obj/spell/attract/AT = new(src)
	contents += FB
	contents += RP
	contents += BM
	contents += AT*/
	GET_COMPONENT_FROM(smanager, /datum/component/spell_manager, src)
	if(smanager)
		smanager.add_spell(/datum/spell/teleportation)

/mob/living/proc/setup_stats()
	stats = new /datum/atom_stats(src)
	stats.set_stat(STAT_ARMOR, 5, STAT_BASE)

/mob/living/Login()
	. = ..()
	if(inventory)
		inventory.position_slots()
	if(mood_button)
		client.screen += mood_button

/mob/living/proc/Life()
	SEND_SIGNAL(src, COMSIG_HUMAN_LIFE, src)
