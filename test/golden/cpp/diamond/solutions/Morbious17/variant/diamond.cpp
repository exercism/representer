#include "diamond.h"
#include <cctype>

namespace diamond {
    std::vector<std::string> rows(char c)
    {
        c = toupper(c);

        if(c == 'A')
        {
            return {std::string{c}};
        }
        
        int length = 1 + (c - 'A') * 2;

        std::vector<std::string> allRows(length, {std::string(length, ' ')});

        if(!isalpha(c))
        {
            return allRows;
        }
        
        int center = length / 2;

        for(int i = 0; i < length - center; ++i)
        {
            allRows[center + i][length - 1 - i] = c;
            allRows[center + i][i] = c;
            allRows[center - i][length - 1 - i] = c;
            allRows[center + i][i] = c;

            --c;
        }
   
        return allRows;
    }
}  // namespace diamond
