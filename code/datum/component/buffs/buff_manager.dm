/datum/component/buff_manager
	var/list/active_buffs = list()

/datum/component/buff_manager/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HUMAN_LIFE, .proc/process_buffs)

/datum/component/buff_manager/proc/add_buff(datum/buff/B)
	if(B.stackable && active_buffs[B.type])
		active_buffs[B.type].refresh(B)
	else
		B.parent = src.parent
		active_buffs[B.type] = B
		B.apply_effects()

/datum/component/buff_manager/proc/remove_buff(type)
	if(active_buffs[type])
		active_buffs[type].remove_effects()
		active_buffs -= type

/datum/component/buff_manager/proc/process_buffs()
	for(var/buff_type in active_buffs)
		var/datum/buff/B = active_buffs[buff_type]
		if(B.is_expired())
			B.remove_effects()
			active_buffs -= buff_type
		else
			B.tick()

/datum/component/buff_manager/proc/apply_speed_buff(datum/buff/speed_buff/speed_buff)
	var/atom/movable/owner_movable = parent
	if(owner_movable && speed_buff)
		owner_movable.base_speed += speed_buff.speed_modifier
		owner_movable.next_move_time = world.time + speed_buff.cooldown_duration * 10
