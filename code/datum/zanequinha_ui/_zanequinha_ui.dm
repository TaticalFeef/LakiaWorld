/datum/zanequinha_ui
	var/list/interface_arguments = list()
	var/atom/source_atom
	var/mob/viewer
	var/html_view = ""
	var/window_name = "zanequinha_ui_window"
	var/window_id
	var/update_ready = FALSE
	var/show_top_bar = TRUE
	var/width = 400
	var/height = 400
	var/resize = 1

/datum/zanequinha_ui/New(atom/source, mob/user, list/args)
	source_atom = source
	viewer = user
	interface_arguments = args
	window_id = "[window_name]_\ref[source_atom]_\ref[viewer]"
	SSzaneUI.add_ui(src)

/datum/zanequinha_ui/proc/Open(mob/user)
	var/static/main_html_template = 'zgui/index.html'
	var/html_content = file2text(main_html_template)

	//options
	html_content = replacetext(html_content, "'!-SHOW-TOP-BAR-!'", show_top_bar ? "true" : "false")

	//refs
	html_content = replacetext(html_content, "!-USER-REF-!", "\ref[user]")
	html_content = replacetext(html_content, "!-SOURCE-REF-!", "\ref[source_atom]")
	html_content = replacetext(html_content, "!-SRC-REF-!", "\ref[src]")

	html_content = html_substitution(html_content)

	user << browse(html_content, "window=[window_id];titlebar=0;can_resize=[resize];size=[width]x[height]")

	spawn(1)
		LoadView(user, html_view)
	spawn(1)
		check_for_updates(force_update = TRUE)

/datum/zanequinha_ui/proc/Close(mob/user)
	user << browse(null, "window=[window_id]")
	SSzaneUI.remove_ui(src)
	zDel(src)

/datum/zanequinha_ui/proc/LoadView(mob/user, view)
	var/view_content = file2text(view)
	user << output(list2params(list(view_content)), "[window_id].browser:loadHTMLView")

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

//substituições adicionais
/datum/zanequinha_ui/proc/html_substitution(html)
	//EX:
	//var/list/item_list = list("<option/><br>")
	//html = replacetext(html, "!-ITEM-LIST-!", item_list)
	return html

/datum/zanequinha_ui/Topic(href, href_list)
	switch(href_list["action"])
		if("closeUI")
			Close(viewer)
			return TRUE
		if("readyUI")
			update_ready = TRUE
			return TRUE
		else
			return ui_act(href_list["action"], href_list)

/datum/zanequinha_ui/proc/ui_act(action, list/href_list)
	switch(action)
		if("exemploner")
			world << "exemplo aquier"
			return TRUE
	//oq não sabemos mandar pro source atom
	if(source_atom && source_atom.ui_act(action, href_list, src))
		return TRUE
	return FALSE

/atom/proc/ui_act(action, list/href_list, datum/zanequinha_ui/ui)
	switch(action)
		if("updateName") //exemplo
			if(href_list["newName"])
				name = sanitize(href_list["newName"])
				return TRUE
	return FALSE

/datum/zanequinha_ui/health_display
	html_view = 'zgui/computer.html'
	window_name = "zanequinha_ui_health_bar"
	show_top_bar = FALSE
	width = 200
	height = 100
	resize = 0

/datum/zanequinha_ui/health_display/New(atom/source, mob/user)
	. = ..(source, user, list("health.current_health"))

/datum/zanequinha_ui/health_display/update_interface(mob/user)
	..()
	var/health = interface_arguments["health.current_health"]
	user << output(list2params(list(health)), "[window_id].browser:updateHealthBar")

/datum/zanequinha_ui/health_display/ui_act(action, list/href_list)
	if(action == "world_log")
		world << href_list["value"]
	. = ..()

/mob/living/verb/openHealthUI()
	var/datum/zanequinha_ui/health_display/S = new (src, src)
	S.Open(src)