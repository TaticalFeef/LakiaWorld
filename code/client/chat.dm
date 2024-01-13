/proc/talk(var/mob/speaker, var/text_to_say, var/text_type=TEXT_TALK, var/talk_range=TALK_RANGE)
    if(!text_to_say || !istype(speaker))
        return FALSE

    if(length(speaker.voice_modifiers))
        for(var/modifier in speaker.voice_modifiers)
            text_to_say = call(modifier)(speaker, text_to_say)
            if(!text_to_say)
                return FALSE

    switch(text_type)
        if(TEXT_TALK)
            new /obj/effect/chat_text(speaker, text_to_say)
            broadcast_talk(speaker, text_to_say, talk_range)

    if(speaker.is_player_controlled())
        log_chat("[text_type]: [speaker.get_log_name()]: [text_to_say]")

    return TRUE

/proc/broadcast_talk(var/mob/speaker, var/text, var/range)
	for(var/mob/M in view(range, speaker))
		M << "[speaker.get_name()] says: [text]"

/mob/proc/is_player_controlled()
	return src.client ? TRUE : FALSE//(src in player_list)

/proc/log_chat(message)
	world.log << message