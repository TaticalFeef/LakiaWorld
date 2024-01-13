#define GET_COMPONENT_FROM(varname, path, target) var##path/##varname = ##target.GetComponent(##path)
#define GET_COMPONENT(varname, path) GET_COMPONENT_FROM(varname, path, src)

#define COMPONENT_INCOMPATIBLE 1
/// Returned in PostTransfer to prevent transfer, similar to `COMPONENT_INCOMPATIBLE`
#define COMPONENT_NOTRANSFER 2

/// Return value to cancel attaching
#define ELEMENT_INCOMPATIBLE 1

// /datum/element flags
/// Causes the detach proc to be called when the host object is being deleted
#define ELEMENT_DETACH		(1 << 0)
/**
  * Only elements created with the same arguments given after `id_arg_index` share an element instance
  * The arguments are the same when the text and number values are the same and all other values have the same ref
  */
#define ELEMENT_BESPOKE		(1 << 1)

// How multiple components of the exact same type are handled in the same datum
/// old component is deleted (default)
#define COMPONENT_DUPE_HIGHLANDER		0
/// duplicates allowed
#define COMPONENT_DUPE_ALLOWED			1
/// new component is deleted
#define COMPONENT_DUPE_UNIQUE			2
/// old component is given the initialization args of the new
#define COMPONENT_DUPE_UNIQUE_PASSARGS	4
/// each component of the same type is consulted as to whether the duplicate should be allowed
#define COMPONENT_DUPE_SELECTIVE		5

// All signals. Format:
// When the signal is called: (signal arguments)

#define COMSIG_COMPONENT_ADDED "component_added"				//when a component is added to a datum: (datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"			//before a component is removed from a datum because of RemoveComponent: (datum/component)
#define COMSIG_PARENT_ZDELETED "parent_zdeleted"				//before a datum's Destroyed() is called: ()

// Chamado quando é checado se o atom pode se mover: ()
// Chamado quando o atom se move: (new_loc)
// Chamado quando depois que o atom se move: (new_loc)
// Chamado quando o atom é movido através de force_move: (new_loc)
#define COMSIG_MOVABLE_CAN_MOVE "movable_can_move_signal" // (bool: can_move)
#define COMSIG_MOVABLE_PRE_MOVE "movable_pre_move_signal" // (atom: destination)
#define COMSIG_MOVABLE_POST_MOVE "movable_post_move_signal" // (atom: destination)
#define COMSIG_MOVABLE_FORCE_MOVE "movable_force_move_signal" // (atom: destination)

#define COMSIG_MOODLET_ADDED "moodlet_added"
#define COMSIG_MOODLET_REMOVED "moodlet_removed"
#define COMSIG_MOB_MOVED "mob_moved"
#define COMSIG_MOB_INTERACT "mob_interact"
#define COMSIG_MOB_HEALTH_CHANGED "mob_health_changed"

#define COMSIG_HUMAN_LIFE "mob_ticked"

#define SEND_SIGNAL(target, sigtype, arguments...) ( !target.comp_lookup || !target.comp_lookup[sigtype] ? NONE : target._SendSignal(sigtype, list(target, ##arguments)) )