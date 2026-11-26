#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

namespace crypto_square {
    class cipher {
        string normalized;
        unsigned col;
        unsigned row;
        vector<string> block;

        string normalize(const string& plain) {
                string normal(plain);
                // for( unsigned i = 0; i < normal.size(); ++i ) {
                //     char c = normal[i];
                //     normal[i] = tolower(c);
                // }
                transform(normal.begin(), normal.end(), normal.begin(), ::tolower);
                normal.erase(remove_if(
                                     normal.begin(),
                                     normal.end(),
                                     [](unsigned char x) {
                                        return !(isalpha(x) || isdigit(x));
                                     }),
                                 normal.end());
                return normal;
        };

        void set_block() {
            for(unsigned i = 0; i < row; ++i) {
               block.push_back(normalized.substr((i*col), col));
            }
        }

        public:
            cipher(const string& init):
                normalized(normalize(init)),
                col(0),
                row(0)
            {
                unsigned len = normalized.size();
                if (init.size() == 0) {
                    return;
                }

                while ((col * row) < len) {
                    if (col == row) {
                        ++col;
                    } else {
                        ++row;
                    }
                }

                set_block();
            };

            const string& normalize_plain_text() {
                return normalized;
            };

            const vector<string>& plain_text_segments() {
                return block;
            };

            const string cipher_text() {
                string ret;
                for(unsigned c = 0; c < col; ++c) {
                    for(unsigned r = 0; r < row; ++r) {
                        if (c < block[r].size())
                            ret.push_back(block[r][c]);
                    }
                }
                return ret;
            };

            const string normalized_cipher_text() {
                string ret;
                for(unsigned c = 0; c < col; ++c) {
                    for(unsigned r = 0; r < row; ++r) {
                        if (c < block[r].size()) {
                            ret.push_back(block[r][c]);
                        } else {
                            ret.push_back(' ');
                        }
                    }
                    if (c < (col -1))
                        ret.push_back(' ');
                }
                return ret;
            };

    };
}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H
