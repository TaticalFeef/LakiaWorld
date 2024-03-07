/datum/cosmetic_collection
	var/list/cosmetics = list()
	var/list/images = list()
	var/mob/owner

/datum/cosmetic_collection/New(mob/_owner)
	. = ..()
	owner = _owner

/datum/cosmetic_collection/Destroyed()
	owner = null
	cosmetics = null
	for(var/image/I in images)
		zDel(I)
	images = null

/datum/cosmetic_collection/Write(savefile/F)
	var i = 1

	for(var/datum/cosmetic in cosmetics)
		F["[i]_c"] << cosmetic.type
		i ++
	F["length_c"] << i

/datum/cosmetic_collection/Read(savefile/F)
	var l
	var i

	F["length_c"] >> l
	for(i=0, i<l, i++)
		var/new_type
		F["[i]_c"] >> new_type
		add_cosmetic(new_type)

/datum/cosmetic_collection/proc/add_cosmetic(cosmetic_type)
	var/cosmetic_path = text2path("[cosmetic_type]")
	if(!cosmetic_path) return FALSE

	var/datum/cosmetic/C = new cosmetic_path()
	cosmetics += C
	images += image(C.icon, C.icon_state)
	return TRUE

/datum/cosmetic_collection/proc/remove_cosmetic(cosmetic_name)
	for(var/datum/cosmetic/C in cosmetics)
		if(C.name == cosmetic_name)
			cosmetics -= C
			zDel(C)
		return TRUE
	return FALSE

/datum/cosmetic_collection/proc/apply_cosmetics(mob/living/human/target)
	/*for(var/datum/cosmetic/C in cosmetics)
		if(C.icon && C.icon_state)
			var/image/cosmetic_overlay = image(C.icon, target, C.icon_state)
			target.overlays += cosmetic_overlay*/
	for(var/image/I in images)
		target.overlays += I

/datum/cosmetic_collection/proc/clear_cosmetics(mob/living/human/target)
	for(var/image/I in images)
		target.overlays -= I
