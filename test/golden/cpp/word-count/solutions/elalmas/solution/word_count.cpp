#include "word_count.h"

#include <algorithm>
#include <regex>

#include <cctype>

namespace word_count {
constexpr const char *REGEX = "\\w+(?:'\\w+)?";
map<string, int> words(const string &text) {
  map<string, int> count;
  regex re(REGEX);

  for (sregex_token_iterator it(text.begin(), text.end(), re), end; it != end;
       ++it) {
    string word(*it);
    transform(word.cbegin(), word.cend(), word.begin(), ::tolower);
    ++count[word];
  }

  return count;
}
}  // namespace word_count
