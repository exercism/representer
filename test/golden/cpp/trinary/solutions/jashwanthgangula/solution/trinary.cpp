#include <cmath>
#include <string>
#include "./trinary.h"
namespace trinary {
using std::string;
int to_decimal(string tri) {
  int base10 = 0;
  int i = 0;
  for (auto dig = tri.crbegin(); dig != tri.crend(); ++i, ++dig) {
    int numdig = *dig - '0';  // Make the character an integer.
    if (numdig == 0 || numdig == 1 || numdig == 2) {
      base10 += numdig * std::pow(3, i);
    } else {
      return 0;
    }
  }
  return base10;
}
}  // namespace trinary