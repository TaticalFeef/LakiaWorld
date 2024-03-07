// Mood Nigga Component System Enterprise Company

/datum/component/mood
	var/mood_value = 0
	var/list/moodlets = list()
	var/mob/living/owner
	var/obj/hud/mood/hud

/datum/component/mood/New(mob/living/_owner)
	. = ..()
	owner = _owner
	RegisterSignal(owner, COMSIG_HUMAN_LIFE, .proc/update_mood_value)
	instantiate_mood_hud()

/datum/component/mood/proc/instantiate_mood_hud()
	if(owner.client)
		if(!owner.mood_button)
			owner.mood_button = new
		hud = owner.mood_button
		owner.client.screen += owner.mood_button
		update_hud()

/datum/component/mood/proc/add_moodlet(datum/moodlet/_moodlet)
	moodlets += new _moodlet()
	SEND_SIGNAL(owner, COMSIG_MOODLET_ADDED, _moodlet)
	update_mood_value()

/datum/component/mood/proc/remove_moodlet(var/datum/moodlet/_moodlet)
	moodlets -= _moodlet
	SEND_SIGNAL(owner, COMSIG_MOODLET_REMOVED, _moodlet)
	update_mood_value()

/datum/component/mood/proc/update_mood_value()
	if(length(moodlets))
		mood_value = 0
		for(var/datum/moodlet/m in moodlets)
			if(m.is_expired())
				remove_moodlet(m)
			else
				mood_value += m.intensity
	update_hud()

/datum/component/mood/proc/update_hud()
	if(hud)
		hud.update_icon(owner)

/datum/component/mood/proc/print_mood(mob/u)
	var/list/mood_messages = list()
	if(length(moodlets))
		for(var/m in moodlets)
			var/datum/moodlet/moodlet = m
			mood_messages += moodlet.message
	var/general_mood = get_general_mood_message()
	to_chat(u, "|||||||||||||||||||||||||||||||||||||")
	if(length(mood_messages))
		to_chat(u, jointext(mood_messages, "\n"))
	to_chat(u, general_mood)
	to_chat(u, "|||||||||||||||||||||||||||||||||||||")

/datum/component/mood/proc/get_general_mood_message()
	if(mood_value > 20)
		return "\green Estou me sentindo �timo!"
	else if(mood_value > 10)
		return "\green Estou me sentindo bem!"
	else if(mood_value == 0)
		return "\yellow Estou me sentindo ok mula..."
	else if(mood_value < -10)
		return "\red EU QUERO MORRER!"
	else
		return "Estou oker!"