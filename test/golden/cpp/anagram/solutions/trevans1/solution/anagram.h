#if !defined(ANAGRAM_H)
#define ANAGRAM_H

#include <string>
#include <vector>

namespace anagram {

class anagram{
    public:
        anagram(std::string word);  // constructor

        std::vector<std::string> matches(std::vector<std::string> candidates);

    private:
        std::string chars;  // characters in word, sorted alphabetically
        std::string word; // original word
};

}  // namespace anagram

#endif // ANAGRAM_H