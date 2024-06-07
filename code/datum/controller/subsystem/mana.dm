SUBSYSTEM_DEF(mana_system)
	tick_rate = 5
	priority = 10

/subsystem/mana_system/process()
	ManaDiffusion()

	if (CheckManaCollisions())
		ManaMixing()

	UpdateManaVisuals()

	return TRUE;

#define HYDRO_MANA "mana_hydro"
#define FIRE_MANA "mana_fire"
#define DENDRO_MANA "mana_dendro"
#define ELECTRO_MANA "mana_electro"
#define CRYO_MANA "mana_cryo"
#define COMMON_MANA "mana_common"
#define GRAVITA_MANA "mana_gravita"
#define MAGMA_MANA "mana_magma"
#define STEAM_MANA "mana_steam"

/turf/var/mana_type = COMMON_MANA
/turf/var/mana_intensity = 0

#define MIXING_THRESHOLD 50

/mana_object/
	parent_type = /obj
	var/mana_type = COMMON_MANA
	var/mana_intensity = 1
	var/diffusion_rate = 1

/mana_object/New(loc, _new_type, _new_intensity)
	..(loc)
	mana_type = _new_type
	mana_intensity = _new_intensity

/proc/is_mana_object(obj)
	return istype(obj, /mana_object)

#define DIRECTIONS  list(NORTH, SOUTH, EAST, WEST)

/proc/ManaMixing(mana_object/obj1, mana_object/obj2)
	if (!obj1 || !obj2) return
	if (obj1.mana_type != obj2.mana_type)
		if (obj1.mana_intensity + obj2.mana_intensity > MIXING_THRESHOLD)
			var/list/mix = ApplyMixingRules(obj1.mana_type, obj2.mana_type, obj1.mana_intensity, obj2.mana_intensity)
			var/new_type = mix[1]
			var/new_intensity =  mix[2]
			var/new_mana_object = new /mana_object(obj1.loc, new_type, new_intensity)
			zDel(obj1, obj2)

/proc/ApplyMixingRules(type1, type2, intensity1, intensity2)
	var/new_type = COMMON_MANA
	var/new_intensity = (intensity1 + intensity2) / 2

	if ((type1 == HYDRO_MANA && type2 == FIRE_MANA) || (type1 == FIRE_MANA && type2 == HYDRO_MANA))
		new_type = STEAM_MANA
	else if ((type1 == FIRE_MANA && type2 == DENDRO_MANA) || (type1 == DENDRO_MANA && type2 == FIRE_MANA))
		new_type = MAGMA_MANA
	else if ((type1 == HYDRO_MANA && type2 == CRYO_MANA) || (type1 == CRYO_MANA && type2 == HYDRO_MANA))
		new_type = CRYO_MANA

	return list(new_type, new_intensity)

/proc/CheckManaCollisions()
	for (var/mana_object/obj1 in world.contents)
		if (!is_mana_object(obj1)) continue
		for (var/mana_object/obj2 in obj1.loc.contents)
			if (!is_mana_object(obj2)) continue
			if (obj1 == obj2) continue
			ManaMixing(obj1, obj2)
	return TRUE

/proc/UpdateManaVisuals()
	for (var/turf/T in world.contents)
		if (T.mana_intensity > 0)
			return
	return TRUE

/world/New()
	..()
	for (var/turf/T in world.contents)
		var/mana_object/MO = new /mana_object(T, COMMON_MANA, 2)

proc/ManaDiffusion()
	for (var/mana_object/obj in world.contents)
		if (is_mana_object(obj))
			for (var/dir in DIRECTIONS)
				var/turf/adj_turf = locate(get_step(obj.loc,dir))
				if (isturf(adj_turf))
					var/mana_diff = obj.mana_intensity - adj_turf.mana_intensity
					if (abs(mana_diff) > 0.1)
						var/transfer_amount = mana_diff * obj.diffusion_rate
						obj.mana_intensity -= transfer_amount
						adj_turf.mana_intensity += transfer_amount
						if (adj_turf.mana_intensity > 100)
							adj_turf.mana_intensity = 100
						if (obj.mana_intensity < 0)
							obj.mana_intensity = 0
