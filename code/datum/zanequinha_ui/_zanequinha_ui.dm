/datum/zanequinha_ui
	var/list/interface_arguments = list()
	var/atom/source_atom
	var/mob/viewer
	var/html_view = ""
	var/cached_html = null
	var/window_name = "zanequinha_ui_window"
	var/window_id
	var/window_override = FALSE //override de uma window na .dmf
	var/update_ready = FALSE
	var/show_top_bar = TRUE
	var/width = 400
	var/height = 400
	var/resize = 1

/datum/zanequinha_ui/New(atom/source, mob/user, list/args)
	source_atom = source
	viewer = user
	interface_arguments = args
	if(!window_override)
		window_id = "[window_name]_\ref[source_atom]_\ref[viewer]"
	SSzaneUI.add_ui(src)

/datum/zanequinha_ui/Destroyed()
	source_atom = null
	viewer = null
	interface_arguments = null

	. = ..()

/datum/zanequinha_ui/proc/Open(mob/user)
	send_assets(user)
	var/html_content = "";
	var/static/main_html_template = 'zgui/index.html'
	html_content = file2text(main_html_template)

	//options
	html_content = replacetext(html_content, "'!-SHOW-TOP-BAR-!'", show_top_bar ? "true" : "false")

	//refs
	html_content = replacetext(html_content, "!-USER-REF-!", "\ref[user]")
	html_content = replacetext(html_content, "!-SOURCE-REF-!", "\ref[source_atom]")
	html_content = replacetext(html_content, "!-SRC-REF-!", "\ref[src]")

	html_content = html_substitution(html_content)

	if(width != -1 && height != -1)
		user << browse(html_content, "window=[window_id];titlebar=0;can_resize=[resize];size=[width]x[height];transparent=1;")
	else
		user << browse(html_content, "window=[window_id];titlebar=0;can_resize=[resize];transparent=1;")


	/*
	else
		html_content = cached_html
		if(width != -1 && height != -1)
			user << browse(html_content, "window=[window_id];titlebar=0;can_resize=[resize];size=[width]x[height];transparent=1;")
		else
			user << browse(html_content, "window=[window_id];titlebar=0;can_resize=[resize];transparent=1;")
	*/

/datum/zanequinha_ui/proc/Close(mob/user, trash = TRUE)
	user << browse(null, "window=[window_id]")
	update_ready = FALSE
	if(trash)
		SSzaneUI.remove_ui(src)
		zDel(src)

/datum/zanequinha_ui/proc/LoadView(mob/user, view)
	var/view_content = file2text(view)
	if(!window_override)
		user << output(list2params(list(view_content)), "[window_id].browser:loadHTMLView")
	else
		user << output(list2params(list(view_content)), "[window_id]:loadHTMLView")

	spawn(1)
		initialize_js_functions(user)
	spawn(1)
		check_for_updates(force_update = TRUE)

//enviar style.css, imagens, etc
/datum/zanequinha_ui/proc/send_assets(mob/user)
	return TRUE

/datum/zanequinha_ui/proc/check_for_updates(force_update = FALSE)
	var/changed = FALSE
	for(var/arg in interface_arguments)
		var/new_value = get_nested_var(source_atom, arg)
		if(new_value != interface_arguments[arg] || force_update)
			interface_arguments[arg] = new_value
			changed = TRUE
	if(changed || force_update)
		update_interface(viewer)

//especifico de cada tela, chamar função js que atualiza a tela com os valores, ok
/datum/zanequinha_ui/proc/update_interface(mob/user)

//iniciar outras funções js antes de dar update (popular listas, etc!)
/datum/zanequinha_ui/proc/initialize_js_functions(mob/user)

//substituições adicionais
/datum/zanequinha_ui/proc/html_substitution(html)
	//EX:
	//var/list/item_list = list("<option/><br>")
	//html = replacetext(html, "!-ITEM-LIST-!", item_list)
	return html

/datum/zanequinha_ui/Topic(href, href_list)
	switch(href_list["action"])
		if("loadUI")
			LoadView(viewer, html_view)
			return TRUE
		if("closeUI")
			Close(viewer)
			return TRUE
		if("readyUI")
			//cache_ui(href_list["html_content"])
			update_ready = TRUE
			return TRUE
		else
			return ui_act(href_list["action"], href_list)

/datum/zanequinha_ui/proc/cache_ui(html_content)
	cached_html = html_content
	to_chat(world,cached_html)
	update_ready = TRUE

/datum/zanequinha_ui/proc/ui_act(action, list/h)
	switch(action)
		if("exemploner")
			to_chat("world", "exemplo aquier")
			return TRUE
	//oq não sabemos mandar pro source atom
	if(source_atom && source_atom.ui_act(action, h, src))
		return TRUE
	return FALSE

/atom/proc/ui_act(action, list/h, datum/zanequinha_ui/ui)
	switch(action)
		if("updateName") //exemplo
			if(h["newName"])
				name = sanitize(h["newName"])
				return TRUE
	return FALSE