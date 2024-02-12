#define MOVE_FORCE_STRONG 10
#define MOVE_FORCE_WEAK 5
/atom/movable/proc/throw_at(atom/target, range, speed, force = MOVE_FORCE_STRONG, spin = TRUE)
	if(ZDELETED(src) || ZDELETED(target) || range <= 0 || speed <= 0)
		return FALSE

	var/datum/magic_throw/throw_effect = new(src, target, range, speed, force, spin)
	throw_effect.start_moving()
	return TRUE

/datum/magic_throw
	var/atom/movable/moving_object
	var/atom/target
	var/range
	var/speed
	var/force
	var/spin
	var/direction
	var/tile_move_time

/datum/magic_throw/New(atom/movable/_source, atom/_destination, _range, input_speed, _force, _spin)
	moving_object = _source
	target = _destination
	range = _range
	speed = input_speed
	force = _force
	spin = _spin
	tile_move_time = 10 / speed
	direction = get_dir(moving_object, target)

/datum/magic_throw/proc/start_moving()
	if(force >= MOVE_FORCE_STRONG)
		moving_object.setDir(REVERSE_DIR(direction))
	else if (force > MOVE_FORCE_WEAK)
		moving_object.setDir(direction)

	addtimer(CALLBACK(src, .proc/move_step), tile_move_time)

/datum/magic_throw/proc/move_step()
	if(ZDELETED(moving_object) || ZDELETED(target) || range <= 0)
		return

	var/new_loc = get_step(moving_object, direction)
	if(verify_move(new_loc))
		moving_object.force_move(new_loc)
		handle_spin_animation()

	range--
	continue_moving()

/datum/magic_throw/proc/verify_move(atom/new_loc)
	return (new_loc && !istype(new_loc, /turf/solid))

/datum/magic_throw/proc/handle_spin_animation()
	if(spin)
		moving_object.SpinAnimation(1, tile_move_time)

/datum/magic_throw/proc/continue_moving()
	if(range > 0)
		addtimer(CALLBACK(src, .proc/move_step), tile_move_time)

/atom/movable/verb/throw_self()
	set name = "Throw Self"
	set category = "Object"

	var/throw_range = 5
	var/throw_speed = 50

	var/throw_direction = dir

	var/turf/target_position = get_ranged_target_turf(src, throw_direction, throw_range)

	if(!throw_at(target_position, throw_range, throw_speed))
		to_chat(src, "<span class='warning'>Voc� n�o consegue gerar for�a para se jogar!</span>")

/atom/movable/proc/SpinAnimation(loops, degrees, duration, direction = 1)
	var/matrix/first_spin = matrix(120 * direction, MATRIX_ROTATE)
	var/matrix/second_spin = matrix(240 * direction, MATRIX_ROTATE)
	var/matrix/third_spin = matrix(degrees * direction, MATRIX_ROTATE)

	animate(src, transform = first_spin, time = duration, loop = loops, easing = LINEAR_EASING)
	animate(transform = second_spin, time = duration, easing = LINEAR_EASING)
	animate(transform = third_spin, time = duration, easing = LINEAR_EASING)

/atom/movable/proc/reset_transform(matrix/initial_transform)
	animate(src, transform = initial_transform, time = 1)