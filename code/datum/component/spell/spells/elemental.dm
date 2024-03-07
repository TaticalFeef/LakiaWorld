/datum/spell/elemental
	var/element_type

/datum/spell/elemental/fire
	element_type = "fire"

/datum/spell/elemental/water
	element_type = "water"

/datum/spell/elemental/electric
	element_type = "electric"

/datum/spell/combo
	var/list/required_elements

/datum/spell/combo/electrocharge
	required_elements = list("water", "electric")

/datum/spell/combo/melt
	required_elements = list("fire", "ice")
