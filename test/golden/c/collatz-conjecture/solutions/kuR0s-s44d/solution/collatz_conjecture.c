#include "collatz_conjecture.h"
int steps(int start) {
    if (start <= 0) return -1;
    int counter = 0;
    int local = start;
    while (local != 1) {
        if (local % 2 == 0) {
            local /= 2;
        } else {
            local = (local * 3) + 1;
        }
        counter += 1;
    }
    return counter;
}
