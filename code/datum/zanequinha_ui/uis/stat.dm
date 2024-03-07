/datum/zanequinha_ui/stats
	html_view = 'zgui/stats.html'
	window_id = "outputwindow.browser"
	window_override = TRUE
	show_top_bar = FALSE
	width = 640
	height = 484
	resize = 1
	var/list/shown_spells = list()
	var/initialized_stats = FALSE
	var/list/stats = list(STR = STAT_STRENGTH, AGI = STAT_AGILITY, INT = STAT_INTELLIGENCE, DEX = STAT_DEXTERITY, CHA = STAT_CHARISMA, ARMOR = STAT_ARMOR)

/datum/zanequinha_ui/stats/New(atom/source, mob/user)
	. = ..(source, user, list("health.current_health"))

/datum/zanequinha_ui/stats/check_for_updates(force_update)
	. = ..(TRUE)

/datum/zanequinha_ui/stats/update_interface(mob/user)
	if(!initialized_stats)
		initialize_js_functions(viewer)
		return

	var/mob/living/U = source_atom
	var/health = U?.health:current_health || "-";
	var/max_health = U?.health:max_health || "-";

	//SPELLS
	var/list/spells = list()
	GET_COMPONENT_FROM(smanager, /datum/component/spell_manager, source_atom)
	if(smanager)
		spells = smanager.get_spell_names()

	if(spells.len != shown_spells.len)
		shown_spells = spells
		for(var/spell in shown_spells)
			user << output(list2params(list()), "[window_id]:clearSpells")
			user << output(list2params(list(spell)), "[window_id]:addSpell")

	for(var/_st in stats)
		var/st = stats[_st]
		var/value = U.format_stat_output(st)
		user << output(list2params(list(_st,value)), "[window_id]:updateStat")
	user << output(list2params(list("HEALTH","[health]/[max_health]")), "[window_id]:updateStat")

/datum/zanequinha_ui/stats/initialize_js_functions(mob/user)
	if(!initialized_stats)
		if(!user.verbs || !user.stats)
			return

		for(var/verb/V in user.verbs)
			var/verb_name = V:name
			var/verb_call = V
			user << output(list2params(list("verbs-list", verb_name, verb_call)), "[window_id]:addButtonWithTopic")

		for(var/st in stats)
			user << output(list2params(list("[st]")), "[window_id]:addStat")
		user << output(list2params(list("HEALTH")), "[window_id]:addStat")

	initialized_stats = TRUE

/datum/zanequinha_ui/stats/ui_act(action, list/h)
	. = ..()
	if(action == "verb")
		var/verb_path = text2path(h["verb_name"])
		call(source_atom, verb_path)()
	if(action == "spell")
		GET_COMPONENT_FROM(smanager, /datum/component/spell_manager, source_atom)
		if(smanager)
			smanager.cast_spell(h["spell_name"])
	return TRUE

/mob/living/Stat()
	return