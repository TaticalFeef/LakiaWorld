// to_chat:enviar mensagemn
// target: quem vai receber
// message: a mensagem
proc/to_chat(mob/target, message)
	if(!target) return
	var/client/C = target.client
	if(C)
		C << message
		return
	target << message
