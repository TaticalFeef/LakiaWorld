/datum/damage_instance
	var/amount
	var/damage_type    // Physical, Magical, True, etc.
	var/elemental_type // Fire, Ice, etc.,
	var/critical

	var/atom/victim    // Pessoa recebendo o dano
	var/atom/source    // Quem ou oque causou o dano

	var/status_effect  // Stun, Poison, etc.

	var/tick_rate      // De quando em quando aplicar o dano
	var/duration       // Duração total do dano
	var/tick_count     // Contador interno
	var/next_tick      // Próximo tick de dano

/datum/damage_instance/proc/damage_victim()
	if(victim && !victim.zdeleting && victim.health)
		victim.health.apply_damage(src)
		create_damage_popup()
	else
		return

/datum/damage_instance/proc/create_damage_popup()
	var/damage_color = get_damage_color(damage_type)
	var/damage_text = "<span style='color: [damage_color];'>[amount]</span>"
	new /obj/effect/chat_text(victim, damage_text)

/datum/damage_instance/proc/get_damage_color(damage_type)
	switch(damage_type)
		if(DAMAGE_PHYSICAL)
			return DAMAGE_COLOR_PHYSICAL
		if(DAMAGE_MAGICAL)
			return DAMAGE_COLOR_MAGICAL
		if(DAMAGE_TRUE)
			return DAMAGE_COLOR_TRUE
	return DAMAGE_COLOR_TRUE
