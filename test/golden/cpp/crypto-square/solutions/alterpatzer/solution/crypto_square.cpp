#include "crypto_square.h"

namespace crypto_square {
std::vector<std::string>
cipher::plain_text_segments() const
{
    std::vector<std::string> out;
    size_t count = c;
    for (size_t i = 0; i != normal.length(); i += count) {
        count = std::min(c, normal.length() - i);
        out.push_back(normal.substr(i, count));
    }
    return out;
}

std::string
cipher::cipher_text() const
{
    std::vector<std::string> segment = plain_text_segments();
    std::string out;
    for (size_t i = 0; i != c; ++i)
        for (size_t j = 0; j != r; ++j) {
            if (i < segment[j].length())
                out.push_back(segment[j][i]);
        }
    return out;
}

std::string
cipher::normalized_cipher_text() const
{
    std::string cipher = cipher_text();
    size_t blanks = r * c - cipher.length();
    std::string out;
    for (size_t i = 0; i != cipher.length(); ) {
        if (i != 0)
            out += " ";
        size_t group = i / r;
        if (group < c - blanks) {
            out += cipher.substr(i, r);
            i += r;
         } else {
            out += cipher.substr(i, r - 1) + " ";
            i += r - 1;
        }
    }
    return out;
}
}  // namespace crypto_square
