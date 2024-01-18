/datum/modifier/abyssal_starshot
	name = "Abyssal Starshot"
	description = "Converte um terço (1/3) de qualquer dano físico em dano verdadeiro."
	effect_type = MODIFIER_PASSIVE

/datum/modifier/abyssal_starshot/apply_effect(mob/living/target, datum/damage_instance/DI)
	if(DI.damage_type == DAMAGE_PHYSICAL)
		var/true_damage = DI.amount / 3
		DI.amount -= true_damage
		var/datum/damage_instance/true_DI = new
		true_DI.amount = true_damage
		true_DI.damage_type = DAMAGE_TRUE
		true_DI.victim = DI.victim
		true_DI.source = DI.source
		true_DI.tick_rate = 1
		true_DI.duration = 1
		SSdamage.queue_damage(true_DI)