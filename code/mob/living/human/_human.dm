/mob/living/human/
/mob/living/human/icon = 'human.dmi'
//TODO: transforma erp em um componente
/mob/living/human/var/tmp/mob/living/human/partner
/mob/living/human/var/tmp/potenzia
/mob/living/human/var/tmp/bucketMeter
/mob/living/human/var/tmp/tired = 0
/mob/living/human/var/tmp/tentaclePower = 0
/mob/living/human/var/tmp/consent = FALSE
/mob/living/human/var/tmp/datum/tentacleType/tentacle
/mob/living/human/var/datum/cosmetic_collection/cosmetics

//COSMETIC
/mob/living/human/var/datum/cosmetic/hair_style/hair_style

/mob/living/human/Initialize()
	. = ..()
	var/pos = pick(subtypesof(/datum/tentacleType/))
	tentacle = new pos


/obj/item/beaker/
	New()
		AddComponent(/datum/component/reagent_holder)

/mob/living/human/verb/test_cur()
	var/obj/item/beaker/B = new(usr.loc)
	var/datum/reagent/water/W = new
	var/datum/reagent/hydrogen/H = new

	GET_COMPONENT_FROM(rg, /datum/component/reagent_holder, B)
	if(rg)
		rg.add_reagent(W, 20)
		rg.add_reagent(H, 5) 
		to_chat("world","cuzi4")

	src.drink(rg)