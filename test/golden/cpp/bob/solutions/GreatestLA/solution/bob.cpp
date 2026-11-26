#include "bob.h"
#include <algorithm>
#include <cctype>

namespace bob {
// TODO: add your solution here
static std::string trim(const std::string& s) {
    auto first = s.find_first_not_of(" \t\n\r\f\v");
    if (first == std::string::npos) return "";
    auto last = s.find_last_not_of(" \t\n\r\f\v");
    return s.substr(first, last - first + 1);
}

std::string hey(const std::string& input) {
    std::string msg = trim(input);
    if (msg.empty()) {
        return "Fine. Be that way!";
    }

    bool isQuestion = (msg.back() == '?');

    bool hasLetter = false;
    bool allUpper   = true;
    for (char c : msg) {
        if (std::isalpha(static_cast<unsigned char>(c))) {
            hasLetter = true;
            if (!std::isupper(static_cast<unsigned char>(c))) {
                allUpper = false;
            }
        }
    }

    bool isYell = hasLetter && allUpper;

    if (isYell && isQuestion) {
        return "Calm down, I know what I'm doing!";
    }
    if (isYell) {
        return "Whoa, chill out!";
    }
    if (isQuestion) {
        return "Sure.";
    }
    return "Whatever.";
}

}  // namespace bob
