/atom/proc/on_left_click(atom/clicked)
	if(clicked)
		clicked.on_left_clicked(src)
		return TRUE

/atom/proc/on_right_click(atom/clicked)
	if(clicked)
		clicked.on_right_clicked(src)
		return TRUE

/atom/proc/on_middle_click(atom/clicked)
	if(clicked)
		clicked.on_middle_clicked(src)
		return TRUE

/atom/proc/on_left_clicked(atom/clicked)

/atom/proc/on_right_clicked(atom/clicked)

/atom/proc/on_middle_clicked(atom/clicked)