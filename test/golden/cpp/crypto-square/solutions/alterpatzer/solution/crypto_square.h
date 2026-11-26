#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H
#include <algorithm>
#include <cctype>
#include <cmath>
#include <iterator>
#include <string>
#include <vector>
namespace crypto_square {
class cipher {
    std::string normal;
    size_t r, c;
public:
    cipher(const std::string &plaintext) {
        std::copy_if(plaintext.begin(), plaintext.end(), std::back_inserter(normal),
                     [](char c){return isalnum(c);});
        std::transform(normal.begin(), normal.end(), normal.begin(),
                       [](char c){return tolower(c);});
        size_t n = normal.length();
        c = size_t(std::ceil(std::sqrt(n)));
        r = (c * (c - 1) >= n) ? c - 1 : c;
    }
    std::string normalize_plain_text() const { return normal; }
    std::vector<std::string> plain_text_segments() const;
    std::string cipher_text() const;
    std::string normalized_cipher_text() const;
};
}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H