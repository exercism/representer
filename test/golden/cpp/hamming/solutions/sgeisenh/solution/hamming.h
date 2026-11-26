#if !defined(HAMMING_H)
#define HAMMING_H

#include <string_view>

namespace hamming {

int compute(std::string_view left, std::string_view right);

}  // namespace hamming

#endif // HAMMING_H
