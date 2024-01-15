/datum/spell_piece/
	var/atom/caster
	var/obj/spell/owner_spell
	var/datum/component/spell_piece/chain_reaction

/datum/spell_piece/New(atom/_caster, obj/spell/spell)
	. = ..()
	owner_spell = spell
	caster = _caster
	RegisterSignal(spell, COMSIG_SPELL_CAST_TARGETED, PROC_REF(cast_targeted))

/datum/spell_piece/proc/cast_targeted(var/list/atom/targets)
	return TRUE