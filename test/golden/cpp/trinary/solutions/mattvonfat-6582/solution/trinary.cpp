#include "trinary.h"

namespace trinary {
    int to_decimal(std::string_view number_string)
    {
        int result{0};

        for (auto number : number_string)
        {
            if (number < '0' || number > '2')
            {
                return 0;
            }
            
            result = (result * 3) + (number-'0');
        }

        return result;
    }
}  // namespace trinary
