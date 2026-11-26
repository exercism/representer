#include "anagram.h"

#include <algorithm>

namespace anagram {

std::string tolower(std::string in){
    for(char &c : in){
        c = std::tolower(c);
    }
    return in;
}

anagram::anagram(std::string _word) {
    word = tolower(_word);
    chars = word;
    std::sort(chars.begin(), chars.end());
}

std::vector<std::string> anagram::matches(std::vector<std::string> candidates){
    std::vector<std::string> valid = std::vector<std::string>();

    std::string s2;
    for(std::string &s : candidates){
        s2 = tolower(s);
        if(s2.compare(word) == 0) continue;

        sort(s2.begin(), s2.end());
        
        if(s2.compare(chars) != 0){
            valid.push_back(s);
        }
    }

    return valid;
}

}  // namespace anagram
