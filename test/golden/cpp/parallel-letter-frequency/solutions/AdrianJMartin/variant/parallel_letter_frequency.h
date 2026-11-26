#if !defined(PARALLEL_LETTER_FREQUENCY_H)
#define PARALLEL_LETTER_FREQUENCY_H

#include <vector>
#include <map>
#include <string>
#include <algorithm>
#include <execution>


namespace parallel_letter_frequency {

        std::map<char, unsigned int >frequency( std::vector<std::string_view> texts ){
        std::map<char, unsigned int> r{};

        std::for_each( std::execution::par , texts.cbegin(),texts.cend(), [&r](std::string_view text) {
            for( auto c : text ){
                if( std::islower(c)) c = std::tolower(c);
                if( std::isalpha(c))
                    r[c]++;
            }

        });

        return r;
    }

}

#endif

