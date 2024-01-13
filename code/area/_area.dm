/area/plane = PLANE_AREA
/area/layer = LAYER_AREA
/area/mouse_opacity = 0
/area/alpha = 150
/area/
	var/outside = FALSE
/area/outside
	outside = TRUE

/area/New()
	. = ..()
	invisibility = 100