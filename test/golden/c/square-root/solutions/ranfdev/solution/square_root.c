#include "square_root.h"

int square_root(int root) {
    int last = root;
    while (last*last != root) {
        last = (last + root / last) / 2;
    }
    return last;
}