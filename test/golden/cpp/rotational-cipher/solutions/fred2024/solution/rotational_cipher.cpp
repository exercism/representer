#include "rotational_cipher.h"
namespace rotational_cipher {
constexpr unsigned int RADIX{'z' - 'a' + 1};
std::string rotate(const std::string& s, unsigned int shift)
{
    std::string res;
    res.reserve(s.length());
    shift %= RADIX;
    for (auto c : s) {
        if (std::isalpha(c)) {
            char base = std::islower(c) ? 'a' : 'A';
            c = base + ((c - base) + shift) % RADIX;
        }
        res.push_back(c);
    }
    return res;
}
}  // namespace rotational_cipher