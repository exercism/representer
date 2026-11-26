#include "isbn_verifier.h"
#include <string>

namespace isbn_verifier {

bool is_valid(std::string isbn)
{
    int verify = 0;
    int digit = 10;
    
    for(auto num : isbn) 
    {
        if(isdigit(num)) 
            verify += (num - '0') * digit;
        else if (num == 'X' && digit == 1) 
            verify += 10 * digit;
        else if (num == '-') 
            continue;
        else 
            return false;
        digit -= 1;
    }
    return (digit == 0 && verify % 11 == 0);
}
}  // namespace isbn_verifier