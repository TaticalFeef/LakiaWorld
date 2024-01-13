/obj/plane_master/floors
	plane = PLANE_FLOOR
	render_target = "plane_floor"

/obj/plane_master/floors/apply_post_processing()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=4, offset=0, color=rgb(0,0,0))


/obj/plane_master/walls
	plane = PLANE_WALL
	render_target = "plane_wall"

/obj/plane_master/walls/apply_post_processing()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=4, offset=0, color=rgb(0,0,0))
