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
	else
		return