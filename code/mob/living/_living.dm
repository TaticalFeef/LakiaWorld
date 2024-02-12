/mob/living/var/obj/hud/mood/mood_button
/mob/living/var/datum/inventory/inventory
/mob/living
    var/last_aggressor = null
/mob/living/
	var/image/attack_effect

/mob/living/Initialize()
	. = ..()
	AddComponent(/datum/component/mood)
	AddComponent(/datum/component/buff_manager)
	initialize_inventory(10,6)
	health = new /datum/health(100, src) //hihe
	var/obj/spell/fireball/FB = new(src)
	var/obj/spell/repulse/RP = new(src)
	var/obj/spell/beam/BM = new(src)
	var/obj/spell/attract/AT = new(src)
	contents += FB
	contents += RP
	contents += BM
	contents += AT
	stats = new /datum/atom_stats(src)
	stats.set_stat(STAT_ARMOR, 5, STAT_BASE)

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
        stat("HEALTH:", "[health.current_health]/[health.max_health]")
    if(stats)
        // STAT: base_stat (+ adicional)
        stat("STR:", format_stat_output(STAT_STRENGTH))
        stat("AGI:", format_stat_output(STAT_AGILITY))
        stat("INT:", format_stat_output(STAT_INTELLIGENCE))
        stat("DEX:", format_stat_output(STAT_DEXTERITY))
        stat("CHA:", format_stat_output(STAT_CHARISMA))
        stat("ARMOR:", format_stat_output(STAT_ARMOR))

/mob/living/proc/format_stat_output(stat_name)
    var/base_stat = stats.stats[STAT_BASE][stat_name] ? stats.stats[STAT_BASE][stat_name] : 0
    var/additional_stat = stats.stats[STAT_ADDITIONAL][stat_name] ? stats.stats[STAT_ADDITIONAL][stat_name] : 0
    var/temp_stat = stats.stats[STAT_TEMP][stat_name] ? stats.stats[STAT_TEMP][stat_name] : 0
    var/total_additional = additional_stat + temp_stat
    return "[base_stat] (+ [total_additional])"
