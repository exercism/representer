#include "eliuds_eggs.h"

namespace chicken_coop {

int positions_to_quantity(int decimal_number) {
    std::vector<int>binary_number;
    for(int i = decimal_number; i >= 0; i /= 2) {
        binary_number.emplace_back(i % 2);
    }
    return std::count(binary_number.begin(), binary_number.end(), 1);
}

}  // namespace chicken_coop
