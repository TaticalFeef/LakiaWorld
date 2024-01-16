/obj/spell
	var/atom/caster
	var/list/atom/targets = list()
	var/list/cast_order = list() //PIECE_FIRE,PIECE_FORCE,PIECE_ONHIT,PIECE_EXPLODE
	var/list/spell_pieces = list()

/obj/spell/New(atom/_caster)
	. = ..()
	caster = _caster

/obj/spell/Initialize()
	. = ..()
	for(var/piece in cast_order)
		piece = new piece(caster,src)
		spell_pieces += piece

/obj/spell/verb/cast()
	cast_spell()

/obj/spell/proc/cast_spell()
	pre_cast()
	if(can_cast())
		if(length(targets))
			SEND_SIGNAL(src, COMSIG_SPELL_CAST_TARGETED, src.targets)
		if(post_cast())
			return TRUE
		return FALSE //talvez uma flag tipo, SPELL_INTERUPTED
	return FALSE

/obj/spell/proc/can_cast()
	return TRUE

/obj/spell/proc/pre_cast()
	get_targets()
	return TRUE

/obj/spell/proc/post_cast()
	return TRUE

/obj/spell/proc/get_targets()
	for(var/mob/living/M in view(9, caster))
		targets += M