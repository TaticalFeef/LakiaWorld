/datum/buff/speed_buff
	var/speed_modifier = 2
	var/cooldown_duration = 0

/datum/buff/speed_buff/apply_effects()
	parent.base_speed += speed_modifier
	parent.next_move_time = world.time + 1

/datum/buff/speed_buff/remove_effects()
	parent.base_speed = initial(parent.base_speed)
	parent.next_move_time = world.time + 1