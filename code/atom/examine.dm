/atom/proc/get_desc()
	return desc || name

/atom/proc/get_examine()
	return desc || name

/atom/verb/examine()
	set src in view()
	set hidden = 0
	to_chat(usr, src.get_examine())