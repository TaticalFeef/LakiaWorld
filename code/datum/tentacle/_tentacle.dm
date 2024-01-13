/datum/tentacleType
	var/name
	var/description
	var/power

/datum/tentacleType/proc/applyEffect(mob/living/user, mob/living/target, obj/cleanable/bucket_juice/b)
	return

/datum/tentacleType/StrongTentacle
	name = "Strong Tentacle"
	description = "A powerful and sturdy tentacle."
	power = 50

/datum/tentacleType/StrongTentacle/applyEffect(mob/living/user, mob/living/target, obj/decal/cleanable/bucket_juice/b)
	//target.TakeBruteDamage(power * TENTACLE_DAMAGE_MULTIPLIER)
	view() << "<font color=red><b>[target] SCREAMS!</b></font>"

/datum/tentacleType/HealingTentacle
	name = "Healing Tentacle"
	description = "A tentacle with healing capabilities."
	power = -20

/datum/tentacleType/HealingTentacle/applyEffect(mob/living/user, mob/living/target, obj/decal/cleanable/bucket_juice/b)
	//target.TakeBruteDamage(power)
	b.name = "Gaia's Seed"
	b.color = rgb(0, 163, 108)
	animateDropShadowEffect(b)

/datum/tentacleType/HealingTentacle/proc/animateDropShadowEffect(obj/decal/cleanable/bucket_juice/b)
	var/start = b.filters.len
	b.filters += filter(type="outline", size=1, color=rgb(42, 170, 138, 100))
	var/g
	g = b.filters[start+1]
	animate(g, size=2, time=0, loop=-1, flags=ANIMATION_PARALLEL)
	animate(size = 1, time=4)