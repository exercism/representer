#include "acronym.h"

char *abbreviate(const char *phrase)
{
    if (phrase == NULL)
    {
        return NULL;
    }
    if (phrase[0] == '\0')
    {
        return NULL;
    }
    int position = 0;
    int me_length = 0;
    while (phrase[position] != '\0')
    {
        if (isalpha(phrase[position]) == 0)
        {
            me_length++;
        }
        position++;
    }
#if 0
    static char me_string[50];
    static char *me = me_string;
#endif
    char *me = malloc((me_length + 1) * sizeof(char));
    for (int i = 0; i < me_length; i++)
    {
        /* code */
        me[i] = '\0';
    }

    position = 0;
    me_length = 0;
    bool previous_character_nonprinting = true;
    while (phrase[position] != '\0')
    {
        if ((previous_character_nonprinting == true) && (isalpha(phrase[position]) == 1))
        {
            /* TLA's are UPPERCASE */
            me[me_length] = toupper(phrase[position]);
            me_length++;
        }
        if (phrase[position] == '\'')
        {
            previous_character_nonprinting = false;
        }
        else if (isalpha(phrase[position]) == 0)
        {
            previous_character_nonprinting = true;
        }
        else
        {
            previous_character_nonprinting = false;
        }
        position++;
    }
    me[me_length] = '\0';
    return me;
}
