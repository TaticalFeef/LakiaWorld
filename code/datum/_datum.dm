/datum/
	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs
	/// Is this datum capable of sending signals?
	/// Set to true when a signal has been registered
	var/signal_enabled = FALSE

	var/list/hooks//hooks

/datum/var/zdeleted = FALSE
/datum/var/zdeleting = FALSE

/datum/proc/get_debug_name()
	return "[src.type]"

/datum/proc/Destroyed()

/datum/proc/delete()
	zDel(src)
	return TRUE