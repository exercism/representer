#include "crypto_square.h"

#include <ctype.h>
#include <cmath>
#include <algorithm>

namespace crypto_square {
    bool isalphanum(unsigned char c) {
    	return std::isalnum(c);
    }
    
    char to_lower(unsigned char c) {
    	return std::tolower(c);
    }
	
	cipher::cipher(std::string_view plaintext) : normalized_plaintext{plaintext} {
        normalized_plaintext.erase(std::remove_if(
                                        normalized_plaintext.begin(),
                                        normalized_plaintext.end(),
                                        [](unsigned char c){return !isalphanum(c);}
                                   ),
                                   normalized_plaintext.end());
        std::transform(
            normalized_plaintext.begin(),
            normalized_plaintext.end(),
            normalized_plaintext.begin(),
            to_lower
        );
		
		if (normalized_plaintext.empty())
			return;

        columns = ceil(sqrt(normalized_plaintext.length()));
        rows = ceil((1.0 * normalized_plaintext.length()) / columns);

		for (size_t row = 0; row < rows; row++) {
			segmented_plaintext.push_back(normalized_plaintext.substr(row * columns, columns));
		}
	}

	std::string cipher::normalize_plain_text() {
		return normalized_plaintext;
	}

	std::string cipher::normalized_cipher_text() {
		if (normalized_plaintext.empty())
			return "";

		std::string ciphertext{ "" };
		std::vector<std::string> cipher_segments = cipher_text_segments();

		for (std::string segment : cipher_segments) {
			if (segment.size() < rows)
				ciphertext += segment + " ";
			else
				ciphertext += segment;
			ciphertext += " ";
		}

		ciphertext.erase(ciphertext.end() - 1);
		return ciphertext;
	}

	std::string cipher::cipher_text() {
		if (normalized_plaintext.empty())
			return "";

		std::string ciphertext{ "" };
		std::vector<std::string> cipher_segments = cipher_text_segments();
		
		for (std::string segment : cipher_segments)
			ciphertext += segment;
		
		return ciphertext;
	}

	std::vector<std::string> cipher::plain_text_segments() {
		return segmented_plaintext;
	}

	std::vector<std::string> cipher::cipher_text_segments() {
		std::vector<std::string> segments{};

		for (std::size_t column = 0; column < columns; column++) {
			std::string cipher_segment{};
			for (std::string segment : segmented_plaintext) {
				if (column < segment.size())
					cipher_segment.push_back(segment.at(column));
			}
			segments.push_back(std::move(cipher_segment));
		}
		
		return segments;
	}

}  // namespace crypto_square
