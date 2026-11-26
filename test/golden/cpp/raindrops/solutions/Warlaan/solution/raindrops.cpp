#include "raindrops.h"
#include <cstdio>

namespace raindrops {
    std::string convert(int input)
    {
        std::string retVal = "";

        if (input % 3 == 0)
        {
            retVal += "Pling";
        }
        if (input % 5 == 0)
        {
            retVal += "Plang";
        }
        if (input % 7 == 0)
        {
            retVal += "Plong";
        }

        if (retVal == "")
        {
            retVal = std::to_string(input);
        }

        return retVal;
    }
}  // namespace raindrops
