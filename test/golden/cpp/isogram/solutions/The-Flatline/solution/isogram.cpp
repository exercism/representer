#include "isogram.h"

namespace isogram {
void Remove_Spaces_Dashes(string& input)
{

    for (int i = 0; i < (int)input.size(); i++)
    {
        if(input[i] == ' ' || input[i] == '-')
        {
            input.erase(input.begin() + i);
            i--;
        }
    }

}

bool is_isogram(string input)
{
    Remove_Spaces_Dashes(input);
    
    for (int i = 0; i < (int)input.length(); i++)
    {
        input[i] = tolower(input[i]);
    }

    sort(input.begin(), input.end());

    for(int i = 0; i < (int)input.size(); i++)
    {
        if(input[i] == input[i+1])
        {
            return false;
        }
    }
    
    return true;
}
}  // namespace isogram
