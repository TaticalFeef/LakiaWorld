/obj/plane_master/mobs
	plane = PLANE_MOVABLE

/obj/plane_master/mobs/apply_post_processing()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=-4, size=3, offset=0, color=rgb(0,0,0,200))
	filters += filter(type="alpha", x=0, y=0, render_source="*plane_water_mask", flags=MASK_INVERSE)