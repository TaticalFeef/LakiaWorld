/datum/buff
	var/duration
	var/stackable = FALSE
	var/atom/movable/parent

/datum/buff/New(atom/movable/_parent)
	parent = _parent

/datum/buff/proc/apply_effects()

/datum/buff/proc/remove_effects()

/datum/buff/proc/is_expired()

/datum/buff/proc/tick()

/datum/buff/proc/refresh(datum/buff/new_buff)