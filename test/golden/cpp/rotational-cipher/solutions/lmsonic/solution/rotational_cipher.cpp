#include "rotational_cipher.h"
#include <algorithm>
#include <cctype>
#include <cstddef>
#include <iterator>
#include <string>

namespace rotational_cipher {

std::string rotate(const std::string &plaintext, int rotation) {
  const std::string alphabet{"abcdefghijklmnopqrstuvwxyz"};

  rotation %= alphabet.size();
  auto cypher = [&alphabet, rotation](char c) -> char {
    if (!std::isalpha(c)) {
      return c;
    }
    bool isupper = false;
    if (std::isupper(c)) {
      c = std::tolower(c);
      isupper = true;
    }
    size_t index = alphabet.find(c);
    size_t rotated_index = (index + rotation) % alphabet.size();

    char letter = alphabet[rotated_index];
    if (isupper) {
      return std::toupper(letter);
    } else {
      return letter;
    }
  };
  std::string cyphertext{};
  std::transform(plaintext.begin(), plaintext.end(),
                 std::back_inserter(cyphertext), cypher);
  return cyphertext;
}

} // namespace rotational_cipher
