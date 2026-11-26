#include <string>
#include <iostream>

namespace log_line {

    std::string message(std::string input) {
        int MessageIndex = input.find(":") - 2;
        return input.substr(MessageIndex,input.size());
    }

    std::string log_level(std::string input) {
        int LevelIndex = input.find("]") - 1;
        return input.substr(1,LevelIndex);
    }

    std::string reformat(std::string input) {
        return message(input) + " (" + log_level(input) + ")";
    }

} // namespace log_line
