#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H

#include <algorithm>
#include <cmath>
#include <iostream>
#include <string>
#include <vector>

namespace crypto_square {

using namespace std;

class cipher
{
public:
    cipher(string const& s)
    :original(s)
    {}

    string normalize_plain_text() const
    {
        string s{original};
        transform(begin(s),end(s),begin(s),::tolower);
        s.erase(remove_if(begin(s),end(s),[](char c){return !isalnum(c);}),end(s));
        return s;
    }

    vector<string> plain_text_segments() const
    {
        vector<string> v;
        auto const norms{normalize_plain_text()};
        if( norms.empty()) return {};
        int cols{int(ceil(sqrt(float(norms.size()))))};
        //int rows{(norms.size()%cols==0)?cols:(cols-1)};
        for (auto a{0U}; a < norms.size(); a+=cols)
            v.emplace_back(norms.substr(a,cols));
        return v;
    }
    string normalized_cipher_text(const char* const fill=" ") const
    {
        string cipher;
        auto const normvector{plain_text_segments()};
        if (normvector.empty()) return {};
        for (auto c{0U};c<normvector[0].size();c++) {
            for(auto s: normvector) {
                if (c<s.size())
                    cipher.append(1,s[c]);
                else
                    cipher.append(fill);
            }
            if (c<normvector[0].size()-1)
                cipher.append(fill);
        }
        return cipher;
    }
    string cipher_text() const
    {
        return normalized_cipher_text("");
    }

private:
    string const original;
};


}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H