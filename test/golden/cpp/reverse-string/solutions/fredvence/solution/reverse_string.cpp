#include "reverse_string.h"

namespace reverse_string {

    std::string reverse_string(std::string s){
        std::string r_string{};

        for (std::string::reverse_iterator  rit = s.rbegin() ; rit != s.rend(); ++rit){
            r_string.push_back(*rit);
        }

        return r_string;
    }

}  // namespace reverse_string
