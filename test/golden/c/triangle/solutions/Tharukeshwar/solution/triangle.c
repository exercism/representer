#include "triangle.h"
int check(triangle_t sides);
int is_scalene(triangle_t sides) { return check(sides) && !is_isosceles(sides); }
int is_equilateral(triangle_t sides) { return check(sides) && sides.a == sides.b && sides.a == sides.c; }
int is_isosceles(triangle_t sides) {
    return check(sides) && (sides.a == sides.b || sides.b == sides.c || sides.a == sides.c);
}
int check(triangle_t sides) {
    float sum = sides.a + sides.b + sides.c;
    if ((sides.a == 0 && sides.b == 0 && sides.c == 0) || sides.a > sum / 2.0 || sides.b > sum / 2.0 ||
        sides.c > sum / 2.0)
        return 0;
    return 1;
}