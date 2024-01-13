/datum/heap
    var/list/L
    var/cmp

/datum/heap/New(compare)
	L = new()
	cmp = compare

/datum/heap/Destroyed(force)
	for(var/i in L)
		zDel(i)
	L = null
	return ..()

/datum/heap/proc/is_empty()
	return !length(L)

/datum/heap/proc/contains(refID) //yassss
	return L.Find(refID)

/datum/heap/proc/insert(A)
	L.Add(A)
	swim(length(L))

/datum/heap/proc/pop()
	if(!length(L))
		return 0
	. = L[1]

	L[1] = L[length(L)]
	L.Cut(length(L))
	if(length(L))
		sink(1)

/datum/heap/proc/swim(index)
	var/parent = round(index * 0.5)

	while(parent > 0 && (call(cmp)(L[index],L[parent]) > 0))
		L.Swap(index,parent)
		index = parent
		parent = round(index * 0.5)

/datum/heap/proc/sink(index)
	var/g_child = get_greater_child(index)

	while(g_child > 0 && (call(cmp)(L[index],L[g_child]) < 0))
		L.Swap(index,g_child)
		index = g_child
		g_child = get_greater_child(index)

/datum/heap/proc/get_greater_child(index)
	if(index * 2 > length(L))
		return 0

	if(index * 2 + 1 > length(L))
		return index * 2

	if(call(cmp)(L[index * 2],L[index * 2 + 1]) < 0)
		return index * 2 + 1
	else
		return index * 2

/datum/heap/proc/resort(A)
	var/index = L.Find(A)

	swim(index)
	sink(index)

/datum/heap/proc/List()
	. = L.Copy()

/datum/heap/proc/len()
	. = length(L)

/datum/heap/zdel/contains(refID)
	for(var/list/entry in L)
		if(entry[2] == refID)
			return TRUE
	return FALSE