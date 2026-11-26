#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <string>
#include <vector>

namespace crypto_square {

  using namespace std;

  class cipher {

    int row;    // rows or count of strings in vector
    int col;    // columns or count of chars in strings
    int size;   // total size - exact count of chars (last string my be short a few)

    vector<string> code;

    public:
    // ctor
    cipher(const string message);

    string normalize_plain_text();
    string cipher_text();
    string normalized_cipher_text();

    vector<string>plain_text_segments() { return code; }
};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H
