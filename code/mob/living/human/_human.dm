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