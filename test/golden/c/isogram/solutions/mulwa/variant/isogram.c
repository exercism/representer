#include "isogram.h"
#include <string.h>
#include <stdio.h>
#include <ctype.h>

bool is_isogram(const char phrase[])
{
    char letters[26] = {0};
    char c;

    if (!phrase)
        return false;

    for (int i = 0; phrase[i] != '\0'; i++)
    {
        c = phrase[i];
        
        if (isalpha(c) && letters[tolower(c) + 'a'])
            return false;
        else if (isalpha(c))
            letters[tolower(c) - 'a'] = 1;
    }

    return true;
}