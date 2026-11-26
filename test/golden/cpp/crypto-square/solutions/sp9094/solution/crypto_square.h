#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <string>
#include <vector>

namespace crypto_square {

class cipher {

	public:

	cipher(const std::string& message) : message_(message) {}

	std::string normalize_plain_text();
	
	std::vector<std::string> plain_text_segments();

	std::string cipher_text();

	std::string normalized_cipher_text();

	private:

	std::string message_;

	size_t square_size = 0;

};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H