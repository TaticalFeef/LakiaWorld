/mob/Write(savefile/F)
	F << name
	F << signal_enabled
	//..()

/mob/Read(savefile/F)
	//..()
	F >> name
	F >> signal_enabled