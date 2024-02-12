SUBSYSTEM_DEF(projectiles)

/subsystem/projectiles/
	name = "Projetil"
	var/list/projectiles = list()
	tick_rate = 1

/subsystem/projectiles/process()
	for(var/obj/projectile/P in projectiles)
		if(ZDELING(P))
			remove_projectile(P)
		P.update_position(tick_rate)
	return TRUE

/subsystem/projectiles/proc/add_projectile(obj/projectile/P)
	projectiles += P

/subsystem/projectiles/proc/remove_projectile(obj/projectile/P)
	projectiles -= P