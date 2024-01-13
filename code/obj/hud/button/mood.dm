/obj/hud/mood
	name = "mood"
	icon = 'moods.dmi'
	screen_loc = "EAST,NORTH-5"
	plane = 10
	appearance_flags = PIXEL_SCALE | TILE_BOUND | NO_CLIENT_COLOR

/obj/hud/mood/New()
	. = ..()
	underlays += icon('moods.dmi', "underlay")

/obj/hud/mood/proc/update_icon(mob/living/owner)
	var/static/list/mood_to_icon = list(
		list("range" = list(11, INFINITY), "icon" = "jolly_mood"),
		list("range" = list(1, 10), "icon" = "happy_mood"),
		list("range" = list(0, -10), "icon" = "sad_mood"),
		list("range" = list(-INFINITY, -11), "icon" = "suicide_mood")
	)

	GET_COMPONENT_FROM(mood_component, /datum/component/mood, owner)
	if(mood_component)
		var/mood_value = mood_component.mood_value
		var/icon_state_found = "neutral_mood"

		for(var/list/mood_range in mood_to_icon)
			if(mood_value >= mood_range["range"][1] && mood_value <= mood_range["range"][2])
				icon_state_found = mood_range["icon"]
				break

		icon_state = icon_state_found

/obj/hud/mood/Click()
	GET_COMPONENT_FROM(mood, /datum/component/mood, usr)
	if(mood)
		mood.print_mood(usr)