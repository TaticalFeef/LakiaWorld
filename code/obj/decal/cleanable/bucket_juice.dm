/obj/decal/cleanable/bucket_juice
	name = "Bucket Juice"
	desc = "A mysterious liquid."
	icon = 'interact.dmi'

/obj/decal/cleanable/bucket_juice/New()
	. = ..()
	icon_state = "cum[rand(1,12)]"
	filters = new /list()

/obj/decal/cleanable/bucket_juice/Click()
	set src in oview(1)
	view() << "<font color=blue>[usr] cleans up the [src.name]</font>"
	zDel(src)

/obj/decal/cleanable/bucket_juice/Destroyed()
	. = ..()
	filters = null
	return .