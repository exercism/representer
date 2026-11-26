#if !defined(LUHN_H)
#define LUHN_H
#include <string>
#include <algorithm>

namespace luhn {
bool valid(const std::string& credit);
}  // namespace luhn

#endif // LUHN_H