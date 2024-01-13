/obj/item
	var/weight = 50
	var/size
	icon = 'player.dmi'

/obj/item/on_left_clicked(var/atom/clicker, var/obj/item/holding)
	..()
	var/mob/living/M = clicker
	if(istype(M))
		M.pickup(src)