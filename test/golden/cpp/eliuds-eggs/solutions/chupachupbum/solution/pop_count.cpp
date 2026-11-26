#include "pop_count.h"

namespace chicken_coop {
    int positions_to_quantity(int input) {
            int count = 0;
        while (input > 0) {
            count += input & 1;
            input >>= 1;
        }
        return count;
    }


}  // namespace chicken_coop
