/datum/zanequinha_ui/chat
	html_view = 'zgui/chat.html'
	window_id = "outputwindow.chatbrowser"
	window_override = TRUE
	show_top_bar = FALSE
	width = 640
	height = 352
	resize = 1
	var/list/messages_to_add = list()

/datum/zanequinha_ui/chat/New(atom/source, mob/user)
	. = ..(source, user, list(""))

/datum/zanequinha_ui/chat/check_for_updates(force_update)
	. = ..(TRUE)

/datum/zanequinha_ui/chat/update_interface(mob/user)
	if(messages_to_add.len)
		for(var/msg in messages_to_add)
			user << output(list2params(list(msg)), "[window_id]:addText")

/datum/zanequinha_ui/chat/initialize_js_functions(mob/user)
	return TRUE

/datum/zanequinha_ui/chat/ui_act(action, list/h)
	. = ..()
	if(action == "chat")
		var/text = h["msg"]
		var/mob/M = source_atom
		M.say_something(text)
		return
	return TRUE