#include "./sieve.h"

#include <bitset>
#include <cmath>
#include <vector>

namespace sieve {

void mark_multiples(size_t prime, std::vector<bool> &nums) {
  size_t i = prime;
  while (i < nums.size()) {
    nums[i] = true;
    i += prime;
  }
}

std::vector<int> primes(int n) {
  std::vector<int> out;
  if (n < 2) {
    return out;
  }

  std::vector<bool> nums;
  nums.reserve(n + 1);
  // only c++ global vars get initalized with default val
  for (int i = 0; i <= n; i++) {
    // nums[i] = false;
    nums.push_back(false);
  }

  size_t end = std::sqrt(n);

  size_t i = 2;
  for (; i <= end; i++) {
    if (!nums[i]) {
      out.push_back(i);
      mark_multiples(i, nums);
    }
  }

  for (; i < nums.size(); i++) {
    if (!nums[i]) {
      out.push_back(i);
    }
  }

  return out;
}

} // namespace sieve
