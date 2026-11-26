#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <string>
#include <vector>

namespace crypto_square {

	class cipher {
	private:
		std::string normalized_plaintext;
		std::vector<std::string> segmented_plaintext;
		std::size_t columns{ 0 };
		std::size_t rows{ 0 };
	public:
		explicit cipher(std::string_view plaintext);

		std::string normalize_plain_text();
		std::string normalized_cipher_text();

		std::vector<std::string> plain_text_segments();
		std::vector<std::string> cipher_text_segments();

		std::string cipher_text();
	};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H