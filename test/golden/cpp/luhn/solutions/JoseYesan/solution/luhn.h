#if !defined(LUHN_H)
#define LUHN_H
#include <string>

using namespace std;

namespace luhn {
    bool valid (string card_number);
}  // namespace luhn

#endif // LUHN_H