#include "run_length_encoding.h"

#include <sstream>

namespace run_length_encoding {

    struct pair {
        int seen;
        char letter;
    };

    static void append_pair_to_string(std::string& input, const pair& to_emplace) {
        if (to_emplace.seen > 1)
            input += (std::to_string(to_emplace.seen));
        input += (to_emplace.letter);
    } 
    
    std::string encode(std::string_view input) {
        std::string result{};
    
        pair to_emplace = {0, input[0]};
        for (const auto& el : input) {
            if (el != to_emplace.letter) {
                append_pair_to_string(result, to_emplace);
                to_emplace.seen = 0;
                to_emplace.letter = el;
            }
            to_emplace.seen++;
        }
        if (to_emplace.seen != 0)
            append_pair_to_string(result, to_emplace);
    
        return result;
    }
    
    std::string decode(std::string_view input) {
        std::stringstream output;
        int number = 0;
        for (const auto& el : input) {
            if (std::isdigit(el)) {
                number = number / 10 + (el - '0');
                continue;
            }
            if (!number)
                number = 1;
            while(number--)
                output << el;
    
    
            number = 0;
        }

        return output.str();
    }

}  // namespace run_length_encoding
