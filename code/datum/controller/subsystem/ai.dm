SUBSYSTEM_DEF(ai_processor)
	name = "Processador de IA"
	tick_rate = 10
	var/list/registered_ais = list()

/subsystem/ai_processor/process()
	for(var/mob/living/human/ai/ai_mob in registered_ais)
		if(!ai_mob || !ai_mob.behavior_tree)
			continue
		ai_mob.behavior_tree.execute(ai_mob)
	return TRUE

/subsystem/ai_processor/proc/register_ai(mob/living/human/ai/ai_mob)
	if(ai_mob && !registered_ais[ai_mob])
		registered_ais += ai_mob

/subsystem/ai_processor/proc/unregister_ai(mob/living/human/ai/ai_mob)
	registered_ais -= ai_mob