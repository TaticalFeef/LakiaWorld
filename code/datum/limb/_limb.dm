/datum/limb
	var/name
	var/health
	var/max_health
	var/datum/health/parent_health
	var/list/status_effects = list()
	var/amputated = FALSE
	var/obj/item/equipped_item
	var/mob/owner

/datum/limb/New(mob/_owner, name, max_hp)
	. = ..()
	owner = _owner
	src.name = name
	max_health = max_hp
	health = max_health
	parent_health = owner.health

/datum/limb/proc/apply_damage(amount)
	if(amputated)
		return
	health -= amount
	check_for_amputation()

/datum/limb/proc/check_for_amputation()
	if(health <= 0)
		amputate()

/datum/limb/proc/amputate()
	amputated = TRUE
	if(equipped_item)
		equipped_item.loc = get_turf(owner)
		equipped_item = null
		//amputar aqui
