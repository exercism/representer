#include <string>
using namespace std;
namespace log_line {
	string message(string log) {
		int pos = log.find("]: ");
		return log.substr(pos + 3);
	}
	string log_level(string log) {
		int start = log.find("[") + 1;
		int last = log.find("]") - 1;
		return log.substr(start, last);
	}
	string reformat(string log) {
		return message(log) + " (" + log_level(log) + ")";
	}
} // namespace log_line
