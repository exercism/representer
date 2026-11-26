#include "hamming.h"

#include <stdexcept>
#include <string_view>

namespace hamming {

int compute(std::string_view left, std::string_view right) {
  if (left.size() != right.size()) {
    throw std::domain_error("sequences of different sizes");
  }

  int distance = 0;
  for (unsigned int i = 0; i < left.size(); ++i) {
    if (left[i] != right[i]) {
      ++distance;
    }
  }

  return distance;
}

}  // namespace hamming
