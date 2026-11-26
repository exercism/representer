#include "sum_of_multiples.h"

#include <set>

namespace sum_of_multiples {

int to(std::vector<int> multiples, int target) {
  std::set<int> multiples_found{};

  for (int m : multiples) {
    for (int i{1}; m * i < target; i++) multiples_found.insert(m * i);
  }

  int total{0};
  for (int s : multiples_found) total += s;

  return total;
}

}  // namespace sum_of_multiples
