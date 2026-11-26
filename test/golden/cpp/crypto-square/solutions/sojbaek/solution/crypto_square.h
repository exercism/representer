#if !defined(CRYPTO_SQUARE_H)
#define CRYPTO_SQUARE_H
#include <string>
#include <vector>
#include <cmath>

using namespace std;

namespace crypto_square {

class cipher {
    string phrase;
    vector<string> segments;
    vector<string> cipheredsegments;
    unsigned int nrow, ncol;
    string normalized_plain_text;
public:
    cipher(string _phrase): phrase(_phrase) {
        for(char& c:_phrase)
        {   
            char lc = ::tolower(c);
            if ((lc>='a' && lc <='z') || (lc<='9' && lc>='0')) {
                normalized_plain_text += lc;
            }
        }
        segments = plain_text_segments();
    }

    string normalize_plain_text() {
        return normalized_plain_text;
    }

    vector<string> plain_text_segments(){
       vector<string> seg;
       string input = normalize_plain_text();
       unsigned int nlength= input.length();
       ncol = (unsigned int) ::ceil(::sqrt((double) nlength));
       nrow = (unsigned int) ::ceil((double) nlength/ (double) ncol);
       if (nlength==0) return seg;
         for (unsigned int ifrom = 0; ifrom< nlength; ifrom += ncol) {
            unsigned int  ilen = (ifrom + ncol >= nlength) ? (nlength-ifrom+1) : ncol;
            seg.push_back(input.substr(ifrom, ilen));
        }
        return seg;   
    }

    string normalized_cipher_text() {
        string cip = cipher_text();
        string nct;
        for (unsigned int ii=0; ii< cipheredsegments.size(); ii++) {
            if (ii != 0) nct += " ";
            nct += cipheredsegments[ii];
        }
        return nct;
     }

    string cipher_text() { 
        string cipher;
        for (unsigned int jj=0; jj<ncol; jj++) {
            string colstring;
            for (unsigned int ii=0; ii<nrow; ii++) {
                if (jj< segments[ii].length()) {
                    cipher += segments[ii][jj];
                    colstring += segments[ii][jj];
                } else colstring += ' '; 
            }
            cipheredsegments.push_back(colstring);
        }
        return cipher;
     }
};

}  // namespace crypto_square

#endif // CRYPTO_SQUARE_H