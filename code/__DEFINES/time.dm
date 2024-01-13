#define TICK_LAG world.tick_lag

#define DECISECONDS_TO_TICKS(x) ((x) * FPS_SERVER * 0.1)
#define TICKS_TO_DECISECONDS(x) (((x) / FPS_SERVER) * 10)

#define SECONDS_TO_TICKS(x) (FPS_SERVER * x)
#define TICKS_TO_SECONDS(x) ((x)/FPS_SERVER)


#define MINUTES_TO_SECONDS(x) ((x) * 60)


#define SECONDS_TO_DECISECONDS(x) ((x) * 10)
#define DECISECONDS_TO_SECONDS(x) ((x) / 10)

#define FPS_CLIENT 60 //0 Means synced. Also this is default, players can change this for themselves.
#define FPS_SERVER 20