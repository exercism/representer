#include "sum_of_multiples.h"

#include <numeric>
namespace sum_of_multiples {
using std::vector;
using std::lcm;
int to(vector<int> const &base_values, int level) {
    int sum = 0;

    for (int num = 1; num<level; num++) {
        for (auto base_val: base_values) {
            if (num % base_val == 0) {
                sum += num;
                break;
            }
        }
    }

    return sum;
}
} // namespace sum_of_multiples
