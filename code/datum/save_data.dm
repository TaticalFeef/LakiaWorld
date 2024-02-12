/datum/save_data
	var/char_name = ""
	var/hair_style_name = ""

/datum/save_data/proc/save(mob/M)
	var/savefile/S = new /savefile("data/[M.ckey].sav")
	S["char_name"] << char_name
	S["hair_style_name"] << hair_style_name

/datum/save_data/proc/load(mob/M)
	var/file_path = "data/[M.ckey].sav"
	if(fexists(file_path))
		var/savefile/S = new /savefile(file_path)
		S["char_name"] >> char_name
		S["hair_style_name"] >> hair_style_name
		if(char_name && hair_style_name)
			return TRUE
	return FALSE

/datum/save_data/proc/delete_save(mob/M)
	fdel("data/[M.ckey].sav")