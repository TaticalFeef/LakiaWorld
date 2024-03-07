// pegar variavel nestada por string.
// EX : (src, "health.current_health")
// vai retornar a current_health de src
/proc/get_nested_var(atom/source, var_path)
	var/list/path_parts = splittext(var_path, ".")
	var/current_value = source
	for(var/part in path_parts)
		if(islist(current_value))
			var/converted_part = text2num(part)
			if(isnum(converted_part))
				current_value = current_value[converted_part]
			else
				current_value = current_value[part]
		else if(istype(current_value, /datum))
			current_value = current_value:vars[part]
		else
			return null
	return current_value