#include "crypto_square.h"

#include <cctype>
#include <cmath>

namespace crypto_square {

  cipher::cipher(const string message) : row(0), col(0), size(0)
  {
    // Detect the NULL case - no message
    if (message.empty())
      return;

    // strip the space & puntuation and set everything to lowercase
    string msg;
    for (auto c : message) {
      if (isspace(c) || ispunct(c))
        continue;
      msg += tolower(c);
    }

    // determine the rows & column info
    size = msg.size();
    double sqrt_res = sqrt(size);
    row = round(sqrt_res);
    col = ceil(sqrt_res);

    // populate the string vector - no padding
    // do not add any extra spaces to pad final string
    int idx = 0;
    for (int r=0; r<row; ++r,idx+=col) {
      code.push_back(msg.substr(idx,col));
    }
  }

  string cipher::normalize_plain_text() {
    string msg;
    for (int i=0; i<row; ++i)
      msg += code[i];   // concatenate the strings

    return msg;
  }

  string cipher::cipher_text() {
    string msg;
    if (size) {
      for( int c=0; c<col; ++c) {
        for( int r=0; r<row; ++r) {

          // the last row may be short a few characters (need space padding)
          // detect the situation (column beyond actual string size)
          if (c < (int)code[r].size())
            msg += code[r][c];
        }
      }
    }

    return msg;
  }
  string cipher::normalized_cipher_text() {
    string msg;
    if (size) {
      for( int c=0; c<col; ++c) {
        for( int r=0; r<row; ++r) {

          // the last row may be short a few characters (need space padding)
          // detect the situation (column beyond actual string size)
          if (c < (int)code[r].size())
            msg += code[r][c];
          else
            msg += ' ';     // insert padding
        }
        if ((c+1)<col) // avoid a final space at end of msg
          msg += ' ';
      }
    }
    return msg;
  }

}  // namespace crypto_square
