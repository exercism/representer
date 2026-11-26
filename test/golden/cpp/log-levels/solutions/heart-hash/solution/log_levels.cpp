#include <string>

namespace log_line {

    std::string message( const std::string& logEntry){
        size_t log_content_location{logEntry.find(':') + 2};
        return logEntry.substr(log_content_location);
    }

    std::string log_level( const std::string& logEntry){
        size_t left_square_position{logEntry.find('[') + 1};
        size_t right_square_position{logEntry.find(']') - 1};

        return logEntry.substr(left_square_position, right_square_position);
    }

    std::string reformat ( const std::string& logEntry ) {
        size_t left_square_position{logEntry.find('[') + 1};
        size_t right_square_position{logEntry.find(']') - 1};
        size_t log_content_location{logEntry.find(':') + 2};

        return logEntry.substr(log_content_location) +
            " (" + logEntry.substr(left_square_position,right_square_position) + ')';
    }

} // namespace log_line
