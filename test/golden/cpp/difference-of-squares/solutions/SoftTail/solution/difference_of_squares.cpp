#include "difference_of_squares.h"

namespace difference_of_squares {

  int square_of_sum(int max_n) {
    int ret = 0;
    for (int i = 1; i <= max_n; i++) {
      ret += i;
    }
    return ret * ret;
  }

  int sum_of_squares(int max_n) {
    int ret = 0;
    for (int i = 1; i <= max_n; i++) {
      ret += i * i;
    }
    return ret;
  }

  int difference(int max_n) {
    return square_of_sum(max_n) - sum_of_squares(max_n);
  }

}  // namespace difference_of_squares
