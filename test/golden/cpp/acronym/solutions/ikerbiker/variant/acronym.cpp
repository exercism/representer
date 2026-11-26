#include "acronym.h"

namespace acronym {

    std::string acronym(std::string phrase) {
        if (phrase.length() == 0) return "";
        std::string buffer = "";

        bool first_char = true;
        for (char c : phrase) {
            if (isalpha(c) || first_char) {
                buffer.push_back(toupper(c));
                first_char = false;
            } else if (isspace(c) || c == '-')
                first_char = true;
        }
        return buffer;
    }

}  // namespace acronym
