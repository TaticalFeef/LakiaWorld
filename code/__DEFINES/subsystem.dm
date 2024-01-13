#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){Recover();zDel(varname);}varname = src;}

#define SUBSYSTEM_DEF(X) var/global/subsystem/##X/SS##X;\
/subsystem/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInitialize();\
}\
/subsystem/##X

#define DEFAULT_TICK_USAGE 75

#define SS_WATER_TICK_USAGE 120

#define SS_ORDER_BAN 1
#define SS_ORDER_CALLBACK 5