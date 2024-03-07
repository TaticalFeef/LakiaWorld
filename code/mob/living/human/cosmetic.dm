/mob/living/human/proc/apply_cosmetic(type)
	if(!cosmetics)
		cosmetics = new /datum/cosmetic_collection()

	cosmetics.add_cosmetic(type)
	cosmetics.apply_cosmetics(src)

/mob/living/human/proc/remove_cosmetic(name)
	if(cosmetics)
		cosmetics.remove_cosmetic(name)
		cosmetics.clear_cosmetics(src)
		cosmetics.apply_cosmetics(src)
