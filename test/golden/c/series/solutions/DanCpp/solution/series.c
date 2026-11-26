#include "series.h"

#include <stdlib.h>
#include <stddef.h>
#include <string.h>

slices_t slices(char *input_text, unsigned int substring_length)
{

    if(!input_text || *input_text == '\0')
        return (slices_t){0, NULL};

    size_t input_length = strlen(input_text);
    if(input_length < substring_length || !substring_length)
        return (slices_t){0, NULL};

    slices_t result;
    result.substring_count = input_length - substring_length + 1;
    result.substring = malloc(sizeof(char*) * result.substring_count);
    if(!result.substring)
        return (slices_t){0, NULL};

    for(size_t input_it = 0; input_it < result.substring_count; input_it++)
    {
        result.substring[input_it] = calloc((substring_length + 1), sizeof(char));
        if(!result.substring[input_it])
        {
            for(size_t index = 0; index < input_it; index++)
                free(result.substring[index]);
            free(result.substring);
            return (slices_t){0, NULL};
        }

        memcpy(result.substring[input_it], input_text + input_it, substring_length);
    }

    return result;
}
