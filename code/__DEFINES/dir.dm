#define ISDIAGONALDIR(d) (d&(d-1))
#define REVERSE_DIR(dir) ( ((dir & 85) << 1) | ((dir & 170) >> 1) )