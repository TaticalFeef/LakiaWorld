/mob/living/on_left_click(atom/clicked)
	. = ..()
	if(is_attack_mode() && clicked != src)
		attack(clicked)