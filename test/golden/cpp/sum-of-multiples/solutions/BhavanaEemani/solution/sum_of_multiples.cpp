#include "sum_of_multiples.h"
namespace sum_of_multiples {
    int to(std::vector<int> nums, int upperLimit) {
        int sum = 0;
        for (int i = 0; i < upperLimit; i++) {
            for (int j : nums) {
                if (i % j == 0) {
                    sum += i;
                    break;
                }
            }
        }
        return sum;
    }
}  // namespace sum_of_multiples
