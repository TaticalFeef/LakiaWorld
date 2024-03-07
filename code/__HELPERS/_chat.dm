// to_chat:enviar mensagemn
// target: quem vai receber
// message: a mensagem
/proc/to_chat(target, message)
    // se target for o world
    if(target == world || target == "world")
        for(var/mob/M in world)
            var/client/C = M.client
            if(C)
                C << output(list2params(list(message)), "outputwindow.chatbrowser:addText")
        return

    // se for uma lista mandar pra todos nela
    if(islist(target))
        for(var/t in target)
            to_chat(t, message)
        return

    // 1 mob ou 1 client só
    var/client/C
    if(istype(target, /mob))
        C = target:client
    else if(istype(target, /client))
        C = target

    // achou o client ou ele foi setado
    if(C)
        C << output(list2params(list(message)), "outputwindow.chatbrowser:addText")

/proc/show_item_in_chat(mob/user, name, weight, size, dmg, dmg_type, rarity)
	weight = weight
	size = size
	dmg = dmg
	dmg_type = dmg_type
	rarity = rarity

	if(user?.client)
		user.client << output(list2params(list(name,weight,size,dmg,dmg_type,rarity)), "outputwindow.chatbrowser:showItem")