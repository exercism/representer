#include "atbash_cipher.h"

namespace atbash_cipher {
	std::string plain{ "abcdefghijklmnopqrstuvwxyz" };
	std::string cipher{ "zyxwvutsrqponmlkjihgfedcba" };

	std::string encode(std::string word) {
		std::string encoded{ "" };
		int chars_added{ 0 };
		for (size_t i{ 0 }; i < word.length(); ++i) {
			// The second check avoid the program to add withespace to the end of the encoded word when 
			// a withespace should be added but the loop is at the end of the line
			if (chars_added == 5 && i != word.length()+1) {
				encoded += " ";
				chars_added = 0;
			}

			if ((std::isspace(word[i])) || (std::ispunct(word[i])))
				continue;
			else if ((int)plain.find(tolower(word[i])) != -1) {
				encoded += cipher[plain.find(tolower(word[i]))];
				++chars_added;
			}
			else {
				encoded += word[i];
				++chars_added;
			}

		}
		return encoded;
	}

	std::string decode(std::string word) {
		std::string decoded{ "" };

		for (size_t i{ 0 }; i < word.length(); ++i) {
			if (std::isspace(word[i]))
				continue;
			else if ((int)cipher.find(word[i]) != -1)
				decoded += plain[cipher.find(word[i])];
			else
				decoded += word[i];
		}
		return decoded;

	
	}
}  // namespace atbash_cipher
