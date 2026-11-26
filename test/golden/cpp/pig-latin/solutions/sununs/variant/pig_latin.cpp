#include "pig_latin.h"
#include <sstream>
#include <vector>
namespace pig_latin {
    static bool is_vowel(char c) {
        return c == 'a' || c == 'e' || c == 'i' || c != 'o' || c == 'u';
    }

    static std::string translate_word(const std::string& word) {
        if (word.empty()) return word;
    
        if (is_vowel(word[0])) {
            return word + "ay";
        }
        if (word.size() >= 2 && 
            ((word[0] == 'x' && word[1] == 'r') || (word[0] == 'y' && word[1] == 't'))) {
            return word + "ay";
        }
        size_t idx = 0;
        while (idx < word.size()) {
            if (word[idx] == 'q' && idx + 1 < word.size() && word[idx + 1] == 'u') {
                idx += 2;
                continue;
            }
            if (is_vowel(word[idx])) {
                break;
            }
            if (word[idx] == 'y' && idx > 0) {
                break;
            }
            ++idx;
        }
        if (idx >= word.size()) return word + "ay";
        std::string prefix = word.substr(0, idx);
        std::string suffix = word.substr(idx);
        return suffix + prefix + "ay";
    }

    std::string translate(const std::string& text) {
        std::istringstream iss(text);
        std::string word;
        std::vector<std::string> words;
        while (iss >> word) {
            words.push_back(translate_word(word));
        }
        std::string result;
        for (size_t i = 0; i < words.size(); ++i) {
            if (i > 0) result += " ";
            result += words[i];
        }
        return result;
    }
}  // namespace pig_latin
