#define ZDEL_HINT_QUEUE 0
#define ZDEL_HINT_LETMELIVE 1
#define ZDEL_HINT_IWILLGC 2
#define ZDEL_HINT_HARDDEL 3
#define ZDEL_HINT_HARDDEL_NOW 4

#define GC_QUEUE_FILTER 1
#define GC_QUEUE_CHECK 2
#define GC_QUEUE_HARDDELETE 3
#define GC_QUEUE_COUNT 3

#define GC_FILTER_QUEUE 1
#define GC_CHECK_QUEUE 1//(1 SECONDS)
#define GC_DEL_QUEUE 1
//ZDEL � ZANEQUINHA DELETE

#define GC_QUEUED_FOR_QUEUING       -1
#define GC_QUEUED_FOR_HARD_DEL      -2
#define GC_CURRENTLY_BEING_ZDELETED 1

//scuff
#define ZDELING(X) (!X || X.zdeleted == GC_CURRENTLY_BEING_ZDELETED)
#define ZDELETED(X) (!X || X.zdeleted)
#define ZDESTROYING(X) (!X || X.zdeleted == GC_CURRENTLY_BEING_ZDELETED)

#define ZDEL_LIST(x) if(x) { for(var/y in x) { zDel(y) }}; if(x) { x.Cut(); x = null; }
#define ZDEL_NULL(item) zDel(item); item = null