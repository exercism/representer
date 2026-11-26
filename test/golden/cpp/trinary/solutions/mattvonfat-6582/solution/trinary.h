#if !defined(TRINARY_H)
#define TRINARY_H
#include <string_view>

namespace trinary {
    int to_decimal(std::string_view number_string);
}  // namespace trinary

#endif // TRINARY_H