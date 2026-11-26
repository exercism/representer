#include "isogram.h"
#include <regex>
#include <set>
namespace isogram
{
    static std::regex SPECIAL_CHARS("-| ");
    bool is_isogram(const std::string &word)
    {
        std::string cleanWord = std::regex_replace(word, SPECIAL_CHARS, "");
        std::transform(cleanWord.begin(), cleanWord.end(), cleanWord.begin(), [](unsigned char c)
                       { return std::tolower(c); });
        std::set<char> letters(cleanWord.cbegin(), cleanWord.cend());
        return letters.size() == cleanWord.size();
    }
} // namespace isogram
