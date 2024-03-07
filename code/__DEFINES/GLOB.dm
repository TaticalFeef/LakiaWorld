#define NAMEOF(datum, X) (#X || ##datum.##X)

#define GLOBAL_VAR(X) /subsystem/GLOB/var/global/##X;

#define GLOBAL_TYPED_VAR(X, type) /subsystem/GLOB/var/type/##X;

#define GLOBAL_VAR_INIT(X, Value) \
/subsystem/GLOB/var/global/##X; \
/subsystem/GLOB/proc/init_##X() {\
	##X = ##Value;}\
/subsystem/GLOB/New() {\
	. = ..();\
	global_initializations += ##X;}