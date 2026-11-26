#include "crypto_square.h"

#include <algorithm>

namespace crypto_square {

std::string cipher::normalize_plain_text() {
	std::string an_mes, low_mes;
	std::copy_if(message_.begin(), message_.end(), 
			std::back_inserter(an_mes), isalnum);
	std::transform(an_mes.begin(), an_mes.end(), 
			std::back_inserter(low_mes), tolower);
	return low_mes;
}

std::vector<std::string> cipher::plain_text_segments() {
	std::vector<std::string> segments;
	std::string low_mes = normalize_plain_text();
	while (square_size * square_size < low_mes.size()) {
		++square_size;
	}
	for (size_t pos = 0 ; pos < low_mes.size() ; pos += square_size) {
		segments.push_back(low_mes.substr(pos, square_size));
	}
	return segments;
}

std::string cipher::cipher_text() {
	std::string cipher;
	std::vector<std::string> segments = plain_text_segments();
	for (size_t col = 0 ; col < square_size ; col++) {
		for (auto segment : segments) {
			if (segment.size() > col) {
				cipher += segment[col];
			}
		}
	}
	return cipher;
	}

std::string cipher::normalized_cipher_text() {
	std::string norm_cipher;
	std::vector<std::string> segments = plain_text_segments();
	for (size_t col = 0 ; col < square_size ; col++) {
		for (auto segment : segments) {
			norm_cipher += segment.size() > col ? segment[col] : ' ';
		}
		if (col < square_size - 1) {
			norm_cipher += " ";
		}
	}
	return norm_cipher;
}

}  // namespace crypto_square










