#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <string>
#include <vector>

namespace crypto_square {

class cipher {
public:
    explicit cipher(const std::string & in);

    std::string normalize_plain_text() const { return normalised; }
    std::vector<std::string> plain_text_segments() const;
    std::string cipher_text() const { return cipher_text_impl(false); };
    std::string normalized_cipher_text() const { return cipher_text_impl(true); };

private:
    std::string normalised;

    std::string cipher_text_impl(bool normalize) const;
};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H
