#include <string>
namespace log_line {
std::string message(std::string logLine){
    int num = logLine.find(":"); //7
    std::string message = logLine.substr(num+2);
        return message; //[ERROR]: Stack overflow
}
std::string log_level(std::string logLine){
    int num = logLine.find(":");
    std::string log_level = logLine.substr(1,num-2);
        return log_level;
}
std::string reformat(std::string logLine){
    int num = logLine.find(":");
    std::string reformat = logLine.substr(num+2) + " ("+logLine.substr(1,num-2)+")" ;
    return reformat;
}
} // namespace log_line
