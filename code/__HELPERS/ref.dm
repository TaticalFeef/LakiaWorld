#define text_ref(datum) ref(datum)

/proc/REF(input)
	if(istype(input, /datum/))
		var/datum/thing = input
		/*if(thing.datum_flags & DF_USE_TAG)
			if(!thing.tag)
				world << "A ref was requested of an object with DF_USE_TAG set but no tag: [thing]"
				//thing.datum_flags &= ~DF_USE_TAG
			else
				return "\[[url_encode(thing.tag)]\]"*/
		return "\[[url_encode(thing.tag)]\]"
	return text_ref(input)