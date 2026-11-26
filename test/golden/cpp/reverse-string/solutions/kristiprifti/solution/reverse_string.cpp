#include "reverse_string.h"

namespace reverse_string {
    std::string reverse_string (const std::string &myStr) {
        std::string newStr = "";
        for (size_t i{ myStr.size() - 1 }; i < myStr.size(); i--) {
            newStr = newStr + myStr[i];
        }
        return newStr;

    }

}  // namespace reverse_string
