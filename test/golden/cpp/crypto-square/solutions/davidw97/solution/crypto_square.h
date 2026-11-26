#ifndef CRYPTO_SQUARE_CRYPTO_SQUARE_H
#define CRYPTO_SQUARE_CRYPTO_SQUARE_H

#include <utility>
#include "vector"
#include "string"

namespace crypto_square
{
    using namespace std;

    class cipher
    {
    public:
        explicit cipher(string input)
        {
            _input = sanitize(std::move(input));
            _cipher = encode();
        }

        string normalize_plain_text()
        {
            return _input;
        }
        vector<string> plain_text_segments();
        string normalized_cipher_text();
        string cipher_text();

    private:
        string _input;
        vector<string> _cipher;

        static string sanitize(string input);
        vector<string> encode();
    };
}

#endif //CRYPTO_SQUARE_CRYPTO_SQUARE_H
