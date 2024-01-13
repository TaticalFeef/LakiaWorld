proc/switchWindowOn(_name)
	winshow(usr, _name, winget(usr, _name, "is-visible") != "true")