/datum/component/spell_manager
	var/list/spells = list()
	var/mob/living/owner

/datum/component/spell_manager/New(mob/living/owner)
	. = ..()
	if(istype(owner))
		src.owner = owner

/datum/component/spell_manager/proc/add_spell(spell_type)
	var/datum/spell/new_spell = new spell_type(owner)
	spells[new_spell.name] = new_spell

/datum/component/spell_manager/proc/cast_spell(spell_name)
	var/datum/spell/S = spells[spell_name]
	if(S && S.name == spell_name && S.can_cast())
		S.cast()
		return TRUE
	return FALSE

/datum/component/spell_manager/proc/get_spell_names()
	var/list/spell_names = list()
	for(var/spell_name in spells)
		spell_names += spell_name
	return spell_names

/datum/component/spell_manager/proc/check_combo()
	var/list/current_elements = list()
	for(var/spell_name in spells)
		var/datum/spell/elemental/E = spells[spell_name]
		if(istype(E) && E.is_active())
			current_elements += E.element_type

	for(var/spell_name in spells)
		var/datum/spell/combo/C = spells[spell_name]
		if(istype(C) && C.required_elements in current_elements)
			C.cast()