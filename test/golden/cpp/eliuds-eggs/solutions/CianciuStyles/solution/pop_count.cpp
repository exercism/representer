#include "pop_count.h"

namespace chicken_coop {

int positions_to_quantity(int number) {
    int result = 0;
    while (number > 0) {
        result += number & 1;
        number >>= 1;
    }
    return result;
}

}  // namespace chicken_coop
