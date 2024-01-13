/client/verb/button_press(button as text)
	set hidden = TRUE
	set instant = TRUE
	button_tracker.set_pressed(button)

/client/verb/button_release(button as text)
	set hidden = TRUE
	set instant = TRUE
	button_tracker.set_released(button)