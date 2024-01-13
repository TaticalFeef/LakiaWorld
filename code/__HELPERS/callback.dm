/*
    USAGE:

        var/datum/callback/C = new(object|null, /proc/type/path|"procstring", arg1, arg2, ... argn)
        var/timerid = addtimer(C, time, timertype)
        OR
        var/timerid = addtimer(CALLBACK(object|null, /proc/type/path|procstring, arg1, arg2, ... argn), time, timertype)

        Note: proc strings can only be given for datum proc calls, global procs must be proc paths
        Also proc strings are strongly advised against because they don't compile error if the proc stops existing
        See the note on proc typepath shortcuts

    INVOKING THE CALLBACK:
        var/result = C.Invoke(args, to, add) //additional args are added after the ones given when the callback was created
        OR
        var/result = C.InvokeAsync(args, to, add) //Sleeps will not block, returns . on the first sleep (then continues on in the "background" after the sleep/block ends), otherwise operates normally.

    PROC TYPEPATH SHORTCUTS (these operate on paths, not types, so to these shortcuts, datum is NOT a parent of atom, etc...)

        proc defined on current(src) object OR overridden at src or any of it's parents:
            .procname
            Example:
                CALLBACK(src, .some_proc_here)

        proc defined on parent(of src) object (when the above doesn't apply):
            .proc/procname
            Example:
                CALLBACK(src, .proc/some_proc_here)

        global proc while in another global proc:
            .procname
            Example:
                CALLBACK(GLOBAL_PROC, .some_proc_here)

        Other wise you will have to do the full typepath of the proc (/type/of/thing/proc/procname)

*/
#define GLOBAL_PROC "THIS_IS_A_GLOBAL_PROC_CALLBACK" //used instead of null because clients can be callback targets and then go null from disconnect before invoked, and we need to be able to differentiate when that happens or when it's just a global proc.
#define CALLBACK new /datum/callback //not a macro to make it 510 compatible

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

/datum/callback/New(thingtocall, proctocall, ...)
	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	if (length(args) > 2)
		arguments = args.Copy(3)


/datum/callback/proc/Invoke(...)
	if (!object)
		CRASH("Cannot call null.[delegate]")

	var/list/calling_arguments = arguments

	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args

	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = 0
	if (!object)
		CRASH("Cannot call null.[delegate]")

	var/list/calling_arguments = arguments

	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args

	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))

/proc/CallAsync(datum/source, proctype, list/arguments)
	set waitfor = FALSE
	return call(source, proctype)(arglist(arguments))

#define RETURN_TYPE(X)