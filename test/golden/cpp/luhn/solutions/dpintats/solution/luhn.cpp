#include "luhn.h"

namespace luhn {

bool valid(const std::string &input) {
  int count{};
  int result{};
  for (auto it = input.rbegin(); it != input.rend(); ++it) {
    if (*it == ' ') {
      continue;
    }
    if (*it < '0' || *it > '9') {
      return false;
    }
    int digit = *it - '0';
    if (count % 2 == 1) {
      int doubled = digit * 2;
      result += doubled > 9 ? doubled - 9 : doubled;
    } else {
      result += digit;
    }
    ++count;
  }
  return count > 1 && result % 10 == 0;
}
} // namespace luhn
