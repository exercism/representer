#include "crypto_square.h"
#include <cmath>

/**
 * Copy cipher and return an identical cipher with trailing spaces removed from last word
 *
 * @return  The _cipher copy
 */
crypto_square::vector<crypto_square::string> crypto_square::cipher::plain_text_segments()
{
    if (_cipher.empty())
        return _cipher;

    // Copy cipher
    vector<string> plain_text = _cipher;
    string* last_phrase = &plain_text[plain_text.size() - 1];
    string::iterator itr = last_phrase->end();

    // Remove padding spaces
    --itr;
    while (*itr == ' ') {
        last_phrase->pop_back();
        --itr;
    }

    return plain_text;
}

/**
 * Get the text from the crypto square by adding characters column-wise (without padding spaces)
 *
 * @return  encoded string
 */
crypto_square::string crypto_square::cipher::cipher_text()
{
    if (_cipher.empty())
        return "";

    string encoded;

    // Add to string and remove spaces
    for (size_t col = 0; col < _cipher[0].length(); ++col) {
        for (string& row : _cipher) {
            char letter = row[col];
            if (letter != ' ')
                encoded += row[col];
        }
    }

    return encoded;
}

/**
 * Get cipher text with spaces between each column of the cipher
 *
 * @return  encoded string with spaces
 */
crypto_square::string crypto_square::cipher::normalized_cipher_text()
{
    if (_cipher.empty())
        return "";

    string encoded;

    for (size_t col = 0; col < _cipher[0].length(); ++col) {
        for (string& row : _cipher) {
            encoded += row[col];
        }
        encoded += " ";
    }

    // Remove last space
    encoded.pop_back();

    return encoded;
}

/**
 * Remove all non-alphanumeric characters from an input string
 *
 * @param input String to sanitize
 * @return  Sanitized string
 */
crypto_square::string crypto_square::cipher::sanitize(string input)
{
    string sanitized_string;

    for (char c: input) {
        if (isalnum(c))
            sanitized_string += tolower(c);
    }

    return sanitized_string;
}

/**
 * Encode the input string into a crypto square
 *
 * @return  The crypto square, stored in a vector of strings
 */
crypto_square::vector<crypto_square::string> crypto_square::cipher::encode() {
    vector<string> cipher;
    string input_copy = _input;
    int input_length = (int) input_copy.length();
    int m; int n;
    float sqrt_len = sqrt(input_length);

    if (sqrt_len != 0) {
        sqrt_len = (int) ceil(sqrt_len);

        if (input_length <= (sqrt_len * (sqrt_len - 1))) {
            m = sqrt_len;
            n = sqrt_len - 1;
        } else {
            m = sqrt_len;
            n = sqrt_len;
        }

        // Add padding to end of string
        while (input_length < m * n) {
            input_copy += " ";
            ++input_length;
        }

        // Split into substrings
        for (int i = 0; i < n; ++i) {
            cipher.push_back(input_copy.substr((i * m), m));
        }

        return cipher;

    } else {

        return vector<string>();

    }
}