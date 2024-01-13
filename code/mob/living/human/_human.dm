/mob/living/human/
/mob/living/human/icon = 'human.dmi'
/mob/living/human/var/force
//TODO: transforma erp em um componente
/mob/living/human/var/mob/living/human/partner
/mob/living/human/var/potenzia
/mob/living/human/var/bucketMeter
/mob/living/human/var/tired = 0
/mob/living/human/var/tentaclePower = 0
/mob/living/human/var/consent = FALSE
/mob/living/human/var/datum/tentacleType/tentacle

/mob/living/human/New()
	. = ..()
	var/pos = pick(subtypesof(/datum/tentacleType/))
	tentacle = new pos