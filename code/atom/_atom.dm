/atom/
	var/attack_next //Quando vai liberar o ataque
	var/attack_cooldown = 5 //cooldown do ataque

/atom/proc/Initialize()
	return TRUE

/atom/proc/MouseDrop_T()
	return TRUE

/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/atom/proc/examine()
	return desc