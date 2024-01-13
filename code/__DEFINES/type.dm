var/global/list/all_typecaches = list()

#define istypecache(needle,haystack) (needle && length(all_typecaches[haystack]) ? (all_typecaches[haystack][needle.type] ? TRUE : FALSE) : FALSE)
#define ispathcache(needle,haystack) (needle && length(all_typecaches[haystack]) ? (all_typecaches[haystack][needle] ? TRUE : FALSE) : FALSE)

/proc/createtypecache(var/datum/type_to_generate)

	if(all_typecaches[type_to_generate])
		CRASH("Tried generating a typecache that already exists!")

	all_typecaches[type_to_generate] = list()

	for(var/k in typesof(type_to_generate))
		all_typecaches[type_to_generate][k] = TRUE

#define is_floor(A) istypecache(A,/turf/flat/floor/)

#define is_turf(A) istypecache(A,/turf)

#define is_wall(A) istypecache(A,/turf/solid/wall/)


#define is_datum(A) istypecache(A,/datum/)