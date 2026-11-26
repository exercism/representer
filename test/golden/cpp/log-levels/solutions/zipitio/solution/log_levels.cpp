#include <string>

namespace log_line {

    std::string message(std::string log) {
        int first_index = log.find(":") + 2;
        std::string log_message = log.substr(first_index);
        return log_message;
        
    }
    std::string log_level(std::string log) {
        int first_index = log.find("[") + 1;
        std::string new_log = log.substr(first_index);
        int second_index = log.find("]") - 1;
        new_log = new_log.substr(0, second_index);
        return new_log;
    }

    std::string reformat(std::string log) {
        std::string reformated_message = log_line::message(log) + " (" + log_line::log_level(log) + ")";
        return reformated_message;
    }

} // namespace log_line
