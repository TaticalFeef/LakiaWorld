#define PI 3.14159265358979323846

#define FLOOR(x, y) ( round((x) / (y)) * (y) )

#define INFINITY				1e31	//closer then enough

#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )
