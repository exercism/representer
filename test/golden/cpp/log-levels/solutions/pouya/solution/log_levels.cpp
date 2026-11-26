#include <string>

namespace log_line {
  std::string message(const std::string& msg) {
    int start_point = msg.find(" ");
    return msg.substr(start_point + 1);
  }

  std::string log_level(const std::string& msg) {
    int stop_point = msg.find("]");
    return msg.substr(1, stop_point - 1);
  }

  std::string reformat(const std::string& msg) {
    std::string log_message = message(msg);
    std::string level = log_level(msg);
    return log_message + " (" + level + ")";
  }
} // namespace log_line
