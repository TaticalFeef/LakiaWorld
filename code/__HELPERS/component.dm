/**
	* checa se a datum tem um componente do tipo.
	*
	* args:
	* * target - a datum pra checa.
	* * component_type - que componente procurar.
	*
	* return:
	* TRUE se achar, FALSE qualquer outra coisa.
*/

/proc/has_component(datum/target, component_type)
	if(!istype(target))
		return FALSE
	var/list/components = target.datum_components
	if(!components)
		return FALSE
	for(var/comp in components)
		if(istype(comp, component_type))
			return TRUE
	return FALSE