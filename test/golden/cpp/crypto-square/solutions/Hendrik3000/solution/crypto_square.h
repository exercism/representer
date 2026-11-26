#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <string>
#include <vector>

namespace crypto_square {

class cipher{
private:
    const std::string input_str;
    size_t cols, rows;
    
public:
    cipher(const std::string& s) : input_str(s){}
    
    std::string normalize_plain_text();
    std::vector<std::string> plain_text_segments();
    std::string cipher_text();
    std::string normalized_cipher_text();
    
};
}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H