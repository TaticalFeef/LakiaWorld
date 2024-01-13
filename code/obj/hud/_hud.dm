/obj/hud/
	appearance_flags = NO_CLIENT_COLOR | PIXEL_SCALE | LONG_GLIDE | TILE_BOUND

	var/tooltip_text

	var/user_colors = TRUE

	var/flags_hud = 0x0

	var/mob/owner

	vis_flags = 0x0

	var/delete_on_no_owner = TRUE
	var/bad_delete = TRUE

	plane = PLANE_HUD
	layer = LAYER_HUD

/obj/hud/New(var/desired_loc)
	. = ..()

var/regex/valid_punct = regex(@"[.?!]($|\s)")

#define TOOLTIP_LIMIT 99

/obj/hud/Destroyed()
	owner = null
	. = ..()